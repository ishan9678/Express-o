//
//  HeaderView.swift
//  Express-o
//
//  Created by user1 on 29/12/23.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let titleSize: CGFloat
    let subTitle: String
    let alignLeft: Bool
    let height: CGFloat
    let subMessage: Bool
    let subMessageWidth: CGFloat
    let subMessageText: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color(hex: "FEC7C0"))

            VStack(alignment: alignLeft ? .leading : .center) {
                Text(title)
                    .font(.system(size: titleSize))
                    .foregroundColor(Color(hex: "17335F"))
                    .bold()
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: alignLeft ? .leading : .center)
                    .padding(alignLeft ? .leading : .trailing)
                    .padding(.leading, alignLeft ? 35 : 0)

                Text(subTitle)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "17335F"))
                    .fontWeight(.medium)
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: alignLeft ? .leading : .center)
                    .padding(alignLeft ? .leading : .trailing)
                
                if(subMessage){
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(width: subMessageWidth, height: 43,alignment: alignLeft ? .leading : .center)
                        .padding(alignLeft ? .leading : .trailing)
                        .padding(.leading, alignLeft ? 30 : 0)
                        .overlay(
                            Text(subMessageText)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(Color(hex: "17335F"))
//                            .padding(.leading,50)
                            
                        )
                }
                
                           
            }
            .offset(y: 25)

        }
        .frame(width: UIScreen.main.bounds.width, height: height)
        .offset(y: -80)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Title", titleSize: 35, subTitle: "Sub Title", alignLeft: false, height: 210, subMessage: true, subMessageWidth: 233,subMessageText: "Your Creations"/*, subMessage: true, subMessageWidth: 233, subMessageText: "Sub Message"*/)
    }
}
