import SwiftUI
import Replicate

private let client = Replicate.Client(token: "r8_dfjKESrqjTw0dFeCnuJBcu8lYVs4bTQ0gqDiB")

enum StableDiffusion: Predictable {
    static var modelID = "stability-ai/stable-diffusion"
    static let versionID = "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf"

    struct Input: Codable {
        let prompt: String
    }

    typealias Output = [URL]
}

struct MandalaGenerationView_Previews: PreviewProvider {
    static var previews: some View {
        MandalaGenerationView(prompt: "Mandala Art without Color, so i can color it")
    }
}

struct MandalaGenerationView: View {
    @State private var prompt = ""
    @State private var prediction: StableDiffusion.Prediction? = nil

    func generate() async throws {
        prediction = try await StableDiffusion.predict(with: client,
                                                       input: .init(prompt: prompt))
        try await prediction?.wait(with: client)
    }

    func cancel() async throws {
        try await prediction?.cancel(with: client)
    }
    
    init(prompt: String) {
            self._prompt = State(initialValue: prompt)
        }

    var body: some View {
        Form {
            Section {
                TextField(text: $prompt,
                          prompt: Text("Enter prompt to generate Mandala"),
                          axis: .vertical,
                          label: {})
                    .disabled(prediction?.status.terminated == false)
                    .submitLabel(.go)
                    .onSubmit(of: .text) {
                        Task {
                            try await generate()
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
                                AsyncImage(url: url, scale: 2.0, content: { phase in
                                    phase.image?
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(32)
                                })

                                ShareLink("Export", item: url)
                                    .padding(32)
                            }
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
    }
}

