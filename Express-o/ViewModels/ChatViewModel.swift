//
//  ChatViewModel.swift
//  Express-o
//
//  Created by user1 on 02/01/24.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []

    func sendMessage(text: String, isUser1: Bool) {
        let message = Message(text: text, isUser1: isUser1)
        messages.append(message)
    }
}

