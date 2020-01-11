//
//  GameScene.swift
//  Boomerang
//
//  Created by Andrew Sheron on 1/7/20.
//  Copyright © 2020 Andrew Sheron. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player = SKSpriteNode()
    var boomerang = Boomerang()
    
    var addEnemiesTimer: Timer? = nil
    var addEnemiesInterval = 2
    
    var rotationSpeed: TimeInterval = 2
    var enemyMovementSpeed: TimeInterval = 8
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        setUpPlayer()
        setUpBoomerang()
        self.addEnemiesTimer = Timer.scheduledTimer(timeInterval: TimeInterval(addEnemiesInterval), target: self, selector: #selector(addEnemies), userInfo: nil, repeats: true)
    }
    
    func setUpPlayer() {
        player = SKSpriteNode.init(imageNamed: "player")
        player.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        player.size = CGSize(width: 24, height: 24)
        player.name = "player"
        player.zPosition = 12
        
        //Light Mode
        player.color = .white
        player.colorBlendFactor = 1
        
        player.physicsBody = SKPhysicsBody.init(circleOfRadius: 12)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = physicsCategory.player
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = physicsCategory.enemy
        
        self.addChild(player)
    }
    
    func setUpBoomerang() {
        boomerang = Boomerang.init(imageNamed: "boomerang")
        boomerang.position = CGPoint(x: (self.frame.width / 2) + 24, y: (self.frame.height / 2))
        boomerang.size = CGSize(width: 18, height: 18)
        boomerang.name = "boomerang"
        boomerang.zPosition = 20
        
        boomerang.physicsBody = SKPhysicsBody.init(circleOfRadius: 9)
        boomerang.physicsBody?.affectedByGravity = false
        boomerang.physicsBody?.allowsRotation = false
        boomerang.physicsBody?.categoryBitMask = physicsCategory.boomerang
        boomerang.physicsBody?.collisionBitMask = 0
        boomerang.physicsBody?.contactTestBitMask = physicsCategory.enemy
        
        boomerang.run(.repeatForever(.rotate(byAngle: CGFloat((360 * Float.pi)/180), duration: 0.25)))
        
        self.addChild(boomerang)
        
        let circle = UIBezierPath.init(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 30, startAngle: 0, endAngle: CGFloat((360 * Float.pi)/180), clockwise: clockWise)
        let circularMove = SKAction.follow(circle.cgPath, asOffset: false, orientToPath: false, duration: rotationSpeed)
        boomerang.run(.repeatForever(circularMove), withKey: "c")
    }
    
    @objc func addEnemies() {
        let randColor = Int(arc4random_uniform(UInt32(colors.count)))
        let color = colors[randColor]
        let enemy = Enemy.init(Color: color)
        enemy.setUp(pos: player.position)
        
        enemy.physicsBody = SKPhysicsBody.init(circleOfRadius: 12)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.categoryBitMask = physicsCategory.enemy
        enemy.physicsBody?.collisionBitMask = 0
        enemy.physicsBody?.contactTestBitMask = physicsCategory.player | physicsCategory.boomerang
        
        self.addChild(enemy)
        
        enemy.run(.sequence([.move(to: player.position, duration: enemyMovementSpeed), .removeFromParent()]))
    }
    
    func createLabel() {
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    var clockWise = true
    var lastPos = CGPoint()
    
    func touchUp(atPoint pos : CGPoint) {
        
        if boomerang.isMoving == false {
            
            let xVal = boomerang.position.x - player.position.x
            let yVal = boomerang.position.y - player.position.y
            
            lastPos = CGPoint(x: boomerang.position.x, y: boomerang.position.y)
            
            print("xVal \(xVal)")
            print("yVal \(yVal)")
            
            // In Radians
            let angle = CGFloat(atan2f(Float(yVal), Float(xVal)))
            
            let newX = cos(angle) * CGFloat(self.frame.width/2)
            let newY = sin(angle) * CGFloat(self.frame.width/2)
            
            let newPos = CGPoint(x: boomerang.position.x + newX, y: boomerang.position.y + newY)
            var circle = UIBezierPath()
            
            if clockWise == true {
                //Changes Direction
                clockWise = false
                circle = UIBezierPath.init(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 30, startAngle: angle + CGFloat((360 * Float.pi)/180), endAngle: angle, clockwise: clockWise)
            } else {
                clockWise = true
                circle = UIBezierPath.init(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 30, startAngle: angle, endAngle: angle + CGFloat((360 * Float.pi)/180), clockwise: clockWise)
            }
            
            let circularMove = SKAction.follow(circle.cgPath, asOffset: false, orientToPath: false, duration: rotationSpeed)
            boomerang.removeAction(forKey: "c")
            let moveBack = SKAction.move(to: lastPos, duration: 0.5)
            boomerang.run(.sequence([.move(to: newPos, duration: 0.5), moveBack, .repeatForever(circularMove)]), withKey: "c")
            
        }
    }
    
    func toRadians(_ val: CGFloat) -> CGFloat {
        let angle = val * (CGFloat.pi / 180)
        return angle
    }
    
    func toDegrees(_ val: CGFloat) -> CGFloat {
        let angle = val * (180 / CGFloat.pi)
        return angle
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA.node
        let secondBody = contact.bodyB.node
        
        
        if (firstBody?.name == "enemy") && (secondBody?.name == "boomerang") {
            if let enemy = (firstBody as? Enemy) {
                enemy.handleCollision()
                if let particle = SKEmitterNode.init(fileNamed: "explosion.sks") {
                    particle.zPosition = 1
                    particle.particleTexture = enemy.texture
                    particle.position = enemy.position
                    addChild(particle)
                }
                enemy.removeFromParent()
            }
        } else if firstBody?.name == "boomerang" && secondBody?.name == "enemy" {
            if let enemy = (secondBody as? Enemy) {
                enemy.handleCollision()
                if let particle = SKEmitterNode.init(fileNamed: "explosion.sks") {
                    particle.zPosition = 1
                    particle.particleTexture = enemy.texture
                    particle.position = enemy.position
                    addChild(particle)
                }
                enemy.removeFromParent()
            }
        }
        
    }
}
