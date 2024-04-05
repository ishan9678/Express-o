//
//  GeneratedMandalaPost.swift
//  Express-o
//
//  Created by admin on 05/03/24.
//

import Foundation
import SwiftUI

struct GeneratedMandalaPost: Identifiable {
    var id = UUID()
    var generatedMandalaID: String
    var title: String
    var drawingData: Data?
    var imageLink: String
    var uiImage: UIImage?
    let isTemplate: Bool
}

extension Notification.Name {
    static let newGeneratedMandala = Notification.Name("newGeneratedMandala")
}
