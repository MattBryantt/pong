//
//  CrownController.swift
//  TestApp Watch App
//
//  Created by Matt Bryant on 30/7/2024.
//

import Foundation
import WatchKit

class CrownController: WKInterfaceController, ObservableObject, WKCrownDelegate {
    @Published var crownRotation = 0.0
    
    override func awake(withContext context: Any?) {
            super.awake(withContext: context)
            crownSequencer.delegate = self
            crownSequencer.focus()
        }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        print("Crown rotated with delta: \(rotationalDelta)")
        crownRotation += rotationalDelta
    }
    
}
