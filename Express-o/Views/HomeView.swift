//
//  HomeView.swift
//  Express-o
//
//  Created by user1 on 31/12/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore



struct HomeView: View {
    @State private var isPostDetailViewPresented = false
    @State private var selectedPost: Post?
    
    @State private var userName = ""

    
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 0) {
                // Header
                HeaderView(title: "Hey, Oliver", titleSize: 35, subTitle: "", alignLeft: true, height: 170, subMessage: false, subMessageWidth: 0, subMessageText: "")
                    .frame(maxWidth: .infinity, maxHeight: 80, alignment: .topLeading)
                    .background(Color.white)
                
                // Navbar
                CustomNavBar()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .padding(.bottom, 10)

                // Posts
                PostGridView(postSelection: $selectedPost)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        isPostDetailViewPresented.toggle()
                        print("onnn")
                    }
                
                // Bottom navbar
               //BottomNavBarView()
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarHidden(true)
                        .toolbar(.hidden)
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .sheet(isPresented: $isPostDetailViewPresented) {
                if let post = selectedPost {
                    PostDetailView(post: post)
                }
            }
           
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

