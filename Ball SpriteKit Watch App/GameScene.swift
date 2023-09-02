//
//  GameScene.swift
//  Ball SpriteKit Watch App
//
//  Created by Yusron Alfauzi on 01/09/23.
//

import Foundation
import SpriteKit

class GameScene: SKScene, ObservableObject, SKPhysicsContactDelegate{
    
    let player = SKSpriteNode(imageNamed: "Rectangle")
    let playerComputer = SKSpriteNode(imageNamed: "Rectangle")
    let ball = SKSpriteNode(imageNamed: "Circle")
    
    var playerPosX: Double = 0
    
//    var playerScore = 0
//    var playerScoreLabel = SKLabelNode()
//    var computerScore = 0
//    var computerScoreLabel = SKLabelNode()
    
    var speedXBall = 0.3
    var speedYBall = 0.3
    
    enum bitMaks: UInt32{
        case ball = 0b1
        case frame = 0b10
        case player = 0b100
    }
    
    override func sceneDidLoad() {
        scene?.size = CGSize(width: 170, height: 200)
        scene?.scaleMode = .aspectFill
        scene?.anchorPoint = .zero
        
        backgroundColor = .white
        physicsWorld.contactDelegate = self
        
        //MARK: - player
        player.position = CGPoint(x: size.width / 2, y: 10)
        player.setScale(0.35)
        player.zPosition = 5
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.friction = 0
        player.physicsBody?.restitution = 1
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        player.physicsBody?.allowsRotation = false
        
        player.physicsBody?.categoryBitMask = bitMaks.player.rawValue
        player.physicsBody?.contactTestBitMask = bitMaks.ball.rawValue
        player.physicsBody?.collisionBitMask = bitMaks.ball.rawValue
        
        addChild(player)
        
        //MARK: - playerComputer
        playerComputer.position = CGPoint(x: size.width / 2, y: 190)
        playerComputer.setScale(0.35)
        playerComputer.zPosition = 5
        
        playerComputer.physicsBody = SKPhysicsBody(rectangleOf: playerComputer.size)
        playerComputer.physicsBody?.friction = 0
        playerComputer.physicsBody?.restitution = 1
        playerComputer.physicsBody?.affectedByGravity = false
        playerComputer.physicsBody?.isDynamic = false
        playerComputer.physicsBody?.allowsRotation = false
        
        playerComputer.physicsBody?.categoryBitMask = bitMaks.player.rawValue
        playerComputer.physicsBody?.contactTestBitMask = bitMaks.ball.rawValue
        playerComputer.physicsBody?.collisionBitMask = bitMaks.ball.rawValue
        
        addChild(playerComputer)
        
        //MARK: - ball
        ball.position = CGPoint(x: size.width / 2, y: size.height / 2)
        ball.setScale(0.35)
        ball.zPosition = 5
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height / 2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.categoryBitMask = bitMaks.ball.rawValue
        ball.physicsBody?.contactTestBitMask = bitMaks.frame.rawValue | bitMaks.player.rawValue
        ball.physicsBody?.collisionBitMask = bitMaks.frame.rawValue | bitMaks.player.rawValue
        
        addChild(ball)
        ball.physicsBody?.applyImpulse(CGVector(dx: speedXBall, dy: speedYBall))
        
        let frame = SKPhysicsBody(edgeLoopFrom: self.frame)
        frame.friction = 0
        frame.restitution = 0
        self.physicsBody = frame
        frame.categoryBitMask = bitMaks.frame.rawValue
        frame.contactTestBitMask = bitMaks.ball.rawValue
        frame.collisionBitMask = bitMaks.ball.rawValue
        
//        playerScoreLabel.position = CGPoint(x: size.width / 3, y: size.height / 2)
//        playerScoreLabel.zPosition = 10
//        playerScoreLabel.fontColor = .red
//        playerScoreLabel.text = "\(playerScore)"
//        addChild(playerScoreLabel)
//
//        computerScoreLabel.position = CGPoint(x: size.width / 1.5, y: size.height / 2)
//        computerScoreLabel.zPosition = 10
//        computerScoreLabel.fontColor = .red
//        computerScoreLabel.text = "\(computerScore)"
//        addChild(computerScoreLabel)

        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.position.x = playerPosX / 5
        
        if player.position.x < 25 {
            player.position.x = 25
        }
        
        if player.position.x > 150 {
            player.position.x = 150
        }
        
        if ball.position.y > frame.midY{
            let playerComputerMove = SKAction.moveTo(x: ball.position.x, duration: 0.2)
            playerComputer.run(playerComputerMove)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var ballNode: SKNode!
        var otherNode: SKNode!
        
        let yPos = contact.contactPoint.y
        let xPos = contact.contactPoint.x
        
        if contact.bodyA.node?.physicsBody?.categoryBitMask == bitMaks.ball.rawValue{
            ballNode = contact.bodyA.node
            otherNode = contact.bodyB.node
        } else if contact.bodyB.node?.physicsBody?.categoryBitMask == bitMaks.ball.rawValue{
            ballNode = contact.bodyB.node
            otherNode = contact.bodyA.node
        }
        
        if otherNode.physicsBody?.categoryBitMask == bitMaks.frame.rawValue{
            //ball hit the frame
            
            if yPos >= otherNode.frame.maxY - 2{
//                playerScore += 1
//                playerScoreLabel.text = "\(playerScore)"
                
                let championLabel = SKLabelNode()
                championLabel.text = "🏆"
                championLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
                championLabel.zPosition = 15
                addChild(championLabel)
                
                ballNode.removeFromParent()
                
                //make a new ball
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    championLabel.removeFromParent()
                    self.makeNewBall()
                }
                
            }else if yPos <= otherNode.frame.minY + 2{
//                computerScore += 1
//                computerScoreLabel.text = "\(computerScore)"
                let loseLabel = SKLabelNode()
                loseLabel.text = "❌"
                loseLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
                loseLabel.zPosition = 15
                addChild(loseLabel)

                ballNode.removeFromParent()
                
                //make a new ball
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    loseLabel.removeFromParent()
                    self.makeNewBall()
                }
            }
        }
        
        if otherNode.physicsBody?.categoryBitMask == bitMaks.player.rawValue{
            if xPos >= otherNode.frame.midX - 2{
                speedXBall += 0.2
                ballNode.physicsBody?.velocity.dx = 0
                ballNode.physicsBody?.applyImpulse(CGVector(dx: speedXBall, dy: 0))
            }
            if xPos <= otherNode.frame.midX + 2{
                speedXBall += 0.2
                ballNode.physicsBody?.velocity.dx = 0
                ballNode.physicsBody?.applyImpulse(CGVector(dx: -speedXBall, dy: 0))
            }
        }
        
    }
    
    func makeNewBall(){
        ball.position = CGPoint(x: size.width / 2, y: size.height / 2)
        ball.setScale(0.35)
        ball.zPosition = 5
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height / 2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.categoryBitMask = bitMaks.ball.rawValue
        ball.physicsBody?.contactTestBitMask = bitMaks.frame.rawValue | bitMaks.player.rawValue
        ball.physicsBody?.collisionBitMask = bitMaks.frame.rawValue | bitMaks.player.rawValue
        
        addChild(ball)
        ball.physicsBody?.applyImpulse(CGVector(dx: speedXBall, dy: speedYBall))
    }
}
