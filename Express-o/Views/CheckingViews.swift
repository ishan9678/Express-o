import SwiftUI

struct CheckingViews: View {
    let heading = ["Sketch", "Mandala Art", "Art Journal"]
    let img = ["sketchOnboardingImage", "mandalaOnboardImage", "ArtJournalImage"]
    let message = [
        "Express Your Thoughts into Artful Expressions",
        "Express Serenity: Mandala Art for Mindful Creativity",
        "Express Your Journey: Journaling Redefined"
    ]

    var body: some View {
        NavigationStack {
            VStack {
               
                TabView {
                    ForEach(0..<3) { index in
                        VStack(spacing: 0) {
                            Spacer()
                            Text(heading[index])
                                .font(.system(size: 48))
                                .foregroundColor(Color(hex: "17335F"))
                                .bold()
                                .padding()

                            Image(img[index])
                                .resizable()
                                .frame(width: 650, height: .infinity)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(20)
                                .padding(.top, 20)

                            Text(message[index])
                                .foregroundColor(Color(hex: "17335F"))
                                .frame(width: 600)
                                .font(.system(size: 36))
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding(.top, 40)
                            Spacer()
                            HStack {
                                Spacer()
                                NavigationLink(destination: TabViewHomeView()) {
                                Text("Skip")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 15)
                                    .background(Color(hex: "17335F"))
                                    .cornerRadius(20)
                                    .padding(.trailing, 80)
                                }
                            }
                            .padding(.bottom, 20)
                        }
                        .padding()
                    }
                }
                .tabViewStyle(PageTabViewStyle())


                Spacer()

//
            }
            .background(Color(hex: "FEC7C0"))
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct CheckingViews_Previews: PreviewProvider {
    static var previews: some View {
        CheckingViews()
    }
}

