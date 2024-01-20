//
//  NovaConnectingView.swift
//  Express-o
//
//  Created by user1 on 03/01/24.
//

import SwiftUI

struct NovaConnectingView: View {
    @State private var isLoading = true
    @State private var navigateToMessageView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("nova_connecting")
                    .padding(.top, 40)
                
                Text("Nova")
                    .foregroundColor(Color(hex: "17335F"))
                    .font(.system(size: 36))
                    .bold()
                    .tracking(5)
                    .padding(.top, 10)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(width: 150, height: 43)
                    .overlay(
                        Text("Your Art Pal")
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(Color(hex: "17335F"))
                    )
                
                Text("Connect in Silence, Share in Whispers with Nova – Where Emotions and Knowledge on Art Find its Voice")
                    .frame(width: 300)
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "17335F"))
                
                if isLoading {
                    ProgressView("Connecting a person")
                        .bold()
                        .padding(.top, 40)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(CGSize(width: 2, height: 2))
                        .onAppear {
                            // Simulate loading for 5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                isLoading = false
                                navigateToMessageView = true
                            }
                        }
                }
                
                Spacer()
                BottomNavBarView()
                
                // Proper placement of NavigationLink
                NavigationLink(destination: MessageView(viewModel: ChatViewModel()), isActive: $navigateToMessageView) {
                    EmptyView()
                }
                .hidden()
            }
            .background(Color(hex: "FEC7C0"))
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true) // Hide the navigation bar for this view
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

struct NovaConnectingView_Previews: PreviewProvider {
    static var previews: some View {
        NovaConnectingView()
    }
}
