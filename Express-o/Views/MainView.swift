//
//  ContentView.swift
//  Express-o
//
//  Created by user1 on 28/12/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var ViewModel = MainViewModel()
    
    var body: some View {
        if ViewModel.isSignedIn, !ViewModel.currentUserId.isEmpty {
            //Signed In
            HomeView()
        } else{
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
