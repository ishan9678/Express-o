//
//  MandalaCanvasView.swift
//  Express-o
//
//  Created by user1 on 23/02/24.
//

import SwiftUI
import PencilKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct MandalaCanvasView: View {
    @State var canvas = PKCanvasView()
    @State var image: UIImage?
    @State var imageName: String
    @State var drawingData: Data?
    var mandalaId: String?
    var generatedMandalaId: String?
    var mandalaTemplateName: String?
    @State private var showAlert = false
//    @Binding var dismissAction: (() -> Void)?
    @State var prompt = "Given a Mandala uncolored the user colors it. Describe the Colors used and overall mood in second person. Try to infer the emotions you might be feeling and why, based on the colors present in the mandala. Do not take black and white as colors used. Give the output in format 'description: | emotions: ' where emotions is a list of emotions as emojis and | is the separator between description and emotions."
  

    
    var body: some View {
        NavigationStack{
            ZStack {
                MandalaPencilKitView(canvas: $canvas, image: $image)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack {
                    Spacer()
                    
                }
            }
            .toolbar{
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    if let image = mandalaToImage(image: image) {
                        NavigationLink(destination: EmotionInsightsView(prompt: prompt, image: image)) {
                            Text("Emotion Insights")
                            Image(systemName: "face.smiling")
                        }
                    } else {
                        Button("Emotion Insights") {
                            showAlert = true
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Mandala not saved"), message: Text("Please save your mandala first."), dismissButton: .default(Text("OK")))
                        }
                    }

                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveImage()
                    }                }
            }
            .onAppear {
                if let drawingData = drawingData {
                    canvas.drawing = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(drawingData) as! PKDrawing
                }
            }
        }
    }
    
    func mandalaToImage(image: UIImage?) -> UIImage? {
        guard let drawingData = drawingData?.base64EncodedString(),
              let data = Data(base64Encoded: drawingData),
              let drawing = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? PKDrawing,
              let image = image else {
            print("Invalid input data")
            return nil
        }

        let scale = UIScreen.main.scale
        let imageSize = CGSize(width: 350, height: 350) // Set the size to match the mandala image size

        // Get the scaled drawing image
        let drawingImage = drawing.image(from: drawing.bounds, scale: scale)

        // Calculate the scale factor based on the drawing's bounds and the mandala image size
        let drawingScaleX = imageSize.width / drawing.bounds.width
        let drawingScaleY = imageSize.height / drawing.bounds.height
        let drawingScale = min(drawingScaleX, drawingScaleY)

        let thumbnail = UIGraphicsImageRenderer(size: imageSize).image { _ in
            // Draw mandala image
            image.draw(in: CGRect(origin: .zero, size: imageSize))

            // Draw scaled drawing image on top
            let scaledDrawingSize = CGSize(width: drawing.bounds.width * drawingScale, height: drawing.bounds.height * drawingScale)
            let drawingOrigin = CGPoint(x: (imageSize.width - scaledDrawingSize.width) / 2, y: (imageSize.height - scaledDrawingSize.height) / 2)
            drawingImage.draw(in: CGRect(origin: drawingOrigin, size: scaledDrawingSize))
        }

        return thumbnail
    }

    
    func saveImage() {
        let drawing = canvas.drawing
        guard let userId = Auth.auth().currentUser?.uid else { return }

        if let generatedMandalaId = generatedMandalaId {
            // Update drawing data for existing generated mandala
            let drawingData = try? NSKeyedArchiver.archivedData(withRootObject: drawing, requiringSecureCoding: false)
            let drawingDataString = drawingData?.base64EncodedString() ?? ""

            let db = Firestore.firestore()
            let generatedMandalasRef = db.collection("generated-mandalas").document(userId)

            generatedMandalasRef.getDocument { document, error in
                if let document = document, document.exists {
                    var mandalasData = document.data() ?? [:]
                    var mandalaData = mandalasData[generatedMandalaId] as? [String: Any] ?? [:]
                    mandalaData["drawingData"] = drawingDataString
                    mandalasData[generatedMandalaId] = mandalaData

                    generatedMandalasRef.setData(mandalasData) { error in
                        if let error = error {
                            print("Error updating generated mandala data: \(error.localizedDescription)")
                        } else {
                            print("Generated mandala data updated successfully")
                            
                            
                        }
                    }
                } else {
                    print("Generated mandala document not found")
                }
            }
        } else {
            // Handle non-generated mandala images
            if let mandalaId = mandalaId {
                let drawingData = try? NSKeyedArchiver.archivedData(withRootObject: drawing, requiringSecureCoding: false)

                // Update drawing data for existing mandalaId
                let mandalaData: [String: Any] = [
                    "mandalaTemplateImage": imageName,
                    "drawingData": drawingData?.base64EncodedString() ?? "",
                ]

                let db = Firestore.firestore()
                let mandalasRef = db.collection("mandalas").document(userId)

                mandalasRef.setData([mandalaId: mandalaData], merge: true) { error in
                    if let error = error {
                        print("Error updating mandala data: \(error.localizedDescription)")
                    } else {
                        print("Mandala data updated successfully")
                    }
                }
            } else {
                // Create a new mandalaId and save drawing data
                let mandalaId = UUID().uuidString
                let drawingData = try? NSKeyedArchiver.archivedData(withRootObject: drawing, requiringSecureCoding: false)

                let mandalaData: [String: Any] = [
                    "mandalaTemplateImage": imageName,
                    "drawingData": drawingData?.base64EncodedString() ?? "",
                ]

                let db = Firestore.firestore()
                let mandalasRef = db.collection("mandalas").document(userId)

                mandalasRef.setData([mandalaId: mandalaData], merge: true) { error in
                    if let error = error {
                        print("Error saving mandala data: \(error.localizedDescription)")
                    } else {
                        print("Mandala data saved successfully")
                    }
                }
            }
        }
    }


    struct MandalaPencilKitView: UIViewRepresentable {
        let toolPicker = PKToolPicker()
        @Binding var canvas: PKCanvasView
        @Binding var image: UIImage?
        
        func makeUIView(context: Context) -> PKCanvasView {
            canvas.drawingPolicy = .anyInput
            canvas.isOpaque = false
            canvas.backgroundColor = .clear
            canvas.isUserInteractionEnabled = true
            toolPicker.addObserver(canvas)
            toolPicker.setVisible(true, forFirstResponder: canvas)
            canvas.becomeFirstResponder()
            updateImage(uiView: canvas)
            return canvas
        }
        
        func updateUIView(_ uiView: PKCanvasView, context: Context) {
            updateImage(uiView: uiView)
        }
        
        private func updateImage(uiView: PKCanvasView) {
            if let image = image {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.frame = uiView.bounds
                imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                uiView.addSubview(imageView)
                uiView.sendSubviewToBack(imageView)
            }
        }
    }
}

    
struct MandalaCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        MandalaCanvasView(imageName: "mandala3")
    }
}
