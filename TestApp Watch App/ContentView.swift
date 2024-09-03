//
//  ContentView.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 23/7/2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject var gameController = GameController()
    @State private var screenSize: CGSize = .zero
        
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background colour (enables tap gesture)
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Left Paddle
                PaddleView(color: .green)
                    .position(x: gameController.paddleOffset,
                              y: (geometry.size.height / 2) + gameController.AIamount)
                
                // Right Paddle
                PaddleView(color: .blue)
                    .position(x: geometry.size.width - gameController.paddleOffset,
                              y: (geometry.size.height / 2) + gameController.scrollAmount)
                    .focusable(true)
                    .digitalCrownRotation($gameController.scrollAmount,
                                          from: -geometry.size.height/2 + gameController.paddleHeight,
                                          through: geometry.size.height/2 - gameController.paddleHeight,
                                          by: 1.0,
                                          sensitivity: .high,
                                          isHapticFeedbackEnabled: false)
                    .disabled(gameController.gamePaused ||
                              gameController.gameLoading ||
                              gameController.gameOver)
                
                //
//                Circle()
//                    .frame(width: 2, height: 2)
//                    .foregroundColor(.yellow)
//                    .position(x: geometry.size.width - paddleOffset,
//                              y: (geometry.size.height / 2) + scrollAmount)
                //
                
                // Ball
                BallView(ballSize: gameController.ballSize, 
                         ballPosition: gameController.ballPosition,
                         ballTrail: gameController.ballTrail)
                
                // Score
                let pos1 = CGPoint(x: (geometry.size.width / 2) - 30, y: 10)
                ScoreView(score: gameController.enemyScore, color: .green, position: pos1)
                
                let pos2 = CGPoint(x: (geometry.size.width / 2) + 30, y: 10)
                ScoreView(score: gameController.playerScore, color: .blue, position: pos2)
                
                
                if (gameController.gameOver) {
                    Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
                    
                    let centrePos = CGPoint(x: (geometry.size.width / 2), y: (geometry.size.height / 2))
                    GameOverView(position: centrePos, gameController: gameController)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height / 2 - 40)
                    
                } else if (gameController.gamePaused) {
                    
                    Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
                    
                    let pos = CGPoint(x: geometry.size.width / 2,
                                       y: geometry.size.height / 2 - 20)
                    PauseView(position: pos)
//                        .background(Color.black.opacity(0.7)) // TODO: Fix background
                }
            }
            .onAppear {
                gameController.screenSize = geometry.size
                gameController.startGame()
            }
            
            .onTapGesture {
                gameController.togglePause()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ContentView()
}
