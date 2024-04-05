//
//  BookFlip.swift
//  Express-o
//
//  Created by ishan on 23/03/24.
//


import SwiftUI

struct BookFlip: View {
    @State private var currentPage = 0
    @State var isLeftFlipped = false
    @State var isRightFlipped = false

    let imageNames = ["doodle1", "doodle4", "doodle2", "doodle3"] // Add more image names as needed

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                PageView(imageName: imageNames[currentPage * 2])
//                    .transition(.flipPage())
//                    .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                    .rotation3DEffect(
                        .degrees(isLeftFlipped ? 180 : 0) ,
                                              axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
                    )
                    .offset(x: isLeftFlipped ? 500 : 0)
                    .onTapGesture {
                        withAnimation {
                            isLeftFlipped.toggle()
                            if currentPage > 0 {
                                currentPage -= 1
                            }
                        }
                        
                    }
                PageView(imageName: imageNames[currentPage * 2 + 1])
                    .rotation3DEffect(
                        .degrees(isRightFlipped ? -90 : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .offset(x: isRightFlipped ? -500 : 0)
                    .onTapGesture {
                        withAnimation(Animation.linear(duration: 0.5)) {
                            isRightFlipped.toggle()
                        } completion: {
                            if isRightFlipped && currentPage < (imageNames.count / 2) - 1 {
                                currentPage += 1
                            }
                            withAnimation(Animation.linear(duration: 0.5)) {
                                isRightFlipped.toggle()
                            }
                        }
                    }

            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(10)
//            .shadow(radius: 5)
            HStack {
                Button("Previous Page") {
                    withAnimation {
                        if currentPage > 0 {
                            currentPage -= 1
                        }
                    }
                }
                Spacer()
                Button("Next Page") {
                    withAnimation {
                        if currentPage < (imageNames.count / 2) - 1 {
                            currentPage += 1
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: 1000, maxHeight: 700)
    }
}

struct PageView: View {
    let imageName: String

    var body: some View {
        GeometryReader { geometry in
            let centerOffset = geometry.size.width / 2 // Calculate the center of the page

            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .alignmentGuide(.top) { _ in
                        if geometry.size.width > geometry.size.height {
                            return (geometry.size.height - geometry.size.width) / 2
                        } else {
                            return 0
                        }
                    }
            }
        }
    }
}


struct BookFlip_Previews: PreviewProvider {
    static var previews: some View {
        BookFlip()
    }
}
