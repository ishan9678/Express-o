//
//  LoginView.swift
//  Express-o
//
//  Created by user1 on 29/12/23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var ViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                //Header
                HeaderView(title: "Express-o", titleSize: 35, subTitle: "Welcome Back", alignLeft: false, height: 210,subMessage: false, subMessageWidth: 0, subMessageText: "")
                
                //Image
                VStack{
                    Image("LoginImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .padding(.top, -100)
                }
                
                NavigationLink(
                                    destination: TabViewHomeView(),
                                    isActive: $ViewModel.isLoggedIn,
                                    label: { EmptyView() }
                                )
                                .hidden()
                
                //Login Form
                Form{
                    
                    if !ViewModel.errorMessage.isEmpty{
                        Text(ViewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                    
                    TextField("Login", text: $ViewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $ViewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom,5)
                    
                    ButtonView(title: "Log In"){
                        ViewModel.login()
                    }
                    
                }
                .scrollContentBackground(.hidden)
                
                
                //Create Account
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(hex: "FEC7C0"))
                    
                    VStack{
                        Text("New around here?")
                            .foregroundColor(Color(hex: "17335F"))
                        NavigationLink("Create An Account", destination: RegisterView())
                    }
                    .padding(.bottom,40)
                    .padding(.top,20)
                }
                .frame(width: UIScreen.main.bounds.width * 3, height: 100)
                .offset(y:50)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
