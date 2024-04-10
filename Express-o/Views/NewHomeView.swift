import SwiftUI

struct NewHomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                
                HeaderView(title: "Good Morning, Oliver", titleSize: 35, subTitle: "", alignLeft: true, height: 270, subMessage: true, subMessageWidth: 223, subMessageText: "           How are you today?")
                    .frame(maxWidth: .infinity, maxHeight: 230, alignment: .topLeading)
                    .background(Color.white)
                    .padding(.top,20)
                    .padding(.bottom,50)
                
                
//                HeaderView(title: "Good Morning Oliver", titleSize: 35, subTitle: "", alignLeft: true, height: 135, subMessage: false, subMessageWidth: 233, subMessageText: "Your Sketches")
//                    .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
//                    .background(Color.white)
//                
                // Header image
//                Image("headerhome1")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .offset(y:-85)


                // Buttons
                
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)], spacing: 0) {
                    NavigationLink(destination: TabViewHomeView(selectedTab: 1)) {
                        VStack {
                            Image("sketchinghome1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 20))

                                .frame(width: 350, height: 330)
                            Text("Sketching")
                                .foregroundColor(Color(hex: "17335F"))
                                .bold()
                                .font(.system(size: 24))
                        }
                    }

                    NavigationLink(destination: TabViewHomeView(selectedTab: 2)) {
                        VStack {
                            Image("artjournalhome1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350, height: 350)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            Text("Art Journal")
                                .foregroundColor(Color(hex: "17335F"))
                                .bold()
                                .font(.system(size: 24))
                        }
                    }

                    NavigationLink(destination: TabViewHomeView(selectedTab: 3)) {
                        VStack {
                            Image("mandalahome2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350, height: 350)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.top,40)
                            Text("Mandala Art")
                                .foregroundColor(Color(hex: "17335F"))
                                .bold()
                                .font(.system(size: 24))
                        }
                    }

                    NavigationLink(destination: MandalaGenerationView(prompt: "" )) {
                        VStack {
                            Image("mandalageneratedhome1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350, height: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.top,40)
                            Text("Generate Mandala")
                                .foregroundColor(Color(hex: "17335F"))
                                .bold()
                                .font(.system(size: 24))
                        }
                    }
                }
                .offset(y:-45)
                .padding()

                Spacer()
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct NewHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NewHomeView()
    }
}

