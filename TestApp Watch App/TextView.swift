//
//  TextView.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 3/9/2024.
//

import SwiftUI

struct TextView: View {
    
    let text: String
    let font: Font
    let colour: Color
    let position: CGPoint
    
    init(text: String, font: Font, colour: Color, position: CGPoint) {
        self.text = text
        self.font = font
        self.colour = colour
        self.position = position
    }
    
    var body: some View {
        Text(text)
            .bold()
            .font(font)
            .foregroundStyle(colour)
            .position(x: position.x + 2,
                      y: position.y + 1.5)
        
        Text(text)
            .bold()
            .font(font)
            .foregroundStyle(.white)
            .position(position)
    }
}

//#Preview {
//    TextView()
//}
