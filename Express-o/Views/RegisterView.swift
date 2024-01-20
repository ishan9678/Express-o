//
//  RegisterView.swift
//  Express-o
//
//  Created by user1 on 29/12/23.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var ViewModel = RegisterViewModel()
    
    var body: some View {
        
        
        VStack{
            //Header
            HeaderView(title: "Express-o", titleSize: 35, subTitle: "Get started", alignLeft: false, height: 210, subMessage: false, subMessageWidth: 0 ,subMessageText: "" )
                .offset(y:-35);
            
            //Image
            VStack{
                Image("RegisterImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
                    .padding(.top, -100)
            }
            Spacer()
            
            //Form
            
            Form{
                
                if !ViewModel.errorMessage.isEmpty{
                    Text(ViewModel.errorMessage)
                        .foregroundColor(Color.red)
                }
                
                TextField("Name", text: $ViewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                
                TextField("Email", text: $ViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                SecureField("Password", text: $ViewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom,5)
                
                ButtonView(title: "Sign up"){
                    // Attempt sign up
                    ViewModel.register()
                }
                
            }
            .scrollContentBackground(.hidden)

        }
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
