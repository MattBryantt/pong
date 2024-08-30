//
//  ScoreView.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 30/8/2024.
//

import SwiftUI

struct ScoreView: View {
    
    let score: Int
    let color: Color
    let position: CGPoint
    
    init(score: Int, color: Color, position: CGPoint) {
        self.score = score
        self.color = color
        self.position = position
    }
    
    var body: some View {
        Text("\(score)")
            .bold()
            .font(.title2)
            .foregroundStyle(color)
            .position(x: position.x + 2,
                      y: position.y + 1.5)
        
        Text("\(score)")
            .bold()
            .font(.title2)
            .foregroundStyle(.white)
            .position(position)
    }
}

//#Preview {
//    ScoreView()
//}
