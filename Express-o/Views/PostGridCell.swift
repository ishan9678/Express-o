//
//  PostGridCell.swift
//  Express-o
//
//  Created by user1 on 31/12/23.
//

import SwiftUI

struct PostGridCell: View {
    let post: Post

    var body: some View {
        Image(post.imageName)
            .resizable()
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity)
            .background(GeometryReader { proxy in
                Color.clear.preference(key: ViewHeightKey.self, value: proxy.size.height)
            })
            .padding([.leading, .trailing], 8) // Adjust the padding value as needed
    }
    
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
