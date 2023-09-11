//
//  ContentView.swift
//  Ball SpriteKit
//
//  Created by Yusron Alfauzi on 01/09/23.
//

import SwiftUI
import SpriteKit

class StartScene: SKScene{
    override func didMove(to view: SKView) {
        self.size = CGSize(width: (view.window?.windowScene?.screen.bounds.width)!, height: (view.window?.windowScene?.screen.bounds.height)!)
        scene?.scaleMode = .aspectFill
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let startNode = atPoint(location)
            
            if startNode.name == "startGameButton"{
                let game = GameScene(size: self.size)
                let transition = SKTransition.fade(withDuration: 1)
                
                self.view?.presentScene(game, transition: transition)
            }
        }
    }
}

struct ContentView: View {
    
    let startScene = StartScene(fileNamed: "StartScene")
    
    var body: some View {
        SpriteView(scene: startScene!)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
