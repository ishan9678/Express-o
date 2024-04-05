import SwiftUI
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import Replicate

private let client = Replicate.Client(token: "r8_4XgNOmGGjle0JLSArTLUgqmtm0enXsz3B4JAQ")

enum StableDiffusion: Predictable {
    static var modelID = "playground-v2-1024px-aesthetic "
    static let versionID = "42fe626e41cc811eaf02c94b892774839268ce1994ea778eba97103fe1ef51b8"

    struct Input: Codable {
        let prompt: String
        let disable_safety_checker : Bool
    }

    typealias Output = [URL]
}

struct MandalaGenerationView_Previews: PreviewProvider {
    static var previews: some View {
        MandalaGenerationView(prompt: "")
    }
}


struct MandalaGenerationView: View {
    @State private var prompt = ""
    @State private var prediction: StableDiffusion.Prediction? = nil
    @State private var isSaveModalVisible = false
    @State private var imageName = ""
    @State private var isArrowVisible = false


    func generate() async throws {
        let updatedPrompt = "\(prompt) , simple , black and white, large shape sizes and less shapes, simple shapes"
        prediction = try await StableDiffusion.predict(with: client, input: .init(prompt: updatedPrompt, disable_safety_checker: true))
        try await prediction?.wait(with: client)
    }


    func cancel() async throws {
        try await prediction?.cancel(with: client)
    }

    init(prompt: String) {
        self._prompt = State(initialValue: prompt)
    }

    let examplePrompts = ["Mandala Art",
                          "Mandala Art in cat shape",
                          "Mandala Art with floral patterns",
                          "Mandala Art with animal motifs"]

    func saveGeneratedMandala() {
            guard let url = prediction?.output?.first else { return }

            // Download the image data
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                // Save the downloaded image data to a temporary local file
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("png")
                do {
                    try data.write(to: tempURL)

                    // Upload the image to Firebase Storage
                    let storageRef = Storage.storage().reference().child("generated-mandalas").child(Auth.auth().currentUser?.uid ?? "").child("\(imageName).png")
                    storageRef.putFile(from: tempURL, metadata: nil) { metadata, error in
                        if let error = error {
                            print("Error uploading image: \(error.localizedDescription)")
                            return
                        }

                        // Get the download URL of the uploaded image
                        storageRef.downloadURL { (downloadURL, error) in
                            guard let downloadURL = downloadURL, error == nil else {
                                print("Failed to get download URL: \(error?.localizedDescription ?? "Unknown error")")
                                return
                            }

                            // Image uploaded successfully, now save metadata to Firestore
                            let db = Firestore.firestore()
                            let userRef = db.collection("generated-mandalas").document(Auth.auth().currentUser?.uid ?? "")
                            let generatedMandalaId = UUID().uuidString
                            userRef.setData([generatedMandalaId: [
                                "imageLink": downloadURL.absoluteString,
                                "title": imageName,
                                "drawingData": "" // Empty for now
                            ]], merge: true) { error in
                                if let error = error {
                                    print("Error saving metadata: \(error.localizedDescription)")
                                    return
                                }
                                print("Image and metadata saved successfully")
                            }
                        }
                    }
                } catch {
                    print("Failed to save image to local storage: \(error.localizedDescription)")
                }
            }.resume()
        }
    var body: some View {
        ZStack {

            VStack {
                HeaderView(title: "Mandala Generation", titleSize: 35, subTitle: "", alignLeft: true, height: 190, subMessage: false, subMessageWidth: 233, subMessageText: "Mandalas")
                                    .frame(maxWidth: .infinity, maxHeight: 80, alignment: .topLeading)
                                    .background(Color.white)
                                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.secondarySystemBackground))
                        .frame(height: 200)
                    

                    VStack(spacing: 0) {
                        HStack {
                            TextField("Enter prompt to generate Mandala", text: $prompt)
                                .padding()
                                .padding(.bottom, 4)
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "17335F"))
                                .bold()
                                .background(Color(UIColor.tertiarySystemBackground))
                                .cornerRadius(8)
                                .disabled(prediction?.status.terminated == false)
                            
                            if !prompt.isEmpty {
                                Button(action: {
                                    Task {
                                        try await generate()
                                    }
                                }) {
                                    Image(systemName: "play.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 30))
                                        .padding(.trailing, 8)
                                }
                            }
                        }

                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2)], spacing: 2) {
                            ForEach(examplePrompts, id: \.self) { example in
                                Button(action: {
                                    prompt = example
                                }) {
                                    Text(example)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .bold()
                                        .padding(.vertical, 15)
                                        .padding(.horizontal, 40)
                                        .background(Color(hex: "17335F"))
                                        .cornerRadius(8)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color(hex: "17335F"))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.top, 15)
                    }

                }
                
                .padding()
                // BottomNavBarView()
                
            }
            .edgesIgnoringSafeArea(.bottom)
            
            if prompt.isEmpty {
                VStack {
                            if isArrowVisible {
                                Image("arrow1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300, height: 300)
                                    .foregroundColor(.blue)
                                    .rotationEffect(.degrees(90))
                                    .transition(.opacity)
                            }
                        }
                        .offset(y: 100)
                        .offset(x: -120)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                isArrowVisible = true
                            }
                        }
            }
            
            if let prediction = prediction {
                            ZStack {
                                Color.clear
                                    .aspectRatio(1.0, contentMode: .fit)

                                switch prediction.status {
                                case .starting, .processing:
                                    VStack{
                                        ProgressView("Generating...")
                                            .padding(32)

                                        Button("Cancel") {
                                            Task { try await cancel() }
                                        }
                                    }
                                case .succeeded:
                                    if let url = prediction.output?.first {
                                        VStack {
                                            AsyncImage(url: url, scale: 0.7, content: { phase in
                                                switch phase {
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .cornerRadius(32)
                                                        .frame(width: 800, height: 600) //

                                                case .failure(let error):
                                                    Text("Failed to load image: \(error.localizedDescription)")
                                                case .empty:
                                                    Text("Loading...")
                                                @unknown default:
                                                    Text("Unknown state")
                                                }
                                            })

                                            HStack {
                                                                Spacer()
                                                                Button("Save") {
                                                                    isSaveModalVisible = true
                                                                }
                                                                .padding()
                                                                .foregroundColor(.white)
                                                                .background(Color(hex: "17335F"))
                                                                .cornerRadius(8)
                                                                .padding(.trailing)
                                            }
                                        }
                                        .padding(.bottom,100)
                                        
                                    } else {
                                        Text("No image URL found")
                                    }
                                case .failed:
                                    Text(prediction.error?.localizedDescription ?? "Unknown error")
                                        .foregroundColor(.red)
                                case .canceled:
                                    Text("The prediction was canceled")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .padding()
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init())
                        }
            }
        .sheet(isPresented: $isSaveModalVisible) {
                    VStack {
                        
                        Text("Save generated mandala as")
                            .font(.title)
                            .padding()
                        
                        TextField("Enter image name", text: $imageName)
                            .padding()
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(8)
                            .padding()
                        
                        Button("Save") {
                            saveGeneratedMandala()
                            isSaveModalVisible = false
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
                        
                        Spacer()
                    }
                }
            }

    }

