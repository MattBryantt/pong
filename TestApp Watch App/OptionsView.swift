//
//  OptionsView.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 21/9/2024.
//

import SwiftUI

struct OptionsView: View {
    
    @EnvironmentObject var gameController: GameController
    
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            
            Button(action: {
                gameController.difficulty = .easy
            }) {
                Text("Easy")
                    .font(.headline)
            }
            
            Button(action: {
                gameController.difficulty = .medium
            }) {
                Text("Medium")
                    .font(.headline)
            }
            
            Button(action: {
                gameController.difficulty = .hard
            }) {
                Text("Hard")
                    .font(.headline)
            }
        }
    }
}

//#Preview {
//    OptionsView()
//}
