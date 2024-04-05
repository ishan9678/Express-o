//
//  BookView.swift
//  Express-o
//
//  Created by ishan on 25/03/24.
//



import SwiftUI
import UIKit



struct BookView: View {
    let book: Book
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @State private var isNavigationActive = false
    
    var body: some View {
        NavigationStack{
            VStack {
                
                HStack(spacing: 15) {
                    Text("Choose your Art Journal")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .foregroundColor(.black.opacity(0.7))
                    Spacer()
                }
                .padding(.top, 50)
                .offset(x: orientation.isLandscape ? 430 : 250)
                .offset(y: orientation.isLandscape ? 0 : 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                GeometryReader { geometry in
                    let size = geometry.size
                    
                    let rect = geometry.frame(in: .global)
                    let minX = (rect.minX - 50) < 0 ? (rect.minX - 50) : -(rect.minX - 50)
                    let progress = (minX) / rect.width
                    let rotation = progress * 45
                    
                    ZStack {
                        IsometricView(depth: 10) {
                            Color.white
                        } bottom: {
                            Color.white
                        } side: {
                            Color.white
                        }
                        .frame(width: orientation.isLandscape ? size.width / 2.5 : size.width / 1.2,
                               height: orientation.isLandscape ? size.height  : size.height / 1.1)
                        .shadow(color: .black.opacity(0.12), radius: 5, x: 15, y: 8)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: -10, y: -8)
                        
                        Image(book.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: orientation.isLandscape ? size.width / 2.5 : size.width / 1.2,
                                   height: orientation.isLandscape ? size.height  : size.height / 1.1)
                            .clipped()
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 10, y: 8)
                            .rotation3DEffect(
                                .init(degrees: rotation), axis: (x: 0, y: 1, z: 0), anchor: .leading, perspective: 1)
                            .modifier(CustomProjection(value: 1 + (-progress < 1 ? progress : -1.0)))
                            .onTapGesture {
                                isNavigationActive = true
                            }
                    }
                    .offset(x: indexOf(book: book) > 0 ? -(progress * 45) : 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.horizontal, 50)
                .padding(.vertical, orientation.isLandscape ? 50 : 0)
            }
            .onAppear {
                UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            }
            .onDisappear {
                UIDevice.current.endGeneratingDeviceOrientationNotifications()
            }
            .background(
                OrientationObserver { newOrientation in
                    if newOrientation != self.orientation {
                        self.orientation = newOrientation
                    }
                }
            )
            .background(
                NavigationLink(destination: PagesView(), isActive: $isNavigationActive) {
                    EmptyView()
                }
            )
        }
    }
    
    struct OrientationObserver: UIViewControllerRepresentable {
        var didChange: (UIDeviceOrientation) -> Void
        
        func makeUIViewController(context: Context) -> OrientationObserverViewController {
            let viewController = OrientationObserverViewController()
            viewController.orientationDidChange = didChange
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: OrientationObserverViewController, context: Context) {}
    }
    
    class OrientationObserverViewController: UIViewController {
        var orientationDidChange: ((UIDeviceOrientation) -> Void)?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        }
        
        @objc func deviceOrientationDidChange() {
            orientationDidChange?(UIDevice.current.orientation)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}


struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookView(book: sampleBooks[0])
                .previewLayout(.fixed(width: 768, height: 1024)) // iPad landscape
                .environment(\.horizontalSizeClass, .regular)

            BookView(book: sampleBooks[0])
                .previewLayout(.fixed(width: 9, height: 1024)) // iPad portrait
                .environment(\.horizontalSizeClass, .compact)
        }
    }
}

#Preview {
    BookView(book: sampleBooks[0])
}
