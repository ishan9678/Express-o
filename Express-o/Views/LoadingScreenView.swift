import SwiftUI

struct LoadingScreenView: View {
    @State private var isLoading = true
    @State private var navigateToOnboardingView = false
    
    var body: some View {
        NavigationStack{
            VStack {
                // Header
                HeaderView(title: "Express-o", titleSize: 55, subTitle: "", alignLeft: false, height: 245, subMessage: false, subMessageWidth: 283, subMessageText: "")
                    .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                    .background(Color.white)
                    .padding(.bottom, 30)
                    .padding(.top, 40)
                
                // Logo
                Image("AppLogo")
                    .padding(.bottom, 50)
                
                // Tagline
                Text("Express Your Inner Canvas: Where Art Meets Emotion")
                    .foregroundStyle(Color(hex: "17335F"))
                    .frame(width: 400)
                    .font(.system(size: 36))
                    .bold()
                    .multilineTextAlignment(.center)
                
                if isLoading {
                    ProgressView()
                        .bold()
                        .padding(.top, 40)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "17335F")))
                        .scaleEffect(CGSize(width: 4, height: 4))
                }
                
                Spacer()
                
                
                
                NavigationLink(destination: CheckingViews(), isActive: $navigateToOnboardingView) {
                    EmptyView()
                }
                .hidden()
                
            }
            .background(Color(hex: "FEC7C0"))
            .onAppear {
                // Simulate loading for 5 seconds
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    isLoading = false
                    navigateToOnboardingView = true
                }
            }
        }
    }
}


struct LoadingScreenView_Previews: PreviewProvider {
    static var previews: some View {
            LoadingScreenView()
        
    }
}

