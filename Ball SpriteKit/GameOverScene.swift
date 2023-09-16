//
//  GameOverScene.swift
//  Ball SpriteKit
//
//  Created by Yusron Alfauzi on 12/09/23.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        let gameOver = SKLabelNode()
        gameOver.text = "GAME OVER"
        gameOver.fontSize = 45
        gameOver.fontColor = .red
        gameOver.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOver.zPosition = 5
        addChild(gameOver)
        
        let tapLabel = SKLabelNode()
        tapLabel.text = "Tap to Restart"
        tapLabel.fontSize = 35
        tapLabel.fontColor = .black
        tapLabel.position = CGPoint(x: size.width / 2, y: size.height / 4)
        tapLabel.zPosition = 5
        addChild(tapLabel)
        
        let outAction = SKAction.fadeOut(withDuration: 0.5)
        let inAction = SKAction.fadeIn(withDuration: 0.5)
        let sequence = SKAction.sequence([outAction, inAction])
        
        tapLabel.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.flipVertical(withDuration: 1)
        
        view?.presentScene(gameScene, transition: transition)
    }
}
