//
//  testView.swift
//  Express-o
//
//  Created by user1 on 20/01/24.
//

import SwiftUI

struct testView: View {
    var body: some View {
        Path { path in
            let width: CGFloat = 400
            let height: CGFloat = 400
            path.move(to: CGPoint(x: 0.4988*width, y: 0))
            path.addLine(to: CGPoint(x: 0.4988*width, y: 0.49875*height))
            path.move(to: CGPoint(x: 0.36908*width, y: 0.01713*height))
            path.addLine(to: CGPoint(x: 0.49816*width, y: 0.49889*height))
            path.move(to: CGPoint(x: 0.62784*width, y: 0.01778*height))
            path.addLine(to: CGPoint(x: 0.49875*width, y: 0.49954*height))
            path.move(to: CGPoint(x: 0.85345*width, y: 0.85143*height))
            path.addLine(to: CGPoint(x: 0.50078*width, y: 0.49876*height))
            path.move(to: CGPoint(x: 0.93306*width, y: 0.7476*height))
            path.addLine(to: CGPoint(x: 0.50113*width, y: 0.49822*height))
            path.move(to: CGPoint(x: 0.74963*width, y: 0.93011*height))
            path.addLine(to: CGPoint(x: 0.50025*width, y: 0.49818*height))
            path.move(to: CGPoint(x: 0.85393*width, y: 0.14409*height))
            path.addLine(to: CGPoint(x: 0.50126*width, y: 0.49677*height))
            path.move(to: CGPoint(x: 0.75009*width, y: 0.06448*height))
            path.addLine(to: CGPoint(x: 0.50071*width, y: 0.49642*height))
            path.move(to: CGPoint(x: 0.93261*width, y: 0.24791*height))
            path.addLine(to: CGPoint(x: 0.50067*width, y: 0.49729*height))
            path.move(to: CGPoint(x: 0, y: 0.49812*height))
            path.addLine(to: CGPoint(x: 0.49875*width, y: 0.49812*height))
            path.move(to: CGPoint(x: 0.01713*width, y: 0.62784*height))
            path.addLine(to: CGPoint(x: 0.49889*width, y: 0.49875*height))
            path.move(to: CGPoint(x: 0.01778*width, y: 0.36908*height))
            path.addLine(to: CGPoint(x: 0.49954*width, y: 0.49816*height))
            path.move(to: CGPoint(x: 0.99829*width, y: 0.4988*height))
            path.addLine(to: CGPoint(x: 0.49954*width, y: 0.4988*height))
            path.move(to: CGPoint(x: 0.98116*width, y: 0.36908*height))
            path.addLine(to: CGPoint(x: 0.4994*width, y: 0.49816*height))
            path.move(to: CGPoint(x: 0.98051*width, y: 0.62784*height))
            path.addLine(to: CGPoint(x: 0.49875*width, y: 0.49875*height))
            path.move(to: CGPoint(x: 0.14659*width, y: 0.14362*height))
            path.addLine(to: CGPoint(x: 0.49926*width, y: 0.49629*height))
            path.move(to: CGPoint(x: 0.06698*width, y: 0.24746*height))
            path.addLine(to: CGPoint(x: 0.49891*width, y: 0.49683*height))
            path.move(to: CGPoint(x: 0.25041*width, y: 0.06494*height))
            path.addLine(to: CGPoint(x: 0.49978*width, y: 0.49687*height))
            path.move(to: CGPoint(x: 0.14611*width, y: 0.85096*height))
            path.addLine(to: CGPoint(x: 0.49878*width, y: 0.49829*height))
            path.move(to: CGPoint(x: 0.24995*width, y: 0.93057*height))
            path.addLine(to: CGPoint(x: 0.49933*width, y: 0.49864*height))
            path.move(to: CGPoint(x: 0.06743*width, y: 0.74714*height))
            path.addLine(to: CGPoint(x: 0.49937*width, y: 0.49776*height))
            path.move(to: CGPoint(x: 0.49812*width, y: 0.99829*height))
            path.addLine(to: CGPoint(x: 0.49812*width, y: 0.49954*height))
            path.move(to: CGPoint(x: 0.62784*width, y: 0.98116*height))
            path.addLine(to: CGPoint(x: 0.49875*width, y: 0.4994*height))
            path.move(to: CGPoint(x: 0.36908*width, y: 0.98051*height))
            path.addLine(to: CGPoint(x: 0.49816*width, y: 0.49875*height))
            }
            .stroke(Color.black, lineWidth: 2)
            .frame(width: 400, height: 400)
            
    }
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
    }
}
