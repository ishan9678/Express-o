//
//  MandalaView.swift
//  Express-o
//
//  Created by user1 on 02/01/24.
//

import SwiftUI
import PencilKit

struct MandalaView: View {
    @State private var drawing = PKDrawing()


    var body: some View {
        NavigationView {
            VStack {
                // Header
                HeaderView(title: "Mandala Art", titleSize: 35, subTitle: "", alignLeft: true, height: 245, subMessage: true, subMessageWidth: 233, subMessageText: "Mandala Name...")
                    .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                    .background(Color.white)

                Spacer()
                // Mandala
               
                Image("Mandala_Art")
                  
                

                BottomNavBarView()
            }
            .edgesIgnoringSafeArea(.bottom)            
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}




#if DEBUG
struct MandalaView_Previews: PreviewProvider {
    static var previews: some View {
        MandalaView()
    }
}
#endif
