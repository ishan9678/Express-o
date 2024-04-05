//
//  Book.swift
//  Express-o
//
//  Created by ishan on 25/03/24.
//

import Foundation

struct Book: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let title: String
    let image: String
}

var sampleBooks:[Book] = [
    .init(title: "Journal 1", image: "cover1"),
    .init(title: "Journal 2", image: "cover2"),
    .init(title: "Journal 3", image: "cover3"),
    .init(title: "Journal 4", image: "cover4")
]
