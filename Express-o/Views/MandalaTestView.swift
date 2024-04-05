//
//  MandalaTestView.swift
//  Express-o
//
//  Created by user1 on 22/02/24.
//

import SwiftUI

struct RandomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Define the number of points for the shape
        let numberOfPoints = Int.random(in: 3...8)
        let width = rect.width
        let height = rect.height

        // Generate random points
        var points: [CGPoint] = []
        for _ in 0..<numberOfPoints {
            let point = CGPoint(x: CGFloat.random(in: 0...width), y: CGFloat.random(in: 0...height))
            points.append(point)
        }

        // Sort points by x-coordinate
        let sortedPoints = points.sorted(by: { $0.x < $1.x })

        // Move to the first point
        path.move(to: sortedPoints.first!)

        // Add lines to the rest of the points
        for point in sortedPoints.dropFirst() {
            path.addLine(to: point)
        }

        // Close the path
        path.closeSubpath()

        return path
    }
}

struct MandalaTestView: View {
    var body: some View {
        ZStack {
            RandomShape()
                .fill(Color.red)
                .overlay(
                    RandomShape()
                        .stroke(Color.black, lineWidth: 2)
                )
                .frame(width: 204, height: 188)
            
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 180, height: 50)
                .overlay{
                    Text("HI this is me")
                        .foregroundColor(.black)
                }
                .padding(.top,300)
                .foregroundColor(Color(hex: "#e6dab1"))
                
        }
    }
}

struct MandalaTestView_Previews: PreviewProvider {
    static var previews: some View {
        MandalaTestView()
    }
}

