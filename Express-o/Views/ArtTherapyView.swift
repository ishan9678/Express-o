//
//  ArtTherapyView.swift
//  Express-o
//
//  Created by user1 on 02/01/24.
//

import SwiftUI

struct ArtTherapyView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HeaderView(title: "Art Therapy", titleSize: 35, subTitle: "", alignLeft: true, height: 245, subMessage: true, subMessageWidth: 283, subMessageText: "Your daily quest awaits")
                    .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                    .background(Color.white)
                    .padding(.bottom, 60)

                // Art therapy options
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 40) {
                    NavigationLink(
                        destination: MandalaView(), // Adjust the destination view
                        label: {
                            ArtTherapyPostView(imageName: "Mandala", title: "Mandala Art")
                        })
//                    NavigationLink(
//                        destination: SketchingView(),
//                        label: {
//                            ArtTherapyPostView(imageName: "sketching", title: "Sketching")
//                        })
//                                        NavigationLink(
//                        destination: EmotionView1(),
//                        label: {
//                            ArtTherapyPostView(imageName: "emotion_wheel", title: "Emotion Wheel")
//                        })
                }
                .padding(15)

                Spacer()

                BottomNavBarView()
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ArtTherapyPostView: View {
    let imageName: String
    let title: String

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: min(geometry.size.width, 200), maxHeight: min(geometry.size.width * 1.1, 220)) // Set maximum width and height
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 10) // Add some horizontal padding

                Text(title)
                    .foregroundColor(Color(hex: "17335F"))
                    .bold()
                    .font(.system(size: 16, weight: .bold)) // Set a base size and weight
                    .padding(.top, 8) // Add some spacing between image and text
                    .frame(maxWidth: .infinity, alignment: .leading) // Align text to the leading edge
                    .minimumScaleFactor(0.5) // Allow the text to scale down to half its size if needed
                    .lineLimit(2) // Limit the number of lines to 2 for better appearance
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}



struct ArtTherapyView_Previews: PreviewProvider {
    static var previews: some View {
        ArtTherapyView()
    }
}

