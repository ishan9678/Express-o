//
//  bottomNavBarView.swift
//  Express-o
//
//  Created by user1 on 31/12/23.
//

import SwiftUI

let icons = ["home", "sketching", "journal", "mandala", "profile"]

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
                return AnyView(HomeView())
            case "sketching":
              
                return AnyView(SketchingView())
                
            case "journal":
                let examplePosts = ArtJournalPost.examplePosts
                return AnyView(ArtJournalView(posts: examplePosts))
                
            case "mandala":
                return AnyView(MandalaView())
                
            case "profile":
                let examplePins = Pins.examplePins
                let exampleCreations = ArtJournalPost.examplePosts
                return AnyView(ProfileView(posts: examplePins, creations: exampleCreations))
            
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
