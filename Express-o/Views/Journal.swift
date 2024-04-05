//
 //  Journal.swift
 //  Express-o
 //
 //  Created by ishan on 18/03/24.
 //

import SwiftUI
import PencilKit
import PhotosUI
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore


struct Journal: View {
 @State var canvas = PKCanvasView()
 @State var drawingData: Data?
 @State private var images: [UIImage] = []
 @State private var offsets: [CGSize] = []
 @State private var isImagePickerPresented = false
 @State var isDragging = false
 @State private var dragOffset: CGSize? = nil
 @State private var draggedImageIndex: Int?
 @State private var isLongPressActive = false
 @State private var imageSizes: [Int: CGSize] = [:]
 @State private var initialSize: CGSize = CGSize(width: 400, height: 400)
 @State private var isBackgroundChooserVisible = false
 @State private var selectedBackgroundIndex = 0
 @State private var isTemplateChooserVisible = false
 @State private var selectedTemplateIndex = 0
 @State private var selectedTemplateImage: UIImage?
 @State private var isStickerChooserVisible = false
 @State private var selectedStickerIndex = 0
 @State private var selectedStickerImage: UIImage?
 @State private var editMode = false
 @State private var isNavigationBardHidden = false
 @State private var pageNo: Int
 @State private var isSaving = false

    

    init(pageNo: Int) {  // Add this initializer
            self.pageNo = pageNo
        }
    
let backgroundImages = [
            "paper1",
            "paper2",
            "paper3",
            "paper4",
            "paper5",
            "paper6",
            "paper7"
]
    
let templateImages = [
            "template1",
            "template2",
            "template3",
            "template4",
            "template5",
            "template6",
            "template7"
]
    
let stickerImages = [
    "sticker1",
    "sticker2",
    "sticker3",
    "sticker4",
    "sticker5",
    "sticker6",
    "sticker7",
    "sticker8"
]
    
    

 var body: some View {
     NavigationStack {
         ZStack(alignment: .topLeading) {
             
             GeometryReader { geometry in
                 Image(backgroundImages[selectedBackgroundIndex])
                     .resizable()
                     .aspectRatio(contentMode: .fill)
                     .frame(width: geometry.size.width , height: geometry.size.height)
//                     .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
             }
             .edgesIgnoringSafeArea(.all)

             
//             PencilKitView(canvas: $canvas, drawingData: $drawingData)
//                 .frame(maxWidth: .infinity, maxHeight: .infinity)
//                 .edgesIgnoringSafeArea(.all)
             
             
             ForEach(0..<images.count, id: \.self) { index in
                                 let offset = CGSize(
                                     width: offsets[index].width + (draggedImageIndex == index ? dragOffset?.width ?? 0 : 0),
                                     height: offsets[index].height + (draggedImageIndex == index ? dragOffset?.height ?? 0 : 0)
                                 )

                                 let imageSize = imageSizes[index] ?? initialSize

                                 let image = Image(uiImage: images[index])
                                     .resizable()
                                     .aspectRatio(contentMode: .fit)
                                     .frame(width: imageSize.width, height: imageSize.height)
                                     .offset(offset)
                                     .animation(.spring)
                                    .gesture(
                                         DragGesture()
                                             .onChanged { gesture in
                                                 if draggedImageIndex == index {
                                                     dragOffset = gesture.translation
                                                 }
                                             }
                                             .onEnded { _ in
                                                 if draggedImageIndex == index {
                                                     offsets[index].width += dragOffset?.width ?? 0
                                                     offsets[index].height += dragOffset?.height ?? 0
                                                     dragOffset = nil
                                                     draggedImageIndex = nil
                                                     isLongPressActive = false
                                                 }
                                             }
                                     )
                                     .rotationEffect(Angle(degrees: isLongPressActive && draggedImageIndex == index ? 2.5 : 0))
                                     .animation(isLongPressActive && draggedImageIndex == index ? Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true) : .default)
                                     .gesture(
                                         MagnificationGesture()
                                             .onChanged { value in
                                                 if draggedImageIndex == index {
                                                     let scale = value - 1.0 // Slow down the scaling
                                                     let maxScale: CGFloat = 2.0 // Maximum scale factor
                                                     let minScale: CGFloat = 0.5 // Minimum scale factor
                                                     
                                                     var newWidth = imageSize.width + scale * 10
                                                     var newHeight = imageSize.height + scale * 10
                                                     
                                                     // Limit the maximum and minimum size
                                                     newWidth = max(min(newWidth, initialSize.width * maxScale), initialSize.width * minScale)
                                                     newHeight = max(min(newHeight, initialSize.height * maxScale), initialSize.height * minScale)
                                                     
                                                     let newSize = CGSize(width: newWidth, height: newHeight)
                                                     imageSizes[index] = newSize
                                                 }
                                             }
                                     )


                                 image
                                     .simultaneousGesture(
                                         LongPressGesture(minimumDuration: 0.5)
                                             .onEnded { _ in
                                                 draggedImageIndex = index
                                                 isLongPressActive = true
                                             }
                                     )
                 
                 

                                 // Add a delete button
                                 if isLongPressActive && draggedImageIndex == index {
                                     Button(action: {
                                         images.remove(at: index)
                                         offsets.remove(at: index)
                                         draggedImageIndex = nil
                                         isLongPressActive = false
                                     }) {
                                         Image(systemName: "minus.circle.fill")
                                             .foregroundColor(.red)
                                     }
                                     .position(x: offset.width, y: offset.height + 60)
                                     .animation(.spring())
                                 }
                 
                             }
             
             if editMode == false {
                 PencilKitView(canvas: $canvas, drawingData: $drawingData)
                                     .frame(maxWidth: .infinity, maxHeight: .infinity)
                                     .edgesIgnoringSafeArea(.all)
                                     .gesture(
                                         TapGesture()
                                             .onEnded {
                                                 // Handle tap on the drawing overlay if needed
                                             }
                                     )
             }
             
        
             if isTemplateChooserVisible {
                 VStack {
                    Spacer()
                     ScrollView(.horizontal) {
                                                 HStack {
                                                     ForEach(0..<templateImages.count, id: \.self) { index in
                                                         Image(templateImages[index])
                                                             .resizable()
                                                             .frame(width: 100, height: 150)
                                                             .cornerRadius(8)
                                                             .onTapGesture {
                                                                 images.append(UIImage(named: templateImages[index])!)
                                                                 offsets.append(CGSize(width: 0, height: 0))
                                                             }
                                                     }
                                                 }
                                             }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                    }
                    .frame(height: .infinity)
                    .background(Color.gray.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                isTemplateChooserVisible.toggle()
                            }
                    )
                }
             
             if isStickerChooserVisible {
                 VStack {
                    Spacer()
                     ScrollView(.horizontal) {
                                                 HStack {
                                                     ForEach(0..<stickerImages.count, id: \.self) { index in
                                                         Image(stickerImages[index])
                                                             .resizable()
                                                             .frame(width: 100, height: 100)
                                                             .cornerRadius(8)
                                                             .onTapGesture {
                                                                 images.append(UIImage(named: stickerImages[index])!)
                                                                 offsets.append(CGSize(width: 0, height: 0))
                                                             }
                                                     }
                                                 }
                                             }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                    }
                    .frame(height: .infinity)
                    .background(Color.gray.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                isStickerChooserVisible.toggle()
                            }
                    )
                }
             
             
             
             if isBackgroundChooserVisible {
                 VStack {
                    Spacer()
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<backgroundImages.count, id: \.self) { index in
                                        Image(backgroundImages[index])
                                            .resizable()
                                            .frame(width: 100, height: 150)
                                            .cornerRadius(8)
                                            .onTapGesture {
                                                // Update the background image
                                                selectedBackgroundIndex = index
                                                    
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                    }
                    .frame(height: .infinity)
                    .background(Color.gray.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                isBackgroundChooserVisible.toggle()
                            }
                    )
                }
         }
         
         
     }
//         .navigationBarTitle(dateFormatter.string(from: Date()), displayMode: .inline)
         .navigationBarItems(trailing: Button("Add Photo") {
             isImagePickerPresented.toggle()
         })
         .navigationBarItems(trailing: Button(action: {
                if isTemplateChooserVisible {
                    isTemplateChooserVisible = false
                }
                         isBackgroundChooserVisible.toggle()
                     }) {
                         Text("Backgrounds")
        })
         .navigationBarItems(trailing: Button(action: {
                if isBackgroundChooserVisible {
                    isBackgroundChooserVisible = false
                }
                        isTemplateChooserVisible.toggle()
                     }) {
                         Text("Templates")
        })
         .navigationBarItems(trailing: Button(action: {
                if isBackgroundChooserVisible {
                    isBackgroundChooserVisible = false
                }
                if isTemplateChooserVisible {
                 isTemplateChooserVisible = false
                }

                        isStickerChooserVisible.toggle()
                     }) {
                         Text("Stickers")
        })
         .navigationBarItems(trailing:
             Toggle(isOn: $editMode) {
                 Text("Edit Mode")
             }
            .toggleStyle(.switch)
         )
         .navigationBarItems(trailing:
                 Button(action: {
             isNavigationBardHidden = true
             isSaving = true
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                 saveImage(pageNo: pageNo)
                 
             }
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                 isNavigationBardHidden = false
             }
             isSaving = false

                 }) {
                     Text("Save")
                 }
         )
         .navigationBarHidden(isNavigationBardHidden)

     


         .sheet(isPresented: $isImagePickerPresented) {
             ImagePicker(selectedImages: $images, offsets: $offsets)
         }
//         .onAppear {
//             let orientation = UIDevice.current.orientation
//             if orientation != .landscapeLeft && orientation != .landscapeRight {
//                 UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
//                 UIViewController.attemptRotationToDeviceOrientation()
//             }
//         }
     }
   
 }


let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
}()

//func saveImage() {
//    let image = UIApplication.shared.windows[0].rootViewController?.view.asImage(excluding: ["UINavigationBar"])
//    UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
//}

func saveImage(pageNo: Int) {
    guard let image = UIApplication.shared.windows[0].rootViewController?.view.asImage(excluding: ["UINavigationBar"]) else {
        print("Error: Unable to capture image.")
        return
    }

    let storage = Storage.storage()
    let storageRef = storage.reference()

    // Create a unique ID for the journal entry
    let entryId = UUID().uuidString

    // Create a reference to the image in Firebase Storage
    let imageRef = storageRef.child("art-journal/\(entryId).jpg")

    // Convert the image to JPEG data
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        print("Error: Unable to convert image to data.")
        return
    }

    // Upload the image to Firebase Storage
    let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
        if let error = error {
            print("Error uploading image: \(error.localizedDescription)")
            return
        }

        // Once the image is uploaded, get the download URL
        imageRef.downloadURL { url, error in
            if let error = error {
                print("Error getting download URL: \(error.localizedDescription)")
                return
            }

            // Save the download URL to Firestore
            let db = Firestore.firestore()

            // Get the current user's ID
            guard let userId = Auth.auth().currentUser?.uid else {
                print("Error: User not authenticated.")
                return
            }

            // Reference to the user's document in the "art-journal" collection
            let userRef = db.collection("art-journal").document(userId)

            // Check if the user document exists
            userRef.getDocument { document, error in
                if let error = error {
                    print("Error getting document: \(error.localizedDescription)")
                    return
                }

                var userArtJournal = document?.data() ?? [:]

                // Get the art journal entries map or create a new one if it doesn't exist
                var artJournalEntries = userArtJournal["artJournalEntries"] as? [String: [String: Any]] ?? [:]

                // Check if there is an existing entry for the page number
                if let existingEntryId = artJournalEntries.keys.first(where: { artJournalEntries[$0]?["pageNo"] as? Int == pageNo }) {
                    // Print the existing entry ID, previous image URL, and updated image URL
                    print("Existing entry ID: \(existingEntryId)")
                    print("Previous image URL: \(artJournalEntries[existingEntryId]?["imageURL"] as? String ?? "")")
                    print("Updated image URL: \(url?.absoluteString ?? "")")

                    // Update the existing entry with the new image URL
                    artJournalEntries[existingEntryId]?["imageURL"] = url?.absoluteString
                } else {
                    // Create a new entry
                    let newEntryId = UUID().uuidString
                    artJournalEntries[newEntryId] = [
                        "imageURL": url?.absoluteString ?? "",
                        "pageNo": pageNo
                    ]
                }

                // Update the artJournalEntries map in the user's document
                userRef.setData(["artJournalEntries": artJournalEntries], merge: true) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                        return
                    }
                    print("Document updated for user ID: \(userId)")
                }
            }
        }
    }

    // Observe the upload progress if needed
    uploadTask.observe(.progress) { snapshot in
        guard let progress = snapshot.progress else { return }
        let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
        print("Upload progress: \(percentComplete)%")
    }
}





extension UIView {
    func asImage(excluding excludedViews: [String]) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
            let excludedViews = excludedViews.compactMap { view in
                return subviews.first { type(of: $0).description() == view }
            }
            excludedViews.forEach { view in
                view.removeFromSuperview()
            }
        }
    }
}


#Preview {
 Journal(pageNo: 1)
}
