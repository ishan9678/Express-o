//
//  OnboardingView1.swift
//  Express-o
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct OnboardingView1: View {
    var body: some View {
        VStack{
            // Header
            HeaderView(title: "Sketch", titleSize: 48, subTitle: "", alignLeft: false, height: 245, subMessage: false, subMessageWidth: 283, subMessageText: "")
                .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                .background(Color.white)
                .padding(.bottom, 20)
                .padding(.top,20)
            
            //image
            Image("sketchOnboardingImage")
                .padding(.bottom,40)
            
            //text message
            Text(" Sketch, Express Your Thoughts into Artful Expressions.")
                .foregroundStyle(Color(hex: "17335F"))
                .frame(width: 600)
                .font(.system(size: 36))
                .bold()
                .multilineTextAlignment(.center)
            
            //onboarding navigation
            OnboardNavigationView(selectedIndex: 0)
            
            Spacer()
        }
        .background(Color(hex: "FEC7C0"))
    }
}

#Preview {
    NavigationStack {
        OnboardingView1()
    }
}
