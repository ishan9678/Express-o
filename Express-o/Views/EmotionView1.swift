import SwiftUI

struct EmotionView1: View {
    @State private var selectedEmotions: [String] = []
    @State private var navigateToEmotionView2 = false // Added state for navigation

    let emotions = ["Scared", "Sad", "Tired", "Excited", "Happy", "Love", "Anger", "Peace"] // Moved inside the struct

    var body: some View {
        NavigationView {
            VStack {
                // Header
                HeaderView(title: "Emotion-Color Wheel", subTitle: "", alignLeft: false, height: 200, subMessage: false, subMessageWidth: 233, subMessageText: "What are you feeling?   ")
                    .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                    .background(Color.white)

                // Description
                Text("Picture your day as a wheel of emotions. What top 6 feelings colored your moments? Share the vibes that made your day unique! 🌈✨")
                    .padding()
                    .foregroundColor(Color(hex: "17335F"))
                    .font(.headline)
                    .multilineTextAlignment(.center)

                // Display the selected emotions
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 8) {
                        ForEach(selectedEmotions, id: \.self) { selectedEmotion in
                            Text("Picked Feeling: \(selectedEmotion)")
                                .padding()
                                .bold()
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: "17335F")))
                        }
                    }
                }
                .padding()

                Spacer()

                // Emotion Buttons with LazyVGrid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(emotions, id: \.self) { emotion in
                        EmotionButton(emotion: emotion, isSelected: selectedEmotions.contains(emotion), action: { toggleEmotion(emotion) })
                    }
                }
                .padding()
                
                

                // NavigationLink to EmotionView2
                NavigationLink(
                    destination: EmotionView2(),
                    isActive: $navigateToEmotionView2,
                    label: {
                        EmptyView()
                    })
                
                BottomNavBarView()
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }

    private func toggleEmotion(_ emotion: String) {
        if selectedEmotions.contains(emotion) {
            selectedEmotions.removeAll { $0 == emotion }
        } else {
            selectedEmotions.append(emotion)
        }
        
        if selectedEmotions.count == 6 {
                    navigateToEmotionView2 = true
        }
    }
}

struct EmotionButton: View {
    var emotion: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Text(emotion)
                    .foregroundColor(isSelected ? .white : .black)
                    .font(.headline)
                    .bold()
                Spacer()
            }
            .padding()
            .frame(width: 90, height: 50)
            .background(
                Ellipse()
                    .fill(isSelected ? Color(hex: "FEC7C0") : Color.white)
                    .overlay(Ellipse().stroke(Color.black, lineWidth: 1))
            )
        }
    }
}

struct EmotionView1_Previews: PreviewProvider {
    static var previews: some View {
        EmotionView1()
    }
}

