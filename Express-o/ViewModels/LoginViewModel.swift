//
//  LoginViewModel.swift
//  Express-o
//
//  Created by user1 on 29/12/23.
//
import FirebaseAuth
import Foundation

class LoginViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init(){}
        func login(){
            
            guard validate() else {
                return
            }
            
            // try to login
            Auth.auth().signIn(withEmail: email, password: password)
            
        }
        
        private func validate() -> Bool{
            errorMessage = ""
            
            guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
                  !password.trimmingCharacters(in: .whitespaces).isEmpty else{
                
                errorMessage = "Please fill in all the fields"
                
                return false
            }
            
            guard email.contains("@") && email.contains(".") else{
                errorMessage = "Enter a valid email"
                return false
            }
            
            return true
        }
    
}
