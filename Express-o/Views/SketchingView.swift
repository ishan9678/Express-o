import SwiftUI
import PencilKit
import FirebaseAuth

struct SketchingView: View {
    @State private var posts: [SketchingPost] = []
    @State private var isLoading: Bool = true
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HeaderView(title: "Sketching", titleSize: 35, subTitle: "", alignLeft: true, height: 230, subMessage: true, subMessageWidth: 233, subMessageText: "Your Sketches")
                    .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                    .background(Color.white)
                    .padding(.bottom, 40)

                // Sketch Entries
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 40) {
                        NavigationLink(destination: SketchingTestView(canvas: PKCanvasView(), drawingID: "")) {
                            VStack {
                                Image("add_new")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.blue)
                                    .frame(width: 350, height: 350)
                                    .padding()
                                Text("Add New")
                                    .font(.headline)
                                    .foregroundColor(Color(hex: "17335F"))
                            }
                            .padding()
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())

                        ForEach(posts) { post in
                            NavigationLink(destination: SketchingTestView(drawingData: post.drawingData, title: post.title, drawingID: post.drawingID)) {
                                VStack {
                                    if let drawingData = post.drawingData,
                                       let _ = try? PKDrawing(data: drawingData) {
                                        DrawingPreview(drawingData: drawingData.base64EncodedString())
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    Text(post.title)
                                        .font(.headline)
                                        .foregroundColor(Color(hex: "17335F"))
                                        .multilineTextAlignment(.center)
                                        .padding(.top,30)
                                }
                                .padding()
                                .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(15)

                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                }

                Spacer()

                //BottomNavBarView()
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                fetchPosts()
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func fetchPosts() {
        SketchingPost.fetchPosts { posts in
            self.posts = posts.sorted(by: { $0.drawingID < $1.drawingID })
            isLoading = false
        } debugCompletion: { debugInfo in
            print(debugInfo)
        }
    }

}


struct DrawingPreview: View {
    var drawingData: String?

    var body: some View {
        if let drawingDataString = drawingData,
           let data = Data(base64Encoded: drawingDataString) {
            do {
                let drawing = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
                if let drawing = drawing as? PKDrawing {
                    print(drawing)
                    if drawing.bounds.isEmpty || drawing.bounds.isInfinite {
                        print("Invalid drawing bounds: \(drawing.bounds)")
                        return AnyView(
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(8)
                        )
                    }

                    let scale = UIScreen.main.scale
                    let image = drawing.image(from: drawing.bounds, scale: scale)
                    return AnyView(
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    )
                } else {
                    print("Failed to unarchive PKDrawing")
                }
            } catch {
                print("Error unarchiving PKDrawing: \(error)")
            }
        }

        print("No valid drawing data found")
        return AnyView(
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
        )
    }
}



struct SketchingView_Previews: PreviewProvider {
    static var previews: some View {
        SketchingView()
    }
}

