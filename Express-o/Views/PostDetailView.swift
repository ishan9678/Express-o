//
//  PostDetailView.swift
//  Express-o
//
//  Created by user1 on 02/01/24.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post

    var body: some View {
        VStack {
            Image(post.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Add additional details or actions related to the post as needed
            Text(post.title)
                .padding()
            
            Text(post.description)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .toolbar(.hidden)
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let examplePost = Post.examplePosts[0]
        PostDetailView(post: examplePost)
    }
}

