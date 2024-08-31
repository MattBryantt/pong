//
//  BallView.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 30/8/2024.
//

import SwiftUI

struct BallView: View {
    
    let ballSize: CGFloat
    let ballPosition: CGPoint
    
    init(ballSize: CGFloat, ballPosition: CGPoint) {
        self.ballSize = ballSize
        self.ballPosition = ballPosition
    }
    
    var body: some View {
        Rectangle()
            .frame(width: ballSize, height: ballSize)
            .foregroundColor(.red)
            .position(x: ballPosition.x,
                      y: ballPosition.y)
    }
}

//#Preview {
//    BallView()
//}
