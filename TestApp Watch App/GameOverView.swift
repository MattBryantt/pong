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
        Text("Game Over!")
            .position(x: position.x, y: position.y - 20)
            .frame(width: gameController.screenSize.width,
                   height: gameController.screenSize.height)
            .background(Color.black.opacity(0.7)) // TODO: Background not showing
        
        Button(action: {
            gameController.startGame()
            gameController.gameOver = false // Refactor
            gameController.gamePaused = false
        }) {
            Text("Play again?")
        }
        .frame(width: 175, height: 50)
        .position(x: position.x, y: position.y + 30)
    }
}

//#Preview {
//    GameOverView()
//}
