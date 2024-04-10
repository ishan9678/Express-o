import SwiftUI
import FirebaseStorage
import PencilKit
import FirebaseFirestore
import FirebaseAuth
import SlidingTabView

struct MandalaView: View {
    let mandalaPosts: [MandalaPost] = MandalaPost.examplePosts
    @State private var mandalaThumbnails: [String: UIImage] = [:]
    @State private var drawingData: [String: Data] = [:]
    @State private var mandalaIds: [String: String] = [:]
    @State private var showGeneratedMandalas: Bool = false
    @State private var generatedMandalas: [GeneratedMandalaPost] = []
//    @State private var hasFetchedGeneratedMandalas = false
    @State private var tabIndex = 0


    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(title: "Mandala Art", titleSize: 35, subTitle: "", alignLeft: true, height: 230, subMessage: true, subMessageWidth: 233, subMessageText: "Your Mandalas")
                    .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                    .background(Color.white)
                
//                SlidingTabView(selection: $tabIndex, tabs: ["Templates","Generated"])
                
                
                HStack {
                    Button(action: {
                        showGeneratedMandalas = false
                        
                    }) {
                        Text("Templates")
                            .foregroundStyle(Color.white)
                            .bold()
                            .font(.system(size: 20))
                    }
                    .frame(width: 156, height: 51)
                    .cornerRadius(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(showGeneratedMandalas == false ? Color.blue : Color(hex: "17335F"))
                    )
                    
                    Button(action: {
                        showGeneratedMandalas = true
                    }) {
                        Text("Generated")
                            .bold()
                            .foregroundStyle(Color.white)
                            .font(.system(size: 20))
                    }
                    .frame(width: 156, height: 51)
                    .cornerRadius(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(showGeneratedMandalas == true ? Color.blue : Color(hex: "17335F"))
                    )
                }
                .offset(y:40)
                
                ZStack{
                    
                    NavigationLink(destination: MandalaGenerationView(prompt: "")) {
                        Text("Generate Mandala")
                            .padding()
                            .padding(.horizontal, 40)
                            .font(.system(size: 24))
                            .bold()
                            .background(Color(hex: "17335F"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                }
                .offset(y: 800) // Adjust the offset as needed
                .zIndex(1)
                
                if showGeneratedMandalas {
                                   ScrollView {
                                       LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 20) {
                                           ForEach(generatedMandalas) { post in
                                               NavigationLink(destination: MandalaCanvasView(image: post.uiImage, imageName: post.imageLink, drawingData: post.drawingData, generatedMandalaId: post.generatedMandalaID)) {
                                                   VStack {
                                                       
                                                       Image(uiImage: post.uiImage ?? UIImage()) // Use uiImage directly
                                                           .resizable()
                                                           .scaledToFill()
                                                           .frame(width: 350, height: 350)
                                                           .clipShape(RoundedRectangle(cornerRadius: 20))
                                                       
                                                       Text(post.title)
                                                           .foregroundColor(Color(hex: "17335F"))
                                                           .bold()
                                                           .font(.headline)
                                                           .padding(.top,20)
                                                           .padding(.bottom,20)
                                                   }
                                               }
                                               
                                           }
                                             
                                       }
                                       
                                       .padding()
                                   }
                                   .offset(y:-50)
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 20) {
                            ForEach(mandalaPosts) { post in
                                NavigationLink(destination: MandalaCanvasView(image: UIImage(named: post.imageName), imageName: post.imageName, drawingData: drawingData[post.imageName], mandalaId: mandalaIds[post.imageName], mandalaTemplateName: post.imageName)) {
                                    VStack {
                                        if let thumbnail = mandalaThumbnails[post.imageName] {
                                            Image(uiImage: thumbnail)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 350, height: 350)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                        } else {
                                            Image(post.imageName)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 350, height: 350)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                        }
                                        
                                        Text(post.title)
                                            .foregroundColor(Color(hex: "17335F"))
                                            .bold()
                                            .font(.headline)
                                            .padding(.top,20)
                                            .padding(.bottom,20)
                                    }
                                }
                            }
                        }
                        
                        .padding()
                    }
                    .offset(y:-50)
                }
                   
                
                Spacer()
                
                //BottomNavBarView()
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                fetchMandalas()
                fetchGeneratedMandalas()
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    private func fetchMandalas() {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("mandalas").document(userId).getDocument { document, error in
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            
            if let mandalasData = document.data() {
                for (mandalaId, mandalaData) in mandalasData {
                    guard let mandalaData = mandalaData as? [String: Any] else {
                        print("Invalid mandala data format for ID: \(mandalaId)")
                        continue
                    }
                    
                    guard let mandalaTemplateName = mandalaData["mandalaTemplateImage"] as? String else {
                        print("Failed to extract mandalaTemplateName for ID: \(mandalaId)")
                        continue
                    }
                    
                    guard let drawingDataString = mandalaData["drawingData"] as? String else {
                        print("Failed to extract drawingDataString for ID: \(mandalaId)")
                        continue
                    }
                    
                    guard let drawingData = Data(base64Encoded: drawingDataString) else {
                        print("Failed to convert drawingDataString to Data for ID: \(mandalaId)")
                        continue
                    }
                    
                    if let drawing = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(drawingData) as? PKDrawing {
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
                            if let mandalaImage = UIImage(named: mandalaTemplateName) {
                                mandalaImage.draw(in: CGRect(origin: .zero, size: imageSize))
                            }
                            
                            // Draw scaled drawing image on top
                            let scaledDrawingSize = CGSize(width: drawing.bounds.width * drawingScale, height: drawing.bounds.height * drawingScale)
                            let drawingOrigin = CGPoint(x: (imageSize.width - scaledDrawingSize.width) / 2, y: (imageSize.height - scaledDrawingSize.height) / 2)
                            drawingImage.draw(in: CGRect(origin: drawingOrigin, size: scaledDrawingSize))
                        }
                        
                        // Update mandalaThumbnails and drawingData on the main queue
                        DispatchQueue.main.async {
                            mandalaThumbnails[mandalaTemplateName] = thumbnail
                            self.drawingData[mandalaTemplateName] = drawingData // Update drawingData dictionary
                            mandalaIds[mandalaTemplateName] = mandalaId
                            print("success")
                        }
                    } else {
                        print("Failed to unarchive drawingData for ID: \(mandalaId)")
                    }
                }
            }
        }
    }
    
    private func fetchGeneratedMandalas() {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("generated-mandalas").document(userId).getDocument { document, error in
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            
            if let generatedMandalasData = document.data() {
                for (generatedMandalaId, mandalaData) in generatedMandalasData {
                    guard let mandalaData = mandalaData as? [String: Any] else {
                        print("Invalid mandala data format for ID: \(generatedMandalaId)")
                        continue
                    }
                    
                    guard let title = mandalaData["title"] as? String else {
                        print("Failed to extract title for ID: \(generatedMandalaId)")
                        continue
                    }
                    
                    guard let imageLink = mandalaData["imageLink"] as? String else {
                        print("Failed to extract imageLink for ID: \(generatedMandalaId)")
                        continue
                    }
                    
                    guard let drawingDataString = mandalaData["drawingData"] as? String else {
                        print("Failed to extract drawingDataString for ID: \(generatedMandalaId)")
                        continue
                    }
                    
                    let drawingData = drawingDataString.isEmpty ? nil : Data(base64Encoded: drawingDataString)
                    
                    // Check if the mandala already exists in the generatedMandalas array
                    if let existingMandalaIndex = generatedMandalas.firstIndex(where: { $0.generatedMandalaID == generatedMandalaId }) {
                        // Update the existing mandala
                        generatedMandalas[existingMandalaIndex].title = title
                        generatedMandalas[existingMandalaIndex].drawingData = drawingData
                        // Update other properties as needed
                        updateExistingMandalaUI(at: existingMandalaIndex, with: drawingData, and: imageLink)
                    } else {
                        // Create a storage reference from the imageLink
                        let storageRef = Storage.storage().reference(forURL: imageLink)
                        
                        // Download the image data
                        storageRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
                            if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                                return
                            }
                            
                            if let imageData = data, let uiImage = UIImage(data: imageData) {
                                
                                let scale = UIScreen.main.scale
                                let imageSize = CGSize(width: 350, height: 350) // Set the size to match the mandala image size
                                
                                let thumbnail = UIGraphicsImageRenderer(size: imageSize).image { _ in
                                    // Draw mandala image
                                    if let mandalaGeneratedImage = UIImage(data: imageData) {
                                        mandalaGeneratedImage.draw(in: CGRect(origin: .zero, size: imageSize))
                                    }
                                    
                                    // Draw scaled drawing image on top
                                    if let drawingData = drawingData, let drawing = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(drawingData) as? PKDrawing {
                                        let drawingImage = drawing.image(from: drawing.bounds, scale: scale)
                                        let drawingScaleX = imageSize.width / drawing.bounds.width
                                        let drawingScaleY = imageSize.height / drawing.bounds.height
                                        let drawingScale = min(drawingScaleX, drawingScaleY)
                                        let scaledDrawingSize = CGSize(width: drawing.bounds.width * drawingScale, height: drawing.bounds.height * drawingScale)
                                        let drawingOrigin = CGPoint(x: (imageSize.width - scaledDrawingSize.width) / 2, y: (imageSize.height - scaledDrawingSize.height) / 2)
                                        drawingImage.draw(in: CGRect(origin: drawingOrigin, size: scaledDrawingSize))
                                    }
                                }
                                
                                let isTemplate = false
                                // Create a GeneratedMandalaPost instance and append it to the array
                                let generatedMandala = GeneratedMandalaPost(generatedMandalaID: generatedMandalaId, title: title, drawingData: drawingData, imageLink: imageLink, uiImage: thumbnail, isTemplate: isTemplate)
                                
                                DispatchQueue.main.async {
                                    generatedMandalas.append(generatedMandala)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func updateExistingMandalaUI(at index: Int, with drawingData: Data?, and imageLink: String) {
        // Update the UI for the existing mandala at the given index
        DispatchQueue.main.async {
            guard let drawingData = drawingData, let drawing = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(drawingData) as? PKDrawing else {
                // Handle error or continue without updating the drawing
                return
            }
            let scale = UIScreen.main.scale
            let imageSize = CGSize(width: 350, height: 350) // Set the size to match the mandala image size
            let drawingImage = drawing.image(from: drawing.bounds, scale: scale)
            let drawingScaleX = imageSize.width / drawing.bounds.width
            let drawingScaleY = imageSize.height / drawing.bounds.height
            let drawingScale = min(drawingScaleX, drawingScaleY)
            let scaledDrawingSize = CGSize(width: drawing.bounds.width * drawingScale, height: drawing.bounds.height * drawingScale)
            let drawingOrigin = CGPoint(x: (imageSize.width - scaledDrawingSize.width) / 2, y: (imageSize.height - scaledDrawingSize.height) / 2)
            
            // Download the image from imageLink
            let storageRef = Storage.storage().reference(forURL: imageLink)
            storageRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                if let imageData = data, let mandalaImage = UIImage(data: imageData) {
                    let thumbnail = UIGraphicsImageRenderer(size: imageSize).image { _ in
                        // Draw mandala image
                        mandalaImage.draw(in: CGRect(origin: .zero, size: imageSize))
                        // Draw scaled drawing image on top
                        drawingImage.draw(in: CGRect(origin: drawingOrigin, size: scaledDrawingSize))
                    }
                    
                    generatedMandalas[index].uiImage = thumbnail
                }
            }
        }
    }



        struct MandalaView_Previews: PreviewProvider {
            static var previews: some View {
                MandalaView()
            }
        }
    }

