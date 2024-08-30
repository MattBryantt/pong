//
//  PaddleView.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 26/8/2024.
//

import SwiftUI



struct PaddleView: View {
    
    private var paddleHeight: CGFloat = 25
    private var paddleWidth: CGFloat = 5
    
    let color: Color
    
    init(color: Color) {
        self.color = color
    }
    
    var body: some View {
            Rectangle()
                .frame(width: paddleWidth, height: paddleHeight)
                .foregroundColor(color)
        }
}

//#Preview {
//    PaddleView()
//}
