//
//  ContentView.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 23/7/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var ballPosition = CGPoint(x: 0, y: 0)
    @State private var ballVelocity = CGPoint(x: 5, y: 5)
    @State private var paddlePosition = CGSize(width: 0, height: 0)
    @State private var screenSize: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .frame(width: 50, height: 10)
                    .foregroundColor(.blue)
                    .position(x: geometry.size.width / 2 + paddlePosition.width, y: geometry.size.height - 40)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                paddlePosition = value.translation
                            }
                    )

                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
                    .position(x: ballPosition.x, y: ballPosition.y)
            }
            .onAppear {
                screenSize = geometry.size
                startGame()
            }
        }
    }

    func startGame() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
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
        if ballPosition.y <= 0 {
            ballVelocity.y = -ballVelocity.y
        }

        // Bounce off paddle
        if ballPosition.y >= screenSize.height - 50 &&
            abs(ballPosition.x - (screenSize.width / 2 + paddlePosition.width)) <= 25 {
            ballVelocity.y = -ballVelocity.y
        }

        // Reset if ball hits bottom
        if ballPosition.y >= screenSize.height {
            ballPosition = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
            ballVelocity = CGPoint(x: 5, y: 5)
        }
    }
}

#Preview {
    ContentView()
}
