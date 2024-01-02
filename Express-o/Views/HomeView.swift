//
//  HomeView.swift
//  Express-o
//
//  Created by user1 on 31/12/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 0) {
                // Header
                HeaderView(title: "Hey, Oliver", subTitle: "", alignLeft: true, height: 170, subMessage: false, subMessageWidth: 0 ,subMessageText: "")
                    .frame(maxWidth: .infinity, maxHeight: 80, alignment: .topLeading)
                    .background(Color.white)
                
                // Navbar
                CustomNavBar()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .padding(.bottom, 10)

                // Posts
                PostGridView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Bottom navbar
                NavigationLink(destination: HomeView()) {
                    BottomNavBarView()
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarHidden(true)
                        .toolbar(.hidden)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

