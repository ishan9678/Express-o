//
//  EmotionView3.swift
//  Express-o
//
//  Created by user1 on 02/01/24.
//

import SwiftUI

struct EmotionView3: View {
    
    @State private var color = Color.blue

    var body: some View {
        VStack{
            // Header
            HeaderView(title: "Emotion-Color Wheel", subTitle: "", alignLeft: false, height: 200, subMessage: false, subMessageWidth: 233, subMessageText: "What are you feeling?   ")
                .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                .background(Color.white)
            
            
            // Description
            Text("Express your emotions that you mentioned in previous page through colors")
                .padding()
                .foregroundColor(Color(hex: "17335F"))
                .font(.system(size: 20))
                .bold()
                .multilineTextAlignment(.center)
                .padding(.bottom,20)
                .padding(.top,10)
                
        
            
            Image("wheel2")

            
            Spacer()
            
            HStack{
                ColorPicker("", selection: $color)
                
                Image(systemName: "pencil")
                    .font(.system(size: 40))
                    .padding(.leading,10)
                Image(systemName: "eraser")
                    .font(.system(size: 40))
                Button("Clear") {
                    
                }
                .font(.system(size: 30))
                .foregroundColor(.black)
            }
            .padding(.trailing,75)
            .background(Color(hex: "FEC7C0"))
            .edgesIgnoringSafeArea(.bottom)

            
            BottomNavBarView()
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
}

#Preview {
    EmotionView3()
}
