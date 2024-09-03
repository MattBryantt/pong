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
        TextView(text: "Paused", font: .title3, colour: .red, position: position)
    }
}

//#Preview {
//    PauseView()
//}
