//
//  TestAppApp.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 23/7/2024.
//

import SwiftUI

@main
struct TestApp_Watch_AppApp: App {
    @StateObject var gameController = GameController()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(gameController)
        }
    }
}
