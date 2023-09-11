//
//  GameScene.swift
//  Ball SpriteKit
//
//  Created by Yusron Alfauzi on 07/09/23.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    let player = SKSpriteNode(imageNamed: "Circle")
    let ground = SKSpriteNode(imageNamed: "Rectangle")
    let gameOverLine = SKSpriteNode(color: .red, size: CGSize(width: 700, height: 10))
    var isFirstTouch = false
    
    let camp = SKCameraNode()
    
    enum bitMasks: UInt32{
        case player = 0b1
        case platform = 0b10
        case gameOverLine
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        self.size = CGSize(width: (view.window?.windowScene?.screen.bounds.width)!, height: (view.window?.windowScene?.screen.bounds.height)!)
        
        self.anchorPoint = .zero
        
        physicsWorld.contactDelegate = self
        
        ground.position = CGPoint(x: size.width / 2, y: 11)
        ground.zPosition = 5
//        ground.setScale(3)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.affectedByGravity = false
        addChild(ground)

        player.position = CGPoint(x: size.width / 2, y: size.height / 20)
        player.zPosition = 10
//        ground.setScale(3)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.restitution = 1
        player.physicsBody?.friction = 0
        player.physicsBody?.angularDamping = 0
        player.physicsBody?.categoryBitMask = bitMasks.player.rawValue
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = bitMasks.platform.rawValue
        addChild(player)
        
        gameOverLine.position = CGPoint(x: player.position.x, y: player.position.y - 200)
        gameOverLine.zPosition = 10
        gameOverLine.physicsBody = SKPhysicsBody(rectangleOf: gameOverLine.size)
        gameOverLine.physicsBody?.affectedByGravity = false
        gameOverLine.physicsBody?.allowsRotation = false
        gameOverLine.physicsBody?.categoryBitMask = bitMasks.gameOverLine.rawValue
        gameOverLine.physicsBody?.contactTestBitMask = bitMasks.platform.rawValue
        addChild(gameOverLine)
        
        makePlatform()
        makePlatform2()
        makePlatform3()
        makePlatform4()
        makePlatform5()
        makePlatform6()
        
        camp.setScale(1)
        camp.position.x = player.position.x
        camera = camp
    }
    
    override func update(_ currentTime: TimeInterval) {
        camp.position.y = player.position.y + 300
        gameOverLine.position.y = player.position.y - 400
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA: SKPhysicsBody
        let contactB: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            contactA = contact.bodyA
            contactB = contact.bodyB
        }else{
            contactA = contact.bodyB
            contactB = contact.bodyA
        }
        
        if contactA.categoryBitMask == bitMasks.platform.rawValue && contactB.categoryBitMask == bitMasks.gameOverLine.rawValue{
            contactA.node?.removeFromParent()
        }
            
            if contactA.categoryBitMask == bitMasks.player.rawValue && contactB.categoryBitMask == bitMasks.platform.rawValue{
            if (player.physicsBody?.velocity.dy)! < 0{
                player.physicsBody?.velocity = CGVector(dx: (player.physicsBody?.velocity.dx)!, dy: 1000)
               makePlatform5()
               makePlatform6()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            player.position.x = location.x
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.physicsBody?.isDynamic = true
        
        if isFirstTouch == false{
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 70))
        }
        ground.removeFromParent()
        isFirstTouch = true
    }
    
    func makePlatform(){
        let platform = SKSpriteNode(imageNamed: "Rectangle")
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 140, highestValue: 200).nextInt() + Int(player.position.y))
        platform.zPosition = 5
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = bitMasks.platform.rawValue
        platform.physicsBody?.collisionBitMask = 0
        platform.physicsBody?.contactTestBitMask = bitMasks.player.rawValue
        addChild(platform)
    }
    
    func makePlatform2(){
        let platform = SKSpriteNode(imageNamed: "Rectangle")
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 300, highestValue: 400).nextInt() + Int(player.position.y))
        platform.zPosition = 5
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = bitMasks.platform.rawValue
        platform.physicsBody?.collisionBitMask = 0
        platform.physicsBody?.contactTestBitMask = bitMasks.player.rawValue
        addChild(platform)
    }
    
    func makePlatform3(){
        let platform = SKSpriteNode(imageNamed: "Rectangle")
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 500, highestValue: 600).nextInt() + Int(player.position.y))
        platform.zPosition = 5
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = bitMasks.platform.rawValue
        platform.physicsBody?.collisionBitMask = 0
        platform.physicsBody?.contactTestBitMask = bitMasks.player.rawValue
        addChild(platform)
    }
    
    func makePlatform4(){
        let platform = SKSpriteNode(imageNamed: "Rectangle")
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 700, highestValue: 800).nextInt() + Int(player.position.y))
        platform.zPosition = 5
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = bitMasks.platform.rawValue
        platform.physicsBody?.collisionBitMask = 0
        platform.physicsBody?.contactTestBitMask = bitMasks.player.rawValue
        addChild(platform)
    }
    
    func makePlatform5(){
        let platform = SKSpriteNode(imageNamed: "Rectangle")
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 900, highestValue: 1000).nextInt() + Int(player.position.y))
        platform.zPosition = 5
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = bitMasks.platform.rawValue
        platform.physicsBody?.collisionBitMask = 0
        platform.physicsBody?.contactTestBitMask = bitMasks.player.rawValue
        addChild(platform)
    }
    
    func makePlatform6(){
        let platform = SKSpriteNode(imageNamed: "Rectangle")
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 1100, highestValue: 1200).nextInt() + Int(player.position.y))
        platform.zPosition = 5
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = bitMasks.platform.rawValue
        platform.physicsBody?.collisionBitMask = 0
        platform.physicsBody?.contactTestBitMask = bitMasks.player.rawValue
        addChild(platform)
    }
}