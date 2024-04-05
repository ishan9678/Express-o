//
//  PagesView.swift
//  Express-o
//
//  Created by ishan on 26/03/24.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct PagesView: View {
    @State private var currentPageIndex = 0
    @State private var artJournalPages: [[String: Any]] = []
    @State private var navigateToJournal = false
    
    private func fetchArtJournalPages() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("art-journal").document(userId)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error.localizedDescription)")
                return
            }
            
            guard let data = document?.data(),
                  let artJournalEntries = data["artJournalEntries"] as? [String: [String: Any]] else {
                print("No art journal entries found.")
                return
            }
            
            let sortedEntries = artJournalEntries.values.sorted(by: { ($0["pageNo"] as? Int ?? 0) < ($1["pageNo"] as? Int ?? 0) })
            
            self.artJournalPages = sortedEntries
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack {
                if let backgroundImage = UIImage(named: "background") {
                    Image(uiImage: backgroundImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        NavigationLink(destination: Journal(pageNo: artJournalPages.count + 1)) {
                             VStack {
                                 Image(systemName: "plus.circle.fill")
                                     .resizable()
                                     .aspectRatio(contentMode: .fill)
                                     .frame(width: 100, height: 100)
                                 Text("New Page")
                                .foregroundColor(Color(hex: "17335F"))
                                .bold()
                                .font(.system(size: 24))
                                }
                             .padding(.trailing, 50)
                             .padding(.leading, 100)
                            }
                        ForEach(0..<artJournalPages.count, id: \.self) { index in
                            VStack {
                                if let imageURL = artJournalPages[index]["imageURL"] as? String,
                                   let url = URL(string: imageURL) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.8)
                                                .padding()
                                                .scrollTransition { content, phase in
                                                    content
                                                        .opacity(phase.isIdentity ? 1.0 : 0.2)
                                                        .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
                                                        .offset(y: phase.isIdentity ? 0 : 50)
                                                }
                                        case .failure:
                                            Text("Failed to load image")
                                        @unknown default:
                                            Text("Unknown error")
                                        }
                                    }
                                } else {
                                    Text("Image URL not found")
                                }
                                
                                Text("\(artJournalPages[index]["pageNo"] as? Int ?? 0)")
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                    .padding(.top, 5)
                                    .offset(y: -120)
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }
                
                Text("Your Entries")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black.opacity(0.7))
                    .offset(y: -450)
            }
            .onAppear {
                fetchArtJournalPages()
            }
        }
    }
}


struct PagesView_Previews: PreviewProvider {
    static var previews: some View {
        PagesView()
    }
}


