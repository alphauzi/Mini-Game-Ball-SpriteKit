//
//  Ball_SpriteKitApp.swift
//  Ball SpriteKit
//
//  Created by Yusron Alfauzi on 01/09/23.
//

import SwiftUI

@main
struct Ball_SpriteKitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//motionManager.startAccelerometerUpdates()
//motionManager.accelerometerUpdateInterval = 0.1
//motionManager.startAccelerometerUpdates(to: OperationQueue.main ) {
//    (data, error) in
//    
//    self.physicsWorld.gravity = CGVectorMake(CGFloat((data?.acceleration.x)!) * 1, 0)
//}
