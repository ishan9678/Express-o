//
//  User.swift
//  Express-o
//
//  Created by user1 on 29/12/23.
//

import Foundation

struct User: Codable {
    let id : String
    let name: String
    let email: String
    let joined: TimeInterval
}
