//
//  EmotionView2.swift
//  Express-o
//
//  Created by user1 on 02/01/24.
//

import SwiftUI

struct EmotionView2: View {
    @State private var color = Color.blue
    @State private var navigateToEmotionView3 = false // Added state for navigation

    var body: some View {
        NavigationView {
            VStack {
                // Header
                HeaderView(title: "Emotion-Color Wheel", subTitle: "", alignLeft: false, height: 200, subMessage: false, subMessageWidth: 233, subMessageText: "What are you feeling?   ")
                    .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                    .background(Color.white)

                Spacer()
                
                

                Image("wheel1")
                    .background(NavigationLink("", destination: EmotionView3(), isActive: $navigateToEmotionView3))
                    .onTapGesture {
                        navigateToEmotionView3.toggle()

                    }
                
                Spacer()

                HStack {
                    ColorPicker("", selection: $color)

                    Button(action: {
                        
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 40))
                            .padding(.leading, 10)
                    }
        
                    Image(systemName: "eraser")
                        .font(.system(size: 40))

                    Button("Clear") {
                        // Add action for clear button if needed
                    }
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                }
                .padding(.trailing, 75)
                .background(Color(hex: "FEC7C0"))
                .edgesIgnoringSafeArea(.bottom)

                BottomNavBarView()
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarHidden(true)
    }
}

struct EmotionView2_Previews: PreviewProvider {
    static var previews: some View {
        EmotionView2()
    }
}

