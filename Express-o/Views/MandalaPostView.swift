////
////  MandalaPostView.swift
////  Express-o
////
////  Created by admin on 01/03/24.
////
//
//import SwiftUI
//
//struct MandalaPostView: View {
//    let post: MandalaPost
//    @State private var isShowingCanvas = false
//
//    var body: some View {
//        NavigationLink(destination: MandalaCanvasView(image: UIImage(named: post.imageName), imageName: post.imageName)) {
//            VStack {
//                Image(post.imageName)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 350, height: 350)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//
//                Text(post.title)
//                    .foregroundColor(Color(hex: "17335F"))
//                    .bold()
//                    .font(.system(size: 20))
//            }
//        }
//    }
//}
//
//
//
//#if DEBUG
//struct MandalaPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        let samplePost = MandalaPost.examplePosts[0]
//        return MandalaPostView(post: samplePost)
//    }
//}
//#endif
