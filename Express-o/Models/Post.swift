//
//  Post.swift
//  Express-o
//
//  Created by user1 on 31/12/23.
//

import Foundation
struct Post {
    let id: UUID
    let imageName: String
    let title: String
    let description: String
}

extension Post {
    static var examplePosts: [Post] {
        return [
            Post(id: UUID(), imageName: "post1", title: "Artistic Creation", description: "Beautiful art journal entry."),
            Post(id: UUID(), imageName: "post2", title: "Mandala Magic", description: "A mesmerizing mandala artwork."),
            Post(id: UUID(), imageName: "post3", title: "Sketching Adventure", description: "Exploring the world through sketches."),
            Post(id: UUID(), imageName: "post4", title: "Sketching Adventure", description: "Exploring the world through sketches."),
            Post(id: UUID(), imageName: "post5", title: "Sketching Adventure", description: "Exploring the world through sketches."),
            Post(id: UUID(), imageName: "post6", title: "Sketching Adventure", description: "Exploring the world through sketches."),
        

        ]
    }
}
