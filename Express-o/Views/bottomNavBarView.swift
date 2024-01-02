//
//  bottomNavBarView.swift
//  Express-o
//
//  Created by user1 on 31/12/23.
//

import SwiftUI

let icons = ["home", "art_therapy", "journal", "nova", "profile"]

struct BottomNavBarView: View {
    var body: some View {
        HStack(spacing: 0) {
            ForEach(icons, id: \.self) { iconName in
                Spacer()
                NavigationLink(
                    destination: destinationView(for: iconName), label: {
                        Image(iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    })
                Spacer()
            }
        }
        .frame(height: 60)
        .background(Color.white)
        .border(Color.gray.opacity(0.5), width: 0.5)
    }
    private func destinationView(for iconName: String) -> some View {
            switch iconName {
            case "home":
                print("Icon tapped")
                return AnyView(HomeView())
                
            case "profile":
                return AnyView(ProfileView())
          
            default:
                return AnyView(HomeView())
            }
        }
    }




#if DEBUG
struct BottomNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBarView()
    }
}
#endif
