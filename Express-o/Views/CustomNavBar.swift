//
//  CustomNavBar.swift
//  Express-o
//
//  Created by user1 on 30/12/23.
//

import SwiftUI

struct CustomNavBar: View {
    @State private var selectedOption: String = "All"
    @State private var optionWidths: [String: CGFloat] = [:]
    
    var body: some View {
        ZStack{
            HStack(spacing: 20) {
                ForEach(["All", "Art Journal", "Mandala", "Sketch"], id: \.self) { option in
                    Text(option)
                        .font(.headline)
                        .foregroundColor(selectedOption == option ? Color.blue : Color(hex: "17335F"))
                        .onTapGesture {
                            withAnimation {
                                selectedOption = option
                            }
                        }
                        .background(GeometryReader { geometry in
                            Color.clear
                                .preference(key: OptionWidthKey.self, value: [option: geometry.size.width])
                        })
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding()
            .background(Color.white)
            .overlayPreferenceValue(OptionWidthKey.self) { preferences in
                GeometryReader { geometry in
                    let selectedWidth = preferences[selectedOption] ?? 0
                    let offset = preferences
                        .filter { $0.key < selectedOption }
                        .reduce(CGFloat(0)) { $0 + $1.value + 20 } // 20 is the spacing between buttons
                    
                    // Adjustments for fine-tuning
                    let lineWidth = selectedWidth * 0.92 // Adjust the multiplier to control line width
                    let alignmentOffset = (selectedWidth - lineWidth) / 2 // Adjust the alignment offset
                    
                    Rectangle()
                        .frame(width: lineWidth, height: 2)
                        .foregroundColor(Color.blue)
                        .offset(x: offset + alignmentOffset + 67)
                }
                .offset(y:40)
            }
        }
    }
}

struct OptionWidthKey: PreferenceKey {
    static var defaultValue: [String: CGFloat] = [:]

    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: max)
    }
}

struct CustomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBar()
    }
}
