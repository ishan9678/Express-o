import SwiftUI

struct ArtJournalView1: View {
    var body: some View {
        VStack {
            Text("TEMPLATES")
                .font(.title)
                .fontWeight(.bold)
            ZStack {
                // Text just above the ScrollView
                Text("Templates")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 30) // Adjusted the top padding to make room for the text
                    .padding(.bottom, 65)
                    .overlay(
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                NavigationLink {
                                    ArtJournalUntitled()
                                } label: {
                                    Image("ArtJournalLeftpng")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 400)
                                    
                                }
                                
                                
                                Image("ArtJournalmain")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 500, height: 400)
                                
                                Image("ArtJournalright")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 500, height: 400)
                            }
                            .padding(10)
                        }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    )
            }
            
        }
        .background(Color(hex: "FEC7C0"))
                
    }
    
    struct ArtJournalView1_Previews: PreviewProvider {
        static var previews: some View {
            ArtJournalView1()
        }
    }
}

