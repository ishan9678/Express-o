import SwiftUI
import PencilKit
import Firebase

struct SketchingTestView: View {
    @State var canvas = PKCanvasView()
    @State var drawingData: Data?
    @State var isShowingCanvas = false
    @State var title = ""
    @State private var showingAlert = false
    @State var alertMessage = ""
    var drawingID: String
    @Environment(\.presentationMode) var presentationMode
    @State var prompt = "Describe the following doodle in second person, taking into account its composition, colors, and overall mood. Try to infer the emotions you might be feeling and why, based on the elements present in the doodle. Give the output in format 'description: | emotions: ' where emotions is a list of emotions as emojis."


    
    init(canvas: PKCanvasView = PKCanvasView(), drawingData: Data? = nil, title: String = "", drawingID: String = "") {
           self._canvas = State(initialValue: canvas)
           self._drawingData = State(initialValue: drawingData)
           self._title = State(initialValue: title)
           self.drawingID = drawingID
    }

    var body: some View {
        NavigationStack{
            VStack {
                PencilKitView(canvas: $canvas, drawingData: $drawingData)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                //BottomNavBarView()
            }
            .toolbar{
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    if let image = drawingToImage() {
                        NavigationLink(destination: EmotionInsightsView(prompt: prompt, image: image)) {
                            HStack {
                                Text("Emotion Insights")
                                Image(systemName: "face.smiling")
                            }
                        }
                    }

                    
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Save") {
                            updateDrawingToFirebase(drawingId: drawingID)
                        }
                        Button("Save as") {
                            isShowingCanvas = true
                        }
                        Button("Delete") {
                            deleteDrawingFromFirebase(drawingId: drawingID)
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .padding()
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                // Load drawing data if available
                let drawingData: () = // Load drawing data from wherever it's stored
                self.drawingData = drawingData
                canvas.setNeedsDisplay()
            }
            .sheet(isPresented: $isShowingCanvas) {
                SaveDrawingView(canvas: $canvas, drawingData: $drawingData, title: $title)
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    func drawingToImage() -> UIImage? {
        guard let drawingData = drawingData?.base64EncodedString(),
              let data = Data(base64Encoded: drawingData) else {
            print("Invalid drawing data")
            return nil
        }

        do {
            let drawing = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            if let drawing = drawing as? PKDrawing {
                let scale = UIScreen.main.scale
                let image = drawing.image(from: drawing.bounds, scale: scale)
                return image
            } else {
                print("Failed to unarchive PKDrawing")
                return nil
            }
        } catch {
            print("Error unarchiving PKDrawing: \(error)")
            return nil
        }
    }

    
    func updateDrawingToFirebase(drawingId: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }

        let db = Firestore.firestore()
        let drawingsRef = db.collection("drawings").document(userId)
        
        let drawingData = try? NSKeyedArchiver.archivedData(withRootObject: canvas.drawing, requiringSecureCoding: false)
        let drawingDataString = drawingData?.base64EncodedString() ?? ""


        drawingsRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var drawingsMap = document.data() ?? [:]

                if var drawingToUpdate = drawingsMap[drawingId] as? [String: Any] {
                    // Update the drawing data
                    drawingToUpdate["drawingData"] = drawingDataString

                    // Update the drawing in the drawings map
                    drawingsMap[drawingId] = drawingToUpdate

                    // Save the updated drawings map to Firestore
                    drawingsRef.setData(drawingsMap) { error in
                        if let error = error {
                            print("Error updating drawing: \(error)")
                            self.showingAlert = true
                            self.alertMessage = "Error updating drawing: \(error.localizedDescription)"
                        } else {
                            print("Drawing updated successfully")
                        }
                    }
                } else {
                    print("Drawing with ID \(drawingId) not found")
                    self.showingAlert = true
                    self.alertMessage = "Drawing with ID \(drawingId) not found"
                }
            } else {
                print("Document does not exist")
                self.showingAlert = true
                self.alertMessage = "Document does not exist"
            }
        }
    }

    func deleteDrawingFromFirebase(drawingId: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }

        let db = Firestore.firestore()
        let drawingsRef = db.collection("drawings").document(userId)

        drawingsRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var drawingsMap = document.data() ?? [:]

                if drawingsMap[drawingId] != nil {
                    drawingsMap.removeValue(forKey: drawingId)

                    drawingsRef.setData(drawingsMap) { error in
                        if let error = error {
                            print("Error deleting drawing: \(error)")
                            self.showingAlert = true
                            self.alertMessage = "Error deleting drawing: \(error.localizedDescription)"
                        } else {
                            print("Drawing deleted successfully")
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                } else {
                    print("Drawing with ID \(drawingId) not found")
                    self.showingAlert = true
                    self.alertMessage = "Drawing with ID \(drawingId) not found"
                }
            } else {
                print("Document does not exist")
                self.showingAlert = true
                self.alertMessage = "Document does not exist"
            }
        }
    }
}

struct PencilKitView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var drawingData: Data?
    let toolPicker = PKToolPicker()


    func makeUIView(context: Context) -> PKCanvasView {
        let view = canvas
        view.drawingPolicy = .anyInput
        view.isOpaque = false
        view.isUserInteractionEnabled = true
        view.tool = PKInkingTool(.pen, color: .black, width: 15)
        view.delegate = context.coordinator
        toolPicker.addObserver(view)
        toolPicker.setVisible(true, forFirstResponder: view)
        view.becomeFirstResponder()
        return view
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        guard let drawingData = drawingData else {
            return
        }

        DispatchQueue.main.async {
            do {
                let drawing = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(drawingData)
                uiView.drawing = drawing as! PKDrawing
            } catch {
                print("Error creating PKDrawing: \(error)")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilKitView

        init(_ parent: PencilKitView) {
            self.parent = parent
        }

        func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
            canvasView.tool = parent.canvas.tool
        }
    }
}





//struct SketchingTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        let samplePost = SketchingPost(drawingID: "sampleID", title: "Sample Drawing", drawingData: Data()) // Replace Data() with actual drawing data
//        return SketchingTestView(drawingData: samplePost.drawingData, title: samplePost.title, drawingID: samplePost.drawingID)
//    }
//}

struct SaveDrawingView: View {
    @Binding var canvas: PKCanvasView
    @Binding var drawingData: Data?
    @Binding var title: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Enter Title")
                .font(.title)
                .padding()

            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save") {
                saveDrawingToFirestore()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            
            

            Spacer()
        }
        .frame(maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .padding()
    }

    func saveDrawingToFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }

        let db = Firestore.firestore()
        let drawingsRef = db.collection("drawings").document(userId)

        let drawingData = try? NSKeyedArchiver.archivedData(withRootObject: canvas.drawing, requiringSecureCoding: false)
        let drawingDataString = drawingData?.base64EncodedString() ?? ""

        let drawingId = UUID().uuidString

        let data: [String: Any] = [
            "title": title,
            "drawingData": drawingDataString
        ]

        drawingsRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var drawingsMap = document.data() ?? [:]
                drawingsMap[drawingId] = data

                drawingsRef.setData(drawingsMap) { error in
                    if let error = error {
                        print("Error saving drawing: \(error)")
                    } else {
                        print("Drawing saved successfully")
                    }
                }
            } else {
                let drawingsMap = [drawingId: data]

                drawingsRef.setData(drawingsMap) { error in
                    if let error = error {
                        print("Error saving drawing: \(error)")
                    } else {
                        print("Drawing saved successfully")
                    }
                }
            }
        }
    }

}
