//
//  Message.swift
//  Express-o
//
//  Created by user1 on 02/01/24.
//

import Foundation

struct Message: Identifiable {
    var id = UUID()
    var text: String
    var isUser1: Bool // true if the message is from user 1, false if from user 2
}
