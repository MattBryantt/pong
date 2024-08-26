//
//  ContentView.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 23/7/2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var ballPosition = CGPoint(x: 0, y: 0)
    @State private var ballVelocity = CGPoint(x: 1.5, y: 1.5)
    @State private var screenSize: CGSize = .zero
    @State private var scrollAmount = 0.0
    @State private var AIamount = 0.0
    
    @State private var timer: Timer? = nil
    
    // Game States
    @State private var gamePaused = false
    @State private var gameLoading = false
    @State private var gameOver = false
    @State private var serveRight = true
    
    private var paddleHeight: CGFloat = 25
    private var paddleWidth: CGFloat = 8
    
    // Width from edge of screen
    private var paddleOffset: CGFloat = 20

    private var ballSize: CGFloat = 15
    
    @State private var playerScore = 0
    @State private var enemyScore = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background colour (enables tap gesture)
                Color.black.edgesIgnoringSafeArea(.all)
                
                Rectangle()
                    .frame(width: paddleWidth, height: paddleHeight) // TODO: Fix doubled code
                    .foregroundColor(.green)
                    .position(x: paddleOffset,
                              y: (geometry.size.height / 2) + AIamount)
                
                Rectangle()
                    .frame(width: paddleWidth, height: paddleHeight)
                    .foregroundColor(.blue)
                    .position(x: geometry.size.width - paddleOffset,
                              y: (geometry.size.height / 2) + scrollAmount)
                    .focusable(true)
                    .digitalCrownRotation($scrollAmount,
                                          from: -screenSize.height + paddleHeight*1.8,
                                          through: screenSize.height - paddleHeight*1.4,
                                          by: 1.0,
                                          sensitivity: .low,
                                          isHapticFeedbackEnabled: false)
                        .disabled(gamePaused)
                
                //
//                Circle()
//                    .frame(width: 2, height: 2)
//                    .foregroundColor(.yellow)
//                    .position(x: geometry.size.width - paddleOffset,
//                              y: (geometry.size.height / 2) + scrollAmount)
                //
                
                Rectangle()
                    .frame(width: ballSize, height: ballSize)
                    .foregroundColor(.red)
                    .position(x: ballPosition.x,
                              y: ballPosition.y)
                
                Text("Score: \(enemyScore) - \(playerScore)")
                    .position(x: geometry.size.width / 2,
                              y: 0)
                
                if (gameOver) { // TODO: Refactor
                    Text("Game Over!")
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height / 2 - 40)
                        .background(Color.black.opacity(0.7))
                    
                    Button(action: {
                        startGame()
                        gameOver = false
                        gamePaused = false
                        print("Restart")
                    }) {
                        Text("Play again?")
                    }
                    .frame(width: 175, height: 50)
                    .position(x: geometry.size.width / 2,
                              y: geometry.size.height / 2 + 20)
                } else if (gamePaused) {
                    Text("Paused")
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height / 2 - 20)
                        .background(Color.black.opacity(0.7))
                }
            }
            
            .onAppear {
                screenSize = geometry.size
                startGame()
            }
            
            .onTapGesture {
                togglePause()
            }
        }
    }
    
    
    /*
     Controls pause mechanism depending on current gameState.
     */
    func togglePause() {
        if (!gameLoading) {
            if (gamePaused) {
                gamePaused = false
                gameLoading = true
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    startTimer()
                    gameLoading = false
                }
        
            } else {
                gamePaused = true
                timer?.invalidate()
            }
        }
    }
    
    /*
     Initialises game functionality.
     */
    func startGame() { // TODO: Add pause to start
        ballPosition = CGPoint(x: screenSize.width / 2,
                               y: screenSize.height / 2)
        ballVelocity = CGPoint(x: 1.5, y: 1.5)
        enemyScore = 0
        playerScore = 0
        startTimer()
    }
    
    /*
     Initialises game loop.
     */
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            updateBallPosition()
            updateAIPosition()
        }
    }
    
    func resetBall() {
        ballPosition = CGPoint(x: screenSize.width / 2,
                               y: screenSize.height / 2)
        
        // increaseVelocity()
        
        if (serveRight) {
            ballVelocity = CGPoint(x: -1.5, y: -1.5)
        } else {
            ballVelocity = CGPoint(x: 1.5, y: 1.5)
        }
        
        // Pauses game before restart
        timer?.invalidate()
        
        // Check if game over
        if (playerScore >= 7 || enemyScore >= 7) {
            gameLoading = false
            gamePaused = true
            gameOver = true
        } else {
            gameLoading = true
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                startTimer()
                gameLoading = false
            }
        }
    }
    
    /*
     Repeatedly updates ball position within game loop.
     */
    func updateBallPosition() {
        ballPosition.x += ballVelocity.x
        ballPosition.y += ballVelocity.y

        // Bounce off bottom & top
        if ballPosition.y <= 25 || ballPosition.y >= screenSize.height {
            ballVelocity.y = -ballVelocity.y
        }
        
        
        // Bounce off right paddle
        if ballVelocity.x >= 0 &&
            ballPosition.x >= screenSize.width - (paddleOffset + paddleWidth/2 + ballSize/2) && // TODO: Fix collision bug
            ballPosition.x <= screenSize.width - (paddleOffset - paddleWidth/2 + ballSize/2) {

            if abs(ballPosition.y - ((screenSize.height / 2) + scrollAmount)) < paddleHeight/2 + ballSize/2 {
                let totalVelocity = sqrt(pow(ballVelocity.x, 2) + pow(ballVelocity.y, 2))
                let angle = Double.random(in: 0.5...1)
                ballVelocity.x = -totalVelocity * cos(angle)
                ballVelocity.y = totalVelocity * sin(angle)
            }
        }
        
        // Bounce off left paddle
        if ballVelocity.x <= 0 &&
            ballPosition.x <= (paddleOffset + paddleWidth/2 + ballSize/2) &&
            ballPosition.x >= (paddleOffset - paddleWidth + ballSize/2) {

            if abs(ballPosition.y - ((screenSize.height / 2) + AIamount)) < paddleHeight/2 + ballSize/2 {
                let totalVelocity = sqrt(pow(ballVelocity.x, 2) + pow(ballVelocity.y, 2))
                let angle = Double.random(in: 3.5...4)
                ballVelocity.x = -totalVelocity * cos(angle)
                ballVelocity.y = totalVelocity * sin(angle)
            }
        }
        
        // Ball scores left
        if ballPosition.x >= screenSize.width {
            enemyScore += 1
            serveRight = false
            resetBall()
            // TODO: Increase velocity
        }
        
        // Ball scores right
        if ballPosition.x <= 0 {
            playerScore += 1
            serveRight = true
            resetBall()
        }
    }
    
    func updateAIPosition() {
        let offset = ballPosition.y - (screenSize.height / 2)
//        print("offset \(offset)")
//        var movement = min(abs(offset), 30)
//        if (offset < 0) {
//            movement = -movement
//        }
//        print("movement \(movement)")
        AIamount = offset*0.5
    }
}

#Preview {
    ContentView()
}
