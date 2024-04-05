import SwiftUI

struct TypingText: View {
    let text: String
    let completion: () -> Void // Completion closure
    
    @State private var displayedText: String = ""
    @State private var currentIndex: Int = 0
    private let typingSpeed: Double = 0.05 // Adjust the typing speed as needed

    var body: some View {
        ZStack {
                Text(displayedText)
                        .padding()
                        .frame(width: 600)
                        .font(.system(size: 26))
                        .foregroundColor(.purple)
                
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
                if currentIndex < text.count {
                    displayedText.append(text[text.index(text.startIndex, offsetBy: currentIndex)])
                    currentIndex += 1
                } else {
                    timer.invalidate()
                    // Call completion closure when typing animation completes
                    completion()
                }
            }
        }
    }
}
