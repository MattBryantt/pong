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
    @State private var paddlePosition: CGFloat = 0 // y position
    @State private var screenSize: CGSize = .zero
    @State private var scrollAmount = 0.0
    
    @State private var playerScore = 0
    @State private var enemyScore = 0
    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .frame(width:10, height: 50) // TODO: Fix doubled code
                    .foregroundColor(.green)
                    .position(x: 20,
                              y: (geometry.size.height / 2))
                Rectangle()
                    .frame(width: 10, height: 50)
                    .foregroundColor(.blue)
                    .position(x: geometry.size.width - 20,
                              y: (geometry.size.height / 2) + scrollAmount)
                    .focusable(true)
                    .digitalCrownRotation($scrollAmount,
                                          from: -100.0,
                                          through: 100.0, // TODO: Change to screen edge
                                          by: 1.0,
                                          sensitivity: .high)
                Circle()
                    .frame(width: 20, height: 20)
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
        }
    }

    func startGame() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            updateBallPosition()
        }
    }

    func updateBallPosition() {
        ballPosition.x += ballVelocity.x
        ballPosition.y += ballVelocity.y

        // Bounce off walls
        if ballPosition.x <= 0 || ballPosition.x >= screenSize.width {
            ballVelocity.x = -ballVelocity.x
        }

        // Bounce off top
        if ballPosition.y <= 0 || ballPosition.y >= screenSize.height {
            ballVelocity.y = -ballVelocity.y
        }

        // Bounce off paddle
//        if ballPosition.x >= screenSize.width - 30 { // TODO: Change to collision detection
//            let innerCalc = (screenSize.height / 2 + scrollAmount)
//            let tmp = abs(ballPosition.y - innerCalc)
//            if tmp <= 25 {
//                ballVelocity.x = -ballVelocity.x
//            }
//        }
        
        if ballVelocity.x >= 0 && ballPosition.x == screenSize.width - 30 {
            print("Ball position: \(ballPosition.y)")
            print("Paddle position: \(((screenSize.height / 2) + scrollAmount))")
            if ballPosition.y - ((screenSize.height / 2) + scrollAmount) < 25 + 0.5 {
                ballVelocity.x = -ballVelocity.x
            }
        }
        
        
        // Ball hits left
        if ballPosition.x >= screenSize.width {
            resetGame()
            enemyScore += 1
        }
        
        // Ball hits right
        if ballPosition.x <= 0 {
            resetGame()
            playerScore += 1
        }
    }
    
    func resetGame() {
        ballPosition = CGPoint(x: screenSize.width / 2,
                               y: screenSize.height / 2)
        ballVelocity = CGPoint(x: 1.5, y: 1.5) // TODO: Fix doubled code
    }
}

#Preview {
    ContentView()
}
