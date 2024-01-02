//
//  RegisterViewModel.swift
//  Express-o
//
//  Created by user1 on 29/12/23.
//
import FirebaseFirestore
import FirebaseAuth
import Foundation

class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init(){}
    
    
    func register(){
        print("Attempting registration...")
        guard validate() else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Registration failed with error: \(error.localizedDescription)")
                // Handle the error, update errorMessage, etc.
            } else {
                guard let userID = result?.user.uid else {
                    print("Failed to get user ID")
                    return
                }
                self?.insertUserRecord(id: userID)
            }
        }
    }
    
    private func insertUserRecord(id: String){
        
        print("Inserting user record for ID: \(id)")
        
        let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    
    private func validate() -> Bool {
        
        errorMessage = ""
        
        print("Attempting Validation")
        
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else{
            
            errorMessage = "Please fill all fields"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Enter a valid email"
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password should be atleast 6 characters"
            return false
        }
        
        return true
    }
}

