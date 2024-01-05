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
                HeaderView(title: "Art Therapy", subTitle: "", alignLeft: true, height: 245, subMessage: true, subMessageWidth: 283, subMessageText: "Your daily quest awaits")
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
                    NavigationLink(
                        destination: SketchingView(),
                        label: {
                            ArtTherapyPostView(imageName: "sketching", title: "Sketching")
                        })
                    NavigationLink(
                        destination: GratTreeView(),
                        label: {
                            ArtTherapyPostView(imageName: "grat", title: "Grat Tree")
                        })
                    NavigationLink(
                        destination: EmotionView1(),
                        label: {
                            ArtTherapyPostView(imageName: "emotion_wheel", title: "Emotion Wheel")
                        })
                }
                .padding(15)

                Spacer()

                BottomNavBarView()
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }
}

struct ArtTherapyPostView: View {
    let imageName: String
    let title: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 168, height: 185)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Text(title)
                .foregroundColor(Color(hex: "17335F"))
                .bold()
                .font(.system(size: 16))
        }
    }
}

struct ArtTherapyView_Previews: PreviewProvider {
    static var previews: some View {
        ArtTherapyView()
    }
}
