//
//  ButtonView.swift
//  Express-o
//
//  Created by user1 on 29/12/23.
//

import SwiftUI

struct ButtonView: View {
    
    let title : String;
    let action : () -> Void;
    
    var body: some View {
        Button{
            // Action
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(hex: "17335F"))
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(title: "title"){
            // Action
        }
    }
}
