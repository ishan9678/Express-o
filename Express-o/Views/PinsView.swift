//
//  PinsView.swift
//  Express-o
//
//  Created by user1 on 03/01/24.
//

import SwiftUI


struct PinsView: View {
    let post: Pins

    var body: some View {
        VStack {
            Image(post.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 350, height: 350)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Text(post.title)
                .foregroundColor(Color(hex: "17335F"))
                .bold()
                .font(.system(size: 20))
        }
    }
}

#if DEBUG
struct PinsView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePin = Pins.examplePins[0]
        return PinsView(post: samplePin)
    }
}
#endif

