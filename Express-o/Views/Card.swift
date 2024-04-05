//
//  Card.swift
//  Express-o
//
//  Created by ishan on 24/03/24.
//

import SwiftUI

struct Card: View {
    @State var currentPage = 0
    @State var leftPage = 0
    @State var rightPage = 0
    @State var isRightPageFlipped = false
    @State var isLeftPageFlipped = false
    @State var alternateRightPageFlipped = false
    @State var alternateLeftPageFlipped = false


    let imageNames = ["doodle1", "doodle2", "doodle3", "doodle4","Mandala1", "mandala", "mandala3", "mandala4"]

    var body: some View {
        HStack {
            ZStack {
                myCard(imageName: imageNames[alternateRightPageFlipped ? currentPage  : isRightPageFlipped ? currentPage + 2 : currentPage], color: .red)
                    .rotation3DEffect(
                        .degrees(alternateLeftPageFlipped ? -180 : leftPage % 2 == 0 ? 0 : 180),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .offset(x: isRightPageFlipped || isLeftPageFlipped ? 210 : 0)
                    .offset(x: alternateLeftPageFlipped ? -210 : 0)
                    .animation(.linear(duration: 0.35), value: currentPage)
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            if currentPage > 0 {
                                if currentPage % 2 == 0 {
                                    currentPage -= 1
                                    isLeftPageFlipped.toggle()
                                    if alternateLeftPageFlipped == true {
                                        alternateLeftPageFlipped = false
                                    }
                                    print("Left Page Flipped: \(isLeftPageFlipped), Angle: \(alternateLeftPageFlipped ? -180 : leftPage % 2 == 0 ? 0 : 180)")
                                } else {
                                    currentPage += 1
                                    alternateLeftPageFlipped.toggle()
                                    isLeftPageFlipped.toggle()
                                    print("Left Page Flipped: \(isLeftPageFlipped), Angle: \(alternateLeftPageFlipped ? -180 : leftPage % 2 == 0 ? 0 : 180)")
                                    print("Alternate Left Page Flipped: \(alternateLeftPageFlipped)")
                                    print("Current Page: \(currentPage)")
                                }
                            }
                        }
                    }
            }
            ZStack {
                myCard(imageName: imageNames[alternateLeftPageFlipped ? currentPage + 3 : currentPage + 1], color: .blue)
                    .rotation3DEffect(
                        .degrees(alternateLeftPageFlipped ? -180 : currentPage % 2 == 0 ? 0 : -180),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .offset(x: isRightPageFlipped || isLeftPageFlipped ? -210 : 0)
                    .offset(x: alternateLeftPageFlipped ? 210 : 0)
                    .animation(.linear(duration: 0.35), value: currentPage)
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            if currentPage < imageNames.count - 2 {
                                if currentPage % 2 == 0 {
                                    currentPage += 1
                                    isRightPageFlipped = true
                                    if alternateRightPageFlipped == true {
                                        alternateRightPageFlipped = false
                                    }
                                    print("Right Page Flipped: \(isRightPageFlipped), Angle: \(alternateLeftPageFlipped ? -180 : currentPage % 2 == 0 ? 0 : -180)")
                                    print(currentPage)
                                } else {
                                    currentPage -= 1
                                    alternateRightPageFlipped.toggle()
                                    isRightPageFlipped = false
                                    print("Right Page Flipped: \(isRightPageFlipped), Angle: \(alternateLeftPageFlipped ? -180 : currentPage % 2 == 0 ? 0 : -180)")
                                    print("Alternate Right Page Flipped: \(alternateRightPageFlipped)")
                                    print("Current Page: \(currentPage)")
                                }
                            }
                        }
                    }
            }
        }
    }
}


struct myCard: View {
    var imageName: String
    var color: Color

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 300)
                .clipped()
                .background(color)
                .cornerRadius(20)
            Text("")
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card()
    }
}
