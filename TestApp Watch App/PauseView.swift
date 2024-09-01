//
//  PauseView.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 1/9/2024.
//

import SwiftUI

struct PauseView: View {
    
    let position: CGPoint
    
    init(position: CGPoint) {
        self.position = position
    }
    
    var body: some View {
        Text("Paused")
            .bold()
            .font(.title3)
            .foregroundStyle(.red)
            .position(x: position.x + 2,
                      y: position.y + 1.5)
        
        Text("Paused")
            .bold()
            .font(.title3)
            .foregroundStyle(.white)
            .position(position)
    }
}

//#Preview {
//    PauseView()
//}
