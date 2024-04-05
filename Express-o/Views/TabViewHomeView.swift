//
//  TabViewHomeView.swift
//  Express-o
//
//  Created by admin on 05/03/24.
//

import SwiftUI

struct TabViewHomeView: View {
    let examplePosts = ArtJournalPost.examplePosts
    let examplePins = Pins.examplePins
    let exampleCreations = ArtJournalPost.examplePosts
    
    @State var selectedTab : Int = 0
    var body: some View {
        TabView(selection : $selectedTab){
            NewHomeView()
                .tabItem {
                        Image(systemName: "house.circle.fill")
                            
                        Text("Home")
                }
                .tag(0)
                
            
            SketchingView()
                .tabItem {
                    Image(systemName: "pencil.circle.fill")
                    Text("Sketching")
                }
                .tag(1)
            
            BookTemplates()
                .tabItem {
                    Image(systemName: "book.circle.fill" )
                    Text("Art Journal")
                }
                .tag(2)
            
            MandalaView()
                .tabItem {
                    Image(systemName: "star.circle.fill")
                    Text("Mandala Art")
                }
                .tag(3)
            
            ProfileView(posts: examplePins, creations: exampleCreations)
                .tabItem { 
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
                .tag(4)
            
        }
    }
}

#Preview {
    TabViewHomeView()
}
