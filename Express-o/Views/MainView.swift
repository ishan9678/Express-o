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
        LoadingScreenView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
