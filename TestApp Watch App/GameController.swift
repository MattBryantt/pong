//
//  GameController.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 30/8/2024.
//

import Foundation

class GameController: ObservableObject {
    
    @Published var ballPosition = CGPoint(x: 1, y: 1)
    @Published var ballVelocity = CGPoint(x: 2, y: 0)
    @Published var ballTrail = Array(repeating: CGPoint(x: -10, y: -10), count: 10)
    
    @Published var screenSize: CGSize = .zero
    @Published var AIamount = 0.0
    @Published var scrollAmount = 0.0
    
    // Game States
    @Published var gamePaused = false
    @Published var gameLoading = false
    @Published var gameOver = false
    @Published var serveRight = true
    
    @Published var paddleHeight: CGFloat = 25
    @Published var paddleWidth: CGFloat = 5
    
    // Width from edge of screen
    @Published var paddleOffset: CGFloat = 20

    @Published var ballSize: CGFloat = 12
    
    var timer: Timer? = nil
    
    @Published var playerScore = 0
    @Published var enemyScore = 0
    
    var AISpeed: Double = 0.5
    
    enum Difficulty {
        case easy
        case medium
        case hard
    }
    
    var difficulty: Difficulty = .easy
    
    
    /*
     Controls pause mechanism depending on current gameState.
     */
    func togglePause() {
        if (!gameLoading && !gameOver) {
            if (gamePaused) {
                gamePaused = false
                gameLoading = true
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.startTimer()
                    self.gameLoading = false
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
    func startGame() {
        scrollAmount = 0
        AIamount = 0
        ballPosition = CGPoint(x: screenSize.width / 2,
                               y: screenSize.height / 2)
        ballVelocity = CGPoint(x: 2, y: 0)
        
        enemyScore = 0
        playerScore = 0
        
        if (difficulty == .easy) {
            AISpeed = 0.5
            print("easy")
        } else if (difficulty == .medium) {
            AISpeed = 0.6
            print("medium")
        } else if (difficulty == .hard) {
            AISpeed = 0.7
            print("hard")
        }
        
        gameLoading = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.startTimer()
            self.gameLoading = false
        }
    }
    
    /*
     Initialises game loop.
     */
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.updateBallPosition()
            self.updateAIPosition()
        }
    }
    
    func resetBall() {
//        scrollAmount = 0 // TODO: Continuous scrolling bug affecting reset
        AIamount = 0
        
        ballPosition = CGPoint(x: screenSize.width / 2,
                               y: screenSize.height / 2)
        
        for index in ballTrail.indices {
            ballTrail[index] = ballPosition
        }
        
        if (serveRight) {
            ballVelocity = CGPoint(x: -2, y: 0)
        } else {
            ballVelocity = CGPoint(x: 2, y: 0)
        }
        
        // Pauses game before restart
        timer?.invalidate()
        
        // Check if game over
        if (playerScore >= 7 || enemyScore >= 7) {
            gameLoading = false // TODO: Refactor?
            gamePaused = false
            gameOver = true
        } else {
            gameLoading = true
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.startTimer()
                self.gameLoading = false
            }
        }
    }
    
    /*
     Repeatedly updates ball position within game loop.
     */
    func updateBallPosition() {
        
        let offset = ballPosition.y - (screenSize.height / 2)
        print(offset)
        
        for i in 1...ballTrail.count-1 {
            ballTrail[ballTrail.count-i] = ballTrail[ballTrail.count-i - 1]
        }
        ballTrail[0] = ballPosition
        
        ballPosition.x += ballVelocity.x
        ballPosition.y += ballVelocity.y

        // Bounce off bottom & top
        if ballPosition.y <= ballSize/2 ||
            ballPosition.y >= screenSize.height - ballSize/2 {
            
            ballVelocity.y = -ballVelocity.y
        }
        
        
        // Bounce off right paddle
        if ballVelocity.x >= 0 &&
            ballPosition.x >= screenSize.width - (paddleOffset + paddleWidth/2 + ballSize/2) &&
            ballPosition.x <= screenSize.width - (paddleOffset - paddleWidth/2 + ballSize/2) {

            if abs(ballPosition.y - ((screenSize.height / 2) + scrollAmount)) < paddleHeight/2 + ballSize/2 {
                
                let totalVelocity = sqrt(pow(ballVelocity.x, 2) + pow(ballVelocity.y, 2))
                // Get random angle
                let angle = Double.random(in: -1...1)
                // Increase velocity
                ballVelocity.x = -totalVelocity * cos(angle) * 1.05
                ballVelocity.y = totalVelocity * sin(angle) * 1.05
            }
        }
        
        // Bounce off left paddle
        if ballVelocity.x <= 0 &&
            ballPosition.x <= (paddleOffset + paddleWidth/2 + ballSize/2) &&
            ballPosition.x >= (paddleOffset - paddleWidth + ballSize/2) {

            if abs(ballPosition.y - ((screenSize.height / 2) + AIamount)) < paddleHeight/2 + ballSize/2 {
                
                let totalVelocity = sqrt(pow(ballVelocity.x, 2) + pow(ballVelocity.y, 2))
                // Get random angle
                let angle = Double.random(in: (Double.pi-1)...(Double.pi+1))
                // Increase velocity
                ballVelocity.x = -totalVelocity * cos(angle) * 1.05
                ballVelocity.y = totalVelocity * sin(angle) * 1.05
            }
        }
        
        // Ball scores left
        if ballPosition.x >= screenSize.width {
            enemyScore += 1
            serveRight = false
            resetBall()
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
        AIamount = offset*AISpeed
    }
}
