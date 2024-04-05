import SwiftUI
import AVKit
import MobileCoreServices

struct ArtJournalUntitled: View {
    @State private var title = "Untitled"
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var gestureScale: CGFloat = 1.0
    @GestureState private var gestureOffset: CGSize = .zero
    @State private var isAudioViewVisible = false
    @State private var audioViewOffset: CGSize = .zero
    @State private var isTextBoxOpen = false
    @State private var textBoxSize = CGSize(width: 200, height: 150)
    @State private var textBoxPosition = CGSize.zero
    @State private var isDrawing = false
    @State private var drawing = Path()
    @State private var lastPoint: CGPoint = .zero
    @State private var selectedShape: ShapeOption?
    @State private var isOptionsVisible = false
    @State private var shapes: [ShapeData] = []
    @State private var undoStack: [ShapeData] = []
    @State private var redoStack: [ShapeData] = []
    @State private var player: AVPlayer?
    @State private var isVideoPickerPresented = false
    @State private var isPhotoPickerPresented = false
    @State private var selectedPhoto: UIImage?
    @State private var photoOffset: CGSize = .zero
    @State private var photoScale: CGFloat = 1.0
    @State private var isImageSelected = false // Track if image is selected

    var body: some View {
        ZStack {
            ZStack {
                Image("ArtJournalBlank")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 840)
                    .scaleEffect(scale * gestureScale)
                    .offset(
                        CGSize(
                            width: offset.width + gestureOffset.width,
                            height: offset.height + gestureOffset.height
                        )
                    )
                    .gesture(
                        MagnificationGesture()
                            .updating($gestureScale) { value, state, _ in
                                state = value
                            }
                    )
                    .gesture(
                        DragGesture()
                            .updating($gestureOffset) { value, state, _ in
                                state = value.translation
                            }
                    )
            }
            
            if let player = player {
                VideoPlayer(player: player)
                    .frame(width: 200, height: 200)
                    .onAppear {
                        player.play()
                    }
            }
            
            if isAudioViewVisible {
                AudioView(expandSheet: .constant(false), animation: Namespace().wrappedValue)
                    .zIndex(1.0)
                    .frame(width: 200, height: 400)
                    .offset(audioViewOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                audioViewOffset = CGSize(width: value.translation.width, height: value.translation.height)
                            }
                        
                    )
            }
            
            if isTextBoxOpen {
                TextBoxView(textBoxSize: $textBoxSize, textBoxPosition: $textBoxPosition)
                    .frame(width: textBoxSize.width, height: textBoxSize.height)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .offset(x: textBoxPosition.width, y: textBoxPosition.height)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                textBoxPosition = value.translation
                            }
                    )
            }
            
            if isDrawing {
                Path { path in
                    path.addPath(drawing)
                }
                .stroke(Color.black, lineWidth: 3)
            }
            
            ForEach(shapes) { shape in
                shape.shape
                    .frame(width: shape.size.width, height: shape.size.height)
                    .position(shape.position)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if let index = shapes.firstIndex(where: { $0.id == shape.id }) {
                                    shapes[index].position = value.location
                                }
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                if let index = shapes.firstIndex(where: { $0.id == shape.id }) {
                                    shapes[index].size.width = shape.size.width * value.magnitude
                                    shapes[index].size.height = shape.size.height * value.magnitude
                                }
                            }
                    )
            }
            
            if let selectedPhoto = selectedPhoto {
                Image(uiImage: selectedPhoto)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .offset(photoOffset)
                    .scaleEffect(photoScale)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                photoScale = value.magnitude
                            }
                
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                photoOffset = value.translation
                            }
                    )
            }
            
            HStack {
                VStack {
                    HStack {
                        Button(action: {
                            undo()
                        }) {
                            Image(systemName: "arrow.uturn.backward.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding()
                        }

                        Button(action: {
                            redo()
                        }) {
                            Image(systemName: "arrow.uturn.forward.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding()
                        }

                        Spacer()

                        TextField("Untitled", text: $title)
                            .font(.system(size: 48, weight: .heavy, design: .default))
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)

                        Spacer()

                        Button(action: {
                            takeScreenshotAndShare() // Take screenshot and share action
                        }) {
                            Image(systemName: "square.and.arrow.down")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding(.horizontal)
                        }
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 20) {
                    Button(action: {
                        // Your action for the sidebar button 1
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                    
                    Button(action: {
                        isDrawing.toggle() // Toggle drawing mode
                    }) {
                        Image(systemName: "applepencil.and.scribble")
                            .resizable()
                            .frame(width: 50, height: 40)
                            .padding()
                    }


                    Button(action: {
                        // Your action for the sidebar button 2
                        isAudioViewVisible.toggle() // Toggle visibility of AudioView
                    }) {
                        Image(systemName: "music.note")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }

                    Button(action: {
                        isTextBoxOpen.toggle()
                    }) {
                        Image(systemName: "t.square")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                    
                    Button(action: {
                        isOptionsVisible = true // Show shape options
                    }) {
                        Image(systemName: "triangle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                        
                    }
                    
                    Button(action: {
                        isVideoPickerPresented.toggle()
                    }) {
                        Image(systemName: "play.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                    
                    Button(action: {
                        isPhotoPickerPresented.toggle() // Toggle photo picker
                    }) {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                    
                    // Additional sidebar buttons...
                }
                .foregroundColor(.black)
                .background(Color(red: 1, green: 0.78, blue: 0.75))
                .padding()
            }
        }
        .sheet(isPresented: $isVideoPickerPresented) {
            VideoPickerView(
                onVideoSelected: { url in
                    player = AVPlayer(url: url)
                    player?.play()
                },
                onCancel: {
                    isVideoPickerPresented = false // Dismiss video picker
                }
            )
        }
        .sheet(isPresented: $isPhotoPickerPresented) {
            ImagePickerView(selectedImage: $selectedPhoto, isImageSelected: $isImageSelected)
        }
        .edgesIgnoringSafeArea(.all)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    let currentPoint = value.location
                    if isDrawing {
                        drawing.addLine(to: currentPoint)
                        lastPoint = currentPoint
                    }
                })
                .onEnded({ value in
                    if isDrawing {
                        drawing.addLine(to: lastPoint)
                    }
                })
        )
        .overlay(
            Group {
                if isOptionsVisible {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isOptionsVisible = false // Dismiss shape options
                        }
                    
                    OptionsView { shapeView in
                        let newShape = ShapeData(shape: shapeView, position: CGPoint(x: 200, y: 200), size: CGSize(width: 100, height: 100))
                        shapes.append(newShape)
                        isOptionsVisible = false // Dismiss shape options
                    }
                    .frame(width: 200, height: 200)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                }
            }
        )
    }
    
    func undo() {
        if let lastShape = shapes.popLast() {
            undoStack.append(lastShape)
        }
    }
    
    func redo() {
        if let lastUndo = undoStack.popLast() {
            shapes.append(lastUndo)
        }
    }
    
    func takeScreenshotAndShare() {
//        #if !targetEnvironment(macCatalyst)
        guard let window = UIApplication.shared.windows.first else { return }
        
        // Capture screenshot
        let renderer = UIGraphicsImageRenderer(size: window.bounds.size)
        let screenshot = renderer.image { ctx in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }

        
//        // Present share sheet
//        let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
//        #endif
    }

}


struct TextBoxView: View {
    @Binding var textBoxSize: CGSize
    @Binding var textBoxPosition: CGSize
    @State private var text: String = ""

    var body: some View {
        VStack {
            TextEditor(text: $text)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")

        }
        .background(Color(red: 0.96, green: 0.84, blue: 0.69))
        
        .onDisappear{
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")

        }
    }
}

struct ArtJournalUntitled_Previews: PreviewProvider {
    static var previews: some View {
        ArtJournalUntitled()
    }
}

struct OptionsView: View {
    let onSelect: (AnyView) -> Void
    var body: some View {
        VStack {
            ForEach(ShapeOption.allCases) { option in
                Button(action: {
                    onSelect(option.view) // Pass the view associated with the option
                }) {
                    option.image
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
        }
        .padding()
    }
}

struct ShapeData: Identifiable {
    let id = UUID()
    let shape: AnyView
    var position: CGPoint
    var size: CGSize
}

struct SquareShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path(rect)
    }
}

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct CircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path(ellipseIn: rect)
    }
}

enum ShapeOption: String, CaseIterable, Identifiable {
    case square
    case triangle
    case circle
    
    var id: String { self.rawValue }
    
    var image: Image {
        switch self {
        case .square:
            return Image(systemName: "square")
        case .triangle:
            return Image(systemName: "triangle")
        case .circle:
            return Image(systemName: "circle")
        }
    }
    
    var view: AnyView {
        switch self {
        case .square:
            return AnyView(SquareShape().fill(Color.blue))
        case .triangle:
            return AnyView(TriangleShape().fill(Color.red))
        case .circle:
            return AnyView(CircleShape().fill(Color.green))
        }
    }
}

struct VideoPickerView: UIViewControllerRepresentable {
    var onVideoSelected: (URL) -> Void
    var onCancel: () -> Void // Add onCancel closure
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onVideoSelected: onVideoSelected, onCancel: onCancel) // Pass onCancel to Coordinator
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var onVideoSelected: (URL) -> Void
        var onCancel: () -> Void // Add onCancel closure
        
        init(onVideoSelected: @escaping (URL) -> Void, onCancel: @escaping () -> Void) {
            self.onVideoSelected = onVideoSelected
            self.onCancel = onCancel // Assign onCancel
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let url = info[.mediaURL] as? URL {
                onVideoSelected(url)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onCancel()
        }
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isImageSelected: Bool
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView
        
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.isImageSelected = true
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArtJournalUntitled()
//    }
//}
//


