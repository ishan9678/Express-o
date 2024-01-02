//
//  ArtJournalPostView.swift
//  Express-o
//
//  Created by user1 on 01/01/24.
//

import SwiftUI

struct ArtJournalPostView: View {
    let post: ArtJournalPost

    var body: some View {
        VStack {
            Image(post.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 168, height: 185)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Text(post.title)
                .foregroundColor(Color(hex: "17335F"))
                .bold()
                .font(.system(size: 16))
        }
    }
}

#if DEBUG
struct ArtJournalPostView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = ArtJournalPost.examplePosts[0]
        return ArtJournalPostView(post: samplePost)
    }
}
#endif
