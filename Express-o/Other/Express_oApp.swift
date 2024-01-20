//
//  Express_oApp.swift
//  Express-o
//
//  Created by user1 on 28/12/23.
//
import FirebaseCore
import SwiftUI

@main
struct Express_oApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                LoadingScreenView()
            }
        }
    }
}
