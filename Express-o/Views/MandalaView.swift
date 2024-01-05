//
//  MandalaView.swift
//  Express-o
//
//  Created by user1 on 02/01/24.
//

import SwiftUI

struct MandalaView: View {
    @State private var color = Color.orange
    
    var body: some View {
        NavigationView{
            VStack{
                //Header
                HeaderView(title: "Mandala Art", subTitle: "", alignLeft: true, height: 245, subMessage: true,subMessageWidth: 233, subMessageText: "Mandala Name...")
                    .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                    .background(Color.white)
                
                
                Spacer()
                // Mandala
                Image("Mandala_Art")
                
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
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    MandalaView()
}
