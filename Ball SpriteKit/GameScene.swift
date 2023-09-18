//
//  GameScene.swift
//  Ball SpriteKit
//
//  Created by Yusron Alfauzi on 07/09/23.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    let player = SKSpriteNode(imageNamed: "Circle")
    let ground = SKSpriteNode(imageNamed: "Rectangle")
    let gameOverLine = SKSpriteNode(color: .red, size: CGSize(width: 900, height: 10))
    var isFirstTouch = false
    
    let scoreLabel = SKLabelNode()
    let bestScoreLabel = SKLabelNode()
    var score = 0
    var bestScore = 0
    
    let defaults = UserDefaults.standard
    
    private var motionManager: CMMotionManager!
    var playerAcceleration = CGVector.zero
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
        
        startMotionManager()
        
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
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.restitution = 1
        player.physicsBody?.friction = 0
        player.physicsBody?.angularDamping = 0
        player.physicsBody?.categoryBitMask = bitMasks.player.rawValue
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = bitMasks.platform.rawValue | bitMasks.gameOverLine.rawValue
        addChild(player)
        
        gameOverLine.position = CGPoint(x: player.position.x, y: player.position.y - 250)
        gameOverLine.zPosition = -1
        gameOverLine.physicsBody = SKPhysicsBody(rectangleOf: gameOverLine.size)
        gameOverLine.physicsBody?.affectedByGravity = false
        gameOverLine.physicsBody?.allowsRotation = false
        gameOverLine.physicsBody?.categoryBitMask = bitMasks.gameOverLine.rawValue
        gameOverLine.physicsBody?.contactTestBitMask = bitMasks.platform.rawValue | bitMasks.player.rawValue
        addChild(gameOverLine)
        
        scoreLabel.position.x = size.width - 320
//        scoreLabel.position.x = 75
        scoreLabel.zPosition = 20
        scoreLabel.attributedText = NSAttributedString(string: "Score: \(score)", attributes: [.font: UIFont.systemFont(ofSize: 25, weight: .regular)])
        scoreLabel.fontColor = .black
        //        scoreLabel.text = "Score: \(score)"
        //        scoreLabel.fontSize = 20
        addChild(scoreLabel)
        
        bestScore = defaults.integer(forKey: "best score")
        bestScoreLabel.position.x = size.width - 110
//        bestScoreLabel.position.x = 280
        bestScoreLabel.zPosition = 20
        //        bestScoreLabel.text = "Best Score: \(bestScore)"
        bestScoreLabel.fontColor = .black
        bestScoreLabel.attributedText = NSAttributedString(string: "Best Score: \(bestScore)", attributes: [.font: UIFont.systemFont(ofSize: 25, weight: .regular)])
        //        bestScoreLabel.fontSize = 20
        addChild(bestScoreLabel)
        
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
    
    private func startMotionManager() {
        motionManager = CMMotionManager()
        guard motionManager.isAccelerometerAvailable else {
            return
        }
        motionManager.startAccelerometerUpdates()
    }
    
    override func update(_ currentTime: TimeInterval) {
        camp.position.y = player.position.y + 300
        if (player.physicsBody?.velocity.dy)! > 0{
            gameOverLine.position.y = player.position.y - 400
        }
        
        if let accelerometerData = motionManager.accelerometerData, isFirstTouch == true {
            let accelerationX = CGFloat(accelerometerData.acceleration.x)
            //                        let accelerationY = CGFloat(accelerometerData.acceleration.y)
            
            //            playerAcceleration = CGVector(dx: accelerationX * 1000, dy: 0)
            player.position.x += accelerationX * 250 * CGFloat(0.1)
            
            let minX = player.size.width / 2
            let maxX = size.width - player.size.width / 2
            player.position.x = max(minX, min(player.position.x, maxX))
        }
        
        scoreLabel.position.y = player.position.y + 600
        bestScoreLabel.position.y = player.position.y + 600
        
//        scoreLabel.position.y = size.height - 50
//        bestScoreLabel.position.y = size.height - 50
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
                player.physicsBody?.velocity = CGVector(dx: (player.physicsBody?.velocity.dx)!, dy: 1200)
                contactB.node?.removeFromParent()
                //                makePlatform5()
                //                makePlatform6()
                makePlatform7()
                makePlatform8()
                addScore()
            }
        }
        
        if contactA.categoryBitMask == bitMasks.player.rawValue && contactB.categoryBitMask == bitMasks.gameOverLine.rawValue{
            gameOver()
        }
    }
    
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for touch in touches{
    //            let location = touch.location(in: self)
    //
    //            player.position.x = location.x
    //        }
    //    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.physicsBody?.isDynamic = true
        
        if isFirstTouch == false{
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 60))
        }
        ground.removeFromParent()
        isFirstTouch = true
    }
    
    func makePlatform(){
        let platform = SKSpriteNode(imageNamed: "Rectangle")
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 100, highestValue: 200).nextInt() + Int(player.position.y))
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
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 250, highestValue: 350).nextInt() + Int(player.position.y))
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
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 400, highestValue: 500).nextInt() + Int(player.position.y))
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
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 550, highestValue: 650).nextInt() + Int(player.position.y))
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
    
    func makePlatform6(){
        let platform = SKSpriteNode(imageNamed: "Rectangle")
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 850, highestValue: 950).nextInt() + Int(player.position.y))
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
    
    func makePlatform7(){
        let platform = SKSpriteNode(imageNamed: "Rectangle")
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 800, highestValue: 850).nextInt() + Int(player.position.y))
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
        
    func makePlatform8(){
        let platform = SKSpriteNode(imageNamed: "Rectangle")
        platform.position = CGPoint(x: GKRandomDistribution(lowestValue: 70, highestValue: 350).nextInt(), y: GKRandomDistribution(lowestValue: 650, highestValue: 700).nextInt() + Int(player.position.y))
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
    
    
    func gameOver(){
        let gameOverScene = GameOverScene(size: self.size)
        let transition = SKTransition.crossFade(withDuration: 0.5)
        
        view?.presentScene(gameOverScene, transition: transition)
        
        if score > bestScore{
            bestScore = score
            defaults.set(bestScore, forKey: "best score")
        }
    }
    
    func addScore(){
        score += 1
        //        scoreLabel.text = "Score: \(score)"
        scoreLabel.attributedText = NSAttributedString(string: "Score: \(score)", attributes: [.font: UIFont.systemFont(ofSize: 25, weight: .regular)])
    }
}
