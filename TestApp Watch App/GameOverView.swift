//
//  GameOverView.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 30/8/2024.
//

import SwiftUI

struct GameOverView: View {
    
    @ObservedObject var gameController: GameController
       
    let position: CGPoint
    
    init (position: CGPoint, gameController: GameController) {
        self.position = position
        self.gameController = gameController
    }
    
    var body: some View {
        let textPos = CGPoint(x: position.x, y: position.y - 20)
        TextView(text: "Game Over!", font: .title3, colour: .red, position: textPos)

        Button(action: {
            gameController.startGame()
            gameController.gameOver = false // TODO: Refactor
            gameController.gamePaused = false
        }) {
            Text("Play again?")
                .font(.headline)
        }
        .frame(width: 175, height: 50) // TODO: Remove constant values
        .position(x: position.x, y: position.y + 30)
    }
}

//#Preview {
//    GameOverView()
//}
