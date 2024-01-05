//
//  PostGridView.swift
//  Express-o
//
//  Created by user1 on 31/12/23.
//

import SwiftUI

struct PostGridView: View {
    private var homeGridItems: [GridItem] = [
        .init(.flexible())
    ]

    @Binding var postSelection: Post?

    init(postSelection: Binding<Post?>) {
        self._postSelection = postSelection
    }

    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                LazyVGrid(columns: homeGridItems) {
                    ForEach(Array(Post.examplePosts.enumerated()), id: \.1.id) { index, post in
                        if index % 2 != 0 {
                            NavigationLink(destination: PostDetailView(post: post)) {
                                PostGridCell(post: post)
                                    .onTapGesture {
                                        print("efef")
                                        postSelection = post
                                    }
                            }
                        }
                    }
                }

                LazyVGrid(columns: homeGridItems) {
                    ForEach(Array(Post.examplePosts.enumerated()), id: \.1.id) { index, post in
                        if index % 2 == 0 {
                            NavigationLink(destination: PostDetailView(post: post)) {
                                PostGridCell(post: post)
                                    .onTapGesture {
                                        postSelection = post
                                    }
                            }
                        }
                    }
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
