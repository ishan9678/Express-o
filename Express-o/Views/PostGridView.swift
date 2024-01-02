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

    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                LazyVGrid(columns: homeGridItems) {
                    ForEach(Array(Post.examplePosts.enumerated()), id: \.1.id) { index, post in
                        if index % 2 != 0 {
                            PostGridCell(post: post)
                        }
                    }
                }
                .onPreferenceChange(ViewHeightKey.self) { newHeight in
                    // Handle height change if needed
                }

                LazyVGrid(columns: homeGridItems) {
                    ForEach(Array(Post.examplePosts.enumerated()), id: \.1.id) { index, post in
                        if index % 2 == 0 {
                            PostGridCell(post: post)
                        }
                    }
                }
                .onPreferenceChange(ViewHeightKey.self) { newHeight in
                    // Handle height change if needed
                }
            }

        }
    }
}
