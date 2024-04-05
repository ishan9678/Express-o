//
//  ArtJournalView.swift
//  Express-o
//
//  Created by user1 on 29/12/23.
//

import SwiftUI

struct ArtJournalView: View {
    let posts: [ArtJournalPost]
    
    init(posts: [ArtJournalPost]) {
        self.posts = posts
    }
    
    var body: some View {
        NavigationView{
            VStack() {
                // Header
                HeaderView(title: "Art Journal", titleSize: 35, subTitle: "", alignLeft: true, height: 230,subMessage: true, subMessageWidth: 233 ,subMessageText: "Your Creations")
                    .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                    .background(Color.white)
                    .padding(.bottom,40)
                
                // ArtJournal Entries
                ScrollView{
                    
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 40) {
                        ForEach(posts) { post in
                            ArtJournalPostView(post: post)
                        }
                    }
                    .padding(15)
                    
                }
                
                Spacer()
                
                //BottomNavBarView()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ArtJournalView_Previews: PreviewProvider {
    static var previews: some View {
        let examplePosts = ArtJournalPost.examplePosts
        return ArtJournalView(posts: examplePosts)
    }
}

