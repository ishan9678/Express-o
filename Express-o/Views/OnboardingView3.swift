//
//  OnboardingView3.swift
//  Express-o
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct OnboardingView3: View {
    var body: some View {
        
            VStack{
                // Header
                HeaderView(title: "Art Journal", titleSize: 48, subTitle: "", alignLeft: false, height: 245, subMessage: false, subMessageWidth: 283, subMessageText: "")
                    .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                    .background(Color.white)
                    .padding(.bottom, 20)
                    .padding(.top,20)
                
                //Image
                Image("ArtJournalImage")
                    .padding(.bottom,80)
                    .padding(.top,20)
                
                //text message
                Text("Express Your Journey: Journaling Redefined")
                    .foregroundStyle(Color(hex: "17335F"))
                    .frame(width: 600)
                    .font(.system(size: 36))
                    .bold()
                    .multilineTextAlignment(.center)
                
                //onboarding navigation
                
                OnboardNavigationView(selectedIndex: 2)


                Spacer()
            }
            .background(Color(hex: "FEC7C0"))
        
    }
    
}

#Preview {
    OnboardingView3()
}
