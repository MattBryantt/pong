//
//  HomeView.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 20/9/2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var gameStart = false
    @State private var gameOptions = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                TextView(text: "Pong",
                         font: .title2,
                         colour: .red,
                         position: CGPoint(x: geometry.size.width / 2, 
                                           y: (geometry.size.height / 2) - 60))
                Button(action: {
                    gameStart = true
                }) {
                    Text("Start!")
                        .font(.headline)
                }
                .position(CGPoint(x: geometry.size.width / 2,
                                  y: (geometry.size.height / 2) + 10))
                .frame(width: geometry.size.width / 1.5, height: 20)
                
                Button(action: {
                    gameOptions = true
                }) {
                    Text("Options")
                        .font(.headline)
                }
                .position(CGPoint(x: geometry.size.width / 2,
                                  y: (geometry.size.height / 2) + 70))
                .frame(width: geometry.size.width / 1.5, height: 20)
                
                .navigationDestination(isPresented: $gameStart) {
                    ContentView()
                }
                
                .navigationDestination(isPresented: $gameOptions) {
                    OptionsView()
                }
            }
        }
    }
}

//#Preview {
//    HomeView()
//}
