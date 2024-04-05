//
//  MandalaPost.swift
//  Express-o
//
//  Created by admin on 01/03/24.
//

import Foundation

struct MandalaPost: Identifiable {
    var id = UUID()
    var imageName: String
    var title: String
    let imageData: Data
}

extension MandalaPost {
    static var examplePosts: [MandalaPost] {
        return [
            MandalaPost(id: UUID(), imageName: "MandalaTemplate2", title: "Mandala 1", imageData: Data()),
            MandalaPost(id: UUID(), imageName: "MandalaTemplate3", title: "Frog Mandala", imageData: Data()),
            MandalaPost(id: UUID(), imageName: "MandalaTemplate4", title: "Mandala 3", imageData: Data()),
            MandalaPost(id: UUID(), imageName: "mandala3", title: "Mandala 4", imageData: Data()),

        ]
    }
}

