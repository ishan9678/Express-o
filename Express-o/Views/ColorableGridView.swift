import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct IntricatePatternView: View {
    @State private var patternImage: UIImage? = UIImage(named: "Mandala_Art") // Replace with your image
    @State private var circles: [CircleData] = []

    let gridSize = 10

    var body: some View {
        VStack {
            if let patternImage = patternImage {
                Image(uiImage: patternImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(generateCircles())
            } else {
                Text("Image not found")
            }
        }
        .onAppear {
            generateIntricatePattern()
        }
    }

    private func generateIntricatePattern() {
        guard let inputImage = CIImage(image: patternImage ?? UIImage()) else { return }

        let filter = CIFilter(name: "CIRadialGradient")!
              filter.setValue(CIVector(x: inputImage.extent.midX, y: inputImage.extent.midY), forKey: "inputCenter")
              filter.setValue(150, forKey: "inputRadius0")
              filter.setValue(160, forKey: "inputRadius1")
              filter.setValue(CIColor(red: 1, green: 0, blue: 0), forKey: "inputColor0")
              filter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor1")

        if let outputImage = filter.outputImage {
            let context = CIContext()
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
            patternImage = UIImage(cgImage: cgImage!)
            generateCircleData()
        }
    }

    private func generateCircleData() {
        // Implement logic to generate circles based on the pattern
        // This can involve analyzing pixel data or other image processing techniques
        // For simplicity, we'll generate random circles for demonstration purposes
        for _ in 0..<gridSize {
            let circle = CircleData(
                position: CGPoint(x: CGFloat.random(in: 0...300), y: CGFloat.random(in: 0...300)),
                radius: CGFloat.random(in: 5...20),
                color: Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
            )
            circles.append(circle)
        }
    }

    private func generateCircles() -> some View {
        return ZStack {
            ForEach(circles, id: \.id) { circleData in
                Circle()
                    .foregroundColor(circleData.color)
                    .frame(width: circleData.radius * 2, height: circleData.radius * 2)
                    .position(circleData.position)
            }
        }
    }
}

struct IntricatePatternView_Previews: PreviewProvider {
    static var previews: some View {
        IntricatePatternView()
    }
}

struct CircleData: Identifiable {
    let id = UUID()
    let position: CGPoint
    let radius: CGFloat
    let color: Color
}

extension CIFilter {
    static func radialGradient() -> CIFilter {
        return CIFilter(name: "CIRadialGradient")!
    }
}

