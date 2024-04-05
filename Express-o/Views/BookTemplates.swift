//
//  BookTemplates.swift
//  Express-o
//
//  Created by ishan on 25/03/24.
//

import SwiftUI

struct BookTemplates: View {
    @State var currentBook: Book = sampleBooks.first!
    
    var body: some View {
        VStack {
            BookSlider(currentBook: $currentBook)
            SliderBottomView(currentBook: $currentBook)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    BookTemplates()
}
