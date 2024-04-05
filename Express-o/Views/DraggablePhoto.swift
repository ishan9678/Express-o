import SwiftUI

struct DraggablePhoto: View {
    @State private var images: [UIImage] = []
    @State private var offsets: [CGSize] = []
    @State private var isImagePickerPresented = false

    var body: some View {
        ZStack {
            ForEach(0..<images.count, id: \.self) { index in
                Image(uiImage: images[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .offset(offsets[index])
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let translation = gesture.translation
                                let newOffset = CGSize(
                                    width: translation.width,
                                    height: translation.height
                                )
                                offsets[index] = newOffset
                            }
                    )


            }
            Button("Add Photo") {
                isImagePickerPresented.toggle()
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImages: $images, offsets: $offsets)
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Binding var offsets: [CGSize]

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImages.append(uiImage)
                parent.offsets.append(.zero)
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

struct DraggablePhoto_Previews: PreviewProvider {
    static var previews: some View {
        DraggablePhoto()
    }
}

