//
//  LoginViewModel.swift
//  Express-o
//
//  Created by user1 on 29/12/23.
//
import FirebaseAuth
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoggedIn = false // Track login status

    init() {}

    func login() {
        guard validate() else {
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard error == nil else {
                // Handle login error
                self?.errorMessage = error?.localizedDescription ?? "An error occurred"
                return
            }

            // Login successful
            self?.isLoggedIn = true
        }
    }

    private func validate() -> Bool {
        errorMessage = ""

        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all the fields"
            return false
        }

        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Enter a valid email"
            return false
        }

        return true
    }
}
