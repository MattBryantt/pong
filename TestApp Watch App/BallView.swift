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
    let ballTrail: [CGPoint]
    
    init(ballSize: CGFloat, ballPosition: CGPoint, ballTrail: [CGPoint]) {
        self.ballSize = ballSize
        self.ballPosition = ballPosition
        self.ballTrail = ballTrail
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: ballSize, height: ballSize)
                .foregroundColor(.red)
                .position(x: ballPosition.x,
                          y: ballPosition.y)
            
            ForEach(ballTrail.indices, id: \.self) { index in                
                Rectangle()
                    .frame(width: ballSize, height: ballSize)
                    .foregroundColor(.red)
                    .opacity(0.3 - Double(index/30))
                    .position(x: ballTrail[index].x,
                              y: ballTrail[index].y)
            }
        }
    }
}

//#Preview {
//    BallView()
//}
