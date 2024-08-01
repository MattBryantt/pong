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
    @State private var paddlePosition: CGFloat = 0
    @State private var screenSize: CGSize = .zero
    @State private var scrollAmount = 0.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .frame(width: 10, height: 50)
                    .foregroundColor(.blue)
                    .position(x: geometry.size.width - 40,
                              y: (geometry.size.height / 2) + scrollAmount)
                    .focusable(true)
                    .digitalCrownRotation($scrollAmount,
                                          from: -100.0,
                                          through: 100.0,
                                          by: 1.0)

                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
                    .position(x: ballPosition.x,
                              y: ballPosition.y)
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
        if ballPosition.x >= screenSize.width - 50 {
            let innerCalc = (screenSize.height / 2 + scrollAmount)
            let tmp = abs(ballPosition.y - innerCalc)
            if tmp <= 25 {
                ballVelocity.x = -ballVelocity.x
            }
        }

        // Reset if ball hits bottom
//        if ballPosition.y >= screenSize.height {
//            ballPosition = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
//            ballVelocity = CGPoint(x: 2, y: 2) // TODO: Fix doubled code
//            print("Ball out of bounds")
//        }
    }
}

#Preview {
    ContentView()
}
