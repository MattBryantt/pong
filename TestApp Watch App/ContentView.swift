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
    @State private var gamePaused = false
    @State private var gameOver = false
    @State private var serveRight = true
    
    private var paddleHeight: CGFloat = 35
    private var paddleWidth: CGFloat = 8
    
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
                
                Circle()
                    .frame(width: ballSize, height: ballSize)
                    .foregroundColor(.red)
                    .position(x: ballPosition.x,
                              y: ballPosition.y)
                
                Text("Score: \(enemyScore) - \(playerScore)")
                    .position(x: geometry.size.width / 2,
                              y: 0)
                
                if (gameOver) {
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
                if (!gamePaused) { // TODO: Fix pause bug
                    gamePaused = true
                    timer?.invalidate()
                } else {
                    gamePaused = false
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in // TODO: Create countdown timer for un-pause
                        startTimer()
                    }
                }
            }
        }
    }
    
    
    func startGame() {
        ballPosition = CGPoint(x: screenSize.width / 2,
                               y: screenSize.height / 2)
        enemyScore = 0
        playerScore = 0
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            updateBallPosition()
            updateAIPosition()
        }
    }
    
    func resetBall() {
        ballPosition = CGPoint(x: screenSize.width / 2,
                               y: screenSize.height / 2)
        
        if (serveRight) {
            ballVelocity = CGPoint(x: -1.5, y: -1.5)
        } else {
            ballVelocity = CGPoint(x: 1.5, y: 1.5)
        }
        
        // Pauses game before restart
        timer?.invalidate()
        
        // Check if game over
        if (playerScore >= 6 || enemyScore >= 6) { // TODO: Score bug?
            print(enemyScore)
            gamePaused = true
            gameOver = true
        } else {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                startTimer()
            }
        }
    }
    

    func updateBallPosition() {
        ballPosition.x += ballVelocity.x
        ballPosition.y += ballVelocity.y

        // Bounce off bottom & top
        if ballPosition.y <= 25 || ballPosition.y >= screenSize.height {
            ballVelocity.y = -ballVelocity.y
        }
        
        
        // Bounce off right
        if ballVelocity.x >= 0 &&
            ballPosition.x >= screenSize.width - (paddleOffset + paddleWidth*1.5) &&
            ballPosition.x <= screenSize.width - (paddleOffset + paddleWidth) {

            if abs(ballPosition.y - ((screenSize.height / 2) + scrollAmount)) < paddleHeight*0.7 {
                ballVelocity.x = -ballVelocity.x
            }
        }
        
        // Bounce off left
        if ballVelocity.x <= 0 &&
            ballPosition.x <= (paddleOffset + paddleWidth*1.5) &&
            ballPosition.x >= (paddleOffset + paddleWidth) {

            if abs(ballPosition.y - ((screenSize.height / 2) + AIamount)) < paddleHeight*0.7 {
                ballVelocity.x = -ballVelocity.x
            }
        }
        
        // Ball hits left
        if ballPosition.x >= screenSize.width {
            resetBall()
            enemyScore += 1
            serveRight = false
            // Increase velocity
        }
        
        // Ball hits right
        if ballPosition.x <= 0 {
            resetBall()
            playerScore += 1
            serveRight = true
        }
    }
    
    func updateAIPosition() {
        AIamount = ballPosition.x - (screenSize.height / 2) // TODO: Change enemy paddle positioning
    }
}

#Preview {
    ContentView()
}
