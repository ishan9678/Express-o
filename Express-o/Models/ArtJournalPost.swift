//
//  ArtJournalPost.swift
//  Express-o
//
//  Created by user1 on 01/01/24.
//

import Foundation

struct ArtJournalPost: Identifiable {
    var id = UUID()
    var imageName: String
    var title: String
}
extension ArtJournalPost {
    static var examplePosts: [ArtJournalPost] {
        return [
            ArtJournalPost(id: UUID(), imageName: "add_new", title: "Create New"),
            ArtJournalPost(id: UUID(), imageName: "journal1", title: "Thoughts"),
            ArtJournalPost(id: UUID(), imageName: "journal2", title: "Music"),
            ArtJournalPost(id: UUID(), imageName: "to-do", title: "To-do"),
            ArtJournalPost(id: UUID(), imageName: "to-do", title: "To-do"),
            ArtJournalPost(id: UUID(), imageName: "to-do", title: "To-do"),
            ArtJournalPost(id: UUID(), imageName: "to-do", title: "To-do"),
            ArtJournalPost(id: UUID(), imageName: "to-do", title: "To-do"),
        ]
    }
}
