//
//  OnboardingView2.swift
//  Express-o
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct OnboardingView2: View {
    var body: some View {
        VStack{
            // Header
            HeaderView(title: "Mandala Art", titleSize: 48, subTitle: "", alignLeft: false, height: 245, subMessage: false, subMessageWidth: 283, subMessageText: "")
                .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                .background(Color.white)
                .padding(.bottom, 20)
                .padding(.top,20)
            
            //Image
            Image("mandalaOnboardImage")
                .padding(.bottom,40)
            
            //text message
            Text("Express Serenity: Mandala Art for Mindful Creativity.")
                .foregroundStyle(Color(hex: "17335F"))
                .frame(width: 600)
                .font(.system(size: 36))
                .bold()
                .multilineTextAlignment(.center)
            
            //onboarding navigation
            OnboardNavigationView(selectedIndex: 1)

            
            Spacer()
        }
        .background(Color(hex: "FEC7C0"))
    }
}

#Preview {
    OnboardingView2()
}
