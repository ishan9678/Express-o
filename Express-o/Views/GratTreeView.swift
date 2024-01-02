//
//  GratTreeView.swift
//  Express-o
//
//  Created by user1 on 02/01/24.
//

import SwiftUI

struct GratTreeView: View {
    @State private var color = Color.brown
    var body: some View {
        VStack{
            //Header
            HeaderView(title: "My Gratitude Tree", subTitle: "", alignLeft: true, height: 245, subMessage: true,subMessageWidth: 315, subMessageText: "What are you grateful for?")
                .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                .background(Color.white)


            Spacer()
           
            Image("gratTree")
                .padding(.bottom,35)
            
            
            HStack{
                ColorPicker("", selection: $color)
                
                Image(systemName: "pencil")
                    .font(.system(size: 40))
                    .padding(.leading,10)
                Image(systemName: "eraser")
                    .font(.system(size: 40))
                Button("Clear") {
                    
                }
                .font(.system(size: 30))
                .foregroundColor(.black)
            }
            .padding(.trailing,65)
            .background(Color(hex: "FEC7C0"))
            .edgesIgnoringSafeArea(.bottom)

            
            BottomNavBarView()
            
          
        }
        .edgesIgnoringSafeArea(.bottom)
       
    }
    
}

#Preview {
    GratTreeView()
}
