//
//  Utility.swift
//  Express-o
//
//  Created by ishan on 25/03/24.
//

import Foundation

func indexOf(book: Book) -> Int {
    if let index = sampleBooks.firstIndex(of: book) {
        return index
    }
    return 0
}
