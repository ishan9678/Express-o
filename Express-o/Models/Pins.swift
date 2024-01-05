//
//  Pins.swift
//  Express-o
//
//  Created by user1 on 03/01/24.
//

import Foundation

struct Pins: Identifiable {
    var id = UUID()
    var imageName: String
    var title: String
}
extension Pins {
    static var examplePins: [Pins] {
        return [
            Pins(id: UUID(), imageName: "Pins1", title: "Day 3 Sketching"),
            Pins(id: UUID(), imageName: "Pins2", title: "Memories"),
            Pins(id: UUID(), imageName: "Pins3", title: "Cartoon Sketch"),
            Pins(id: UUID(), imageName: "Pins4", title: "Mandala"),
        ]
    }
}
