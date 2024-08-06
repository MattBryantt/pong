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
    
    private var paddleHeight: CGFloat = 50
    private var paddleWidth: CGFloat = 10
    
    private var paddleOffset: CGFloat = 20
    
    private var ballSize: CGFloat = 20
    
    @State private var playerScore = 0
    @State private var enemyScore = 0
    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .frame(width: paddleWidth, height: paddleHeight) // TODO: Fix doubled code
                    .foregroundColor(.green)
                    .position(x: paddleOffset,
                              y: (geometry.size.height / 2) + AIamount)
                Rectangle()
                    .frame(width: 10, height: 50)
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
                Circle()
                    .frame(width: ballSize, height: ballSize)
                    .foregroundColor(.red)
                    .position(x: ballPosition.x,
                              y: ballPosition.y)
                Text(verbatim: "Score: \(enemyScore) - \(playerScore)")
                    .position(x: geometry.size.width / 2,
                              y: 0)
            }
            .onAppear {
                screenSize = geometry.size
                startGame()
            }
            .onTapGesture {
                if (!gamePaused) {
                    print("Game Pause")
                    gamePaused = true
                    timer?.invalidate()
                } else {
                    print("Game Start")
                    gamePaused = false
                    startGame()
                }
            }
        }
    }

    func startGame() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            updateBallPosition()
            updateAIPosition()
            // print("x: \(ballVelocity.x), y: \(ballVelocity.y)")
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
            ballPosition.x >= screenSize.width - paddleOffset*1.8 &&
            ballPosition.x <= screenSize.width - paddleOffset*1.5 {

            if abs(ballPosition.y - ((screenSize.height / 2) + scrollAmount)) < paddleHeight*0.7 {
                ballVelocity.x = -ballVelocity.x
            }
        }
        
        // Bounce off left
        if ballVelocity.x <= 0 &&
            ballPosition.x <= paddleOffset*1.8 &&
            ballPosition.x >= paddleOffset*1.5 {

            if abs(ballPosition.y - ((screenSize.height / 2) + AIamount)) < paddleHeight*0.7 {
                ballVelocity.x = -ballVelocity.x
            }
        }
        
        // Ball hits left
        if ballPosition.x >= screenSize.width {
            resetBall()
            enemyScore += 1
        }
        
        // Ball hits right
        if ballPosition.x <= 0 {
            resetBall()
            playerScore += 1
        }
    }
    
    func updateAIPosition() {
        AIamount = ballPosition.x - (screenSize.height / 2)
    }
    
    func resetBall() {
        // timer?.invalidate() // TODO: Create pause on resetBall()
        ballPosition = CGPoint(x: screenSize.width / 2,
                               y: screenSize.height / 2)
        let curX = abs(ballVelocity.x)
        let curY = abs(ballVelocity.y)
        ballVelocity = CGPoint(x: curX + 0.01,
                               y: curY + 0.01) // TODO: Fix doubled code
        // TODO: Change to increasing velocity
        
    }
}

#Preview {
    ContentView()
}
