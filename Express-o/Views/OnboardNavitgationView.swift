//
//  OnboardNavitgationView.swift
//  Express-o
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

import SwiftUI

struct OnboardNavigationView: View {
    let selectedIndex: Int
    
    var body: some View {
        HStack(spacing: 10) {
            Spacer()
            
            ForEach(0..<3) { index in
                NavigationLink(
                    destination: destinationView(for: index),
                    isActive: .constant(index == selectedIndex),
                    label: {
                        Circle()
                            .fill(index == selectedIndex ? Color(hex: "17335F") : Color.white)
                            .frame(width: 39, height: 39)
                    }
                )
            }
            
            HStack {
                
                NavigationLink("Skip") {
                    TabViewHomeView()
                }
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(Color(hex: "17335F"))
                .cornerRadius(20)
                .padding(.trailing, 80)
            }
            .padding(.leading, 140)
        }
        .padding(.vertical, 20)
    }
    
    // Function to determine the destination view based on the index
    func destinationView(for index: Int) -> some View {
        switch index {
        case 0:
            return AnyView(OnboardingView1())
        case 1:
            return AnyView(OnboardingView2())
        case 2:
            return AnyView(OnboardingView3())
        default:
            return AnyView(EmptyView())
        }
    }
}

struct OnboardNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OnboardNavigationView(selectedIndex: 1)
        }
    }
}
