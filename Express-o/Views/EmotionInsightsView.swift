import SwiftUI
import GoogleGenerativeAI


let apiKey = "AIzaSyDIqEhzPpGlGf_QChIkre-_a8INLBxobG4"

let config = GenerationConfig(
    temperature: 0.4,
    topP: 1,
    topK: 32,
    maxOutputTokens: 4096
)

let model = GenerativeModel(name: "gemini-pro-vision", apiKey: apiKey, generationConfig: config)

//let prompt = "Describe the following doodle in second person, taking into account its composition, colors, and overall mood. Try to infer the emotions you might be feeling and why, based on the elements present in the doodle. Give the output in format 'description: | emotions: ' where emotions is a list of emotions as emojis."



struct EmotionInsightsView: View {
    @State private var description: String?
    @State private var emotions: [String]?
    @State private var isLoading = true
    @State private var isTypingFinished = false
    @State private var showEmotions = false
    @State var prompt: String
    
    
    var image : UIImage
    
    
    var body: some View {
        VStack {
            HeaderView(title: "Emotion Insights", titleSize: 35, subTitle: "", alignLeft: true, height: 190, subMessage: false, subMessageWidth: 233, subMessageText: "Mandalas")
                .frame(maxWidth: .infinity, maxHeight: 80, alignment: .topLeading)
                .background(Color.white)
            
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400)
                    .padding()
                    .padding(.top,40)
            
            if let description = description {
                TypingText(text: description) {
                    // This closure will be called when the typing animation finishes
                    isTypingFinished = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            showEmotions = true
                    }
                }
                .padding(.bottom,60)
            }
            
            if showEmotions && emotions != nil { // Display emotions only after typing animation finishes
                Text("You are feeling")
                    .font(.system(size: 26))
                    .foregroundStyle(.blue)
                    .bold()

                HStack(spacing: 20) {
                    ForEach(emotions!.indices, id: \.self) { index in
                        let emotion = emotions![index].components(separatedBy: ": ").last ?? ""
                        Text(emotion)
                            .font(.system(size: 130)) // Set the font size to match the circle size
                            .opacity(showEmotionAtIndex(index) ? 1 : 0) // Fade in animation
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    // Animate the appearance of each emoji
                                }
                            }
                    }
                }

                .padding()
            }
            if isLoading{
                ZStack{
                    GifImage(name: "loading2")
                    Text("Analyzing your doodle...")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .padding(.top,40)
                }
                .padding()
            }

            Spacer()
        }
        .onAppear {
            Task {
                do {
                    let response = try await model.generateContent(prompt, image)
                    
                    if let jsonString = response.text {
                        print("jsonString",jsonString)
                        let components = jsonString.components(separatedBy: "|")
                        if components.count == 2 {
                            let description = components[0].replacingOccurrences(of: "description:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                            let emotionsString = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                            let emotions = emotionsString.components(separatedBy: ", ")
                            
                            print("Description:", description)
                            print("Emotions:", emotions)
                            
                            self.description = description
                            self.emotions = emotions
                        } else {
                            print("Invalid response format")
                        }
                    } else {
                        print("No JSON string found in response")
                    }
                    
                    isLoading = false
                } catch {
                    print("Error generating content: \(error)")
                    isLoading = false
                }
            }
        }


    }
    
    private func showEmotionAtIndex(_ index: Int) -> Bool {
           return showEmotions && isTypingFinished && index < emotions!.count
       }
}

struct EmotionInsightsView_Previews: PreviewProvider {
    static var previews: some View {
        EmotionInsightsView(prompt: "", image:  UIImage(named: "mandala1")!)
    }
}


