import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct ProfileView: View {
    @State private var selectedTab: Tab = .pins
    
    enum Tab {
        case pins, creations
    }
    
    let posts: [Pins]
    let creations: [ArtJournalPost]
    
    init(posts: [Pins], creations: [ArtJournalPost]) {
        self.posts = posts
        self.creations = creations
    }
    
    @State private var isShowingLogin = false
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isShowingLogin = true
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }


    
    var body: some View {
        NavigationView{
            VStack {
                // Header
                ZStack {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 350)
                        .foregroundColor(Color(hex: "FEC7C0"))
                    
                    VStack {
                        HStack {
                            Button(action: {
                                signOut()
                            }) {
                                Text("Sign Out")
                            }
                            .padding(.leading,20)
                            
                            Spacer()
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .padding(20)
                        }
                        
                        Image("profile_img")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 8))
                            .foregroundColor(.white)
                        
                        Text("Oliver")
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "17335F"))
                            .font(.system(size: 30))
                            .padding(.top, 10)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(width: 295, height: 43)
                            .overlay(
                                Text("Art is the most beautiful of all lies")
                                    .font(.system(size: 18))
                                    .bold()
                                    .foregroundColor(Color(hex: "17335F"))
                            )
                        
                    }
                }
                
                // Buttons
                HStack {
                    Button(action: {
                        selectedTab = .pins
                        
                    }) {
                        Text("Pins")
                            .foregroundStyle(Color(hex: "17335F"))
                            .bold()
                            .font(.system(size: 20))
                    }
                    .frame(width: 156, height: 51)
                    .cornerRadius(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedTab == .pins ? Color(hex: "A7C3C8") : Color(hex: "D7FAFA"))
                    )
                    
                    Button(action: {
                        selectedTab = .creations
                    }) {
                        Text("Creations")
                            .bold()
                            .foregroundStyle(Color(hex: "17335F"))
                            .font(.system(size: 20))
                    }
                    .frame(width: 156, height: 51)
                    .cornerRadius(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedTab == .creations ? Color(hex: "A7C3C8") : Color(hex: "D7FAFA"))
                    )
                }
                .padding(.top, 10)
                
                if selectedTab == .pins {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 40) {
                            ForEach(posts) { post in
                                PinsView(post: post)
                            }
                        }
                        .padding(15)
                    }
                }
                if selectedTab == .creations {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 40) {
                            ForEach(creations.dropFirst()) { creation in
                                ArtJournalPostView(post: creation)
                            }
                        }
                        .padding(15)
                    }
                }
                
                NavigationLink(
                    destination: LoginView(),
                    isActive: $isShowingLogin,
                    label: { EmptyView() }
                    )
                    .hidden()
                
                Spacer()
                
                //BottomNavBarView()
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())

    }
}


#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let examplePins = Pins.examplePins
        let exampleCreations = ArtJournalPost.examplePosts
        return ProfileView(posts: examplePins, creations: exampleCreations)
    }
}
#endif

