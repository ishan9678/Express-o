////
////  SketchingView.swift
////  Express-o
////
////  Created by user1 on 02/01/24.
////
//
//import SwiftUI
//
//
//struct SketchingView: View {
////    @State private var drawings: [Drawing] = []
//    @State private var currentDrawing: Drawing = Drawing(color: .black, size: 5)
//    @State private var isDrawing: Bool = false
//    @State private var showBrushOptions: Bool = false
//    @State private var selectedBrushSize: Double = 5
//    @State private var sketchName: String = ""
//
//
//    var body: some View {
//        VStack {
//            // Header
//            HeaderView(title: "Sketching", titleSize: 35, subTitle: "", alignLeft: true, height: 245, subMessage: true,subMessageWidth: 233, subMessageText: "Sketch Name...")
//                .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
//                .background(Color.white)
//                .padding(.bottom, 40)
//
//            // Drawing Canvas
//            Canvas { context, size in
//                for drawing in drawings {
//                    context.stroke(drawing.path, with: .color(drawing.color), lineWidth: CGFloat(drawing.size))
//                }
//                
//                
//
//                context.stroke(currentDrawing.path, with: .color(currentDrawing.color), lineWidth: CGFloat(currentDrawing.size))
//            }
//            .gesture(
//                DragGesture(minimumDistance: 0)
//                    .onChanged { value in
//                        let location = value.location
//                        currentDrawing.path.addLine(to: location)
//                        isDrawing = true
//                    }
//                    .onEnded { _ in
//                        if isDrawing {
//                            drawings.append(currentDrawing)
//                            currentDrawing = Drawing(color: currentDrawing.color, size: selectedBrushSize)
//                            isDrawing = false
//                        }
//                    }
//            )
//            
//            Spacer()
//            
//            // Controls
//            HStack {
//                
//                //color picker
//                ColorPicker("", selection: $currentDrawing.color)
//                    
//
//                
//                // Brush icon button
//                Button(action: {
//                    showBrushOptions.toggle()
//                }) {
//                    Image(systemName: "pencil")
//                        .font(.system(size: 40))
//                        .padding(.leading,10)
//                }
//                
//                .overlay(
//                    VStack {
//                        if showBrushOptions {
//                            Slider(value: $selectedBrushSize, in: 1...20, step: 1)
//                                .padding(.horizontal)
//                                .frame(width: 100)
//                                .background(Color.white)
//                                .cornerRadius(5)
//                                .shadow(radius: 5)
//                                .onTapGesture {
//                                    currentDrawing.size = selectedBrushSize
//                                    showBrushOptions.toggle()
//                                }
//                        }
//                    }
//                    .padding(.top, -50)
//                    .padding(.horizontal, -20)
//                )
//                
//                // Pencil and Eraser buttons
//                Button(action: {
//                    currentDrawing.color = .black
//                    currentDrawing.size = selectedBrushSize
//                }) {
//                    Image(systemName: "pencil")
//                        .font(.system(size: 40))
//                }
//
//                Button(action: {
//                    currentDrawing.color = .white // Set color to white for eraser
//                    currentDrawing.size = 20
//                }) {
//                    Image(systemName: "eraser")
//                        .font(.system(size: 40))
//                }
//
//                Button("Clear") {
//                    drawings.removeAll()
//                }
//                .font(.system(size: 25))
//            }
//            .padding(.trailing,65)
//            .background(Color(hex: "FEC7C0"))
//            .edgesIgnoringSafeArea(.bottom)
//           
//
//            
//
//            BottomNavBarView()
//        }
//        .edgesIgnoringSafeArea(.bottom)
//        .navigationBarHidden(true)
//    }
//}
//
//
//
//struct Drawing {
//    var color: Color
//    var size: Double
//    var path: Path
//
//    init(color: Color, size: Double) {
//        self.color = color
//        self.size = size
//        self.path = Path()
//    }
//}
//
//struct SketchingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SketchingView()
//    }
//}
//
