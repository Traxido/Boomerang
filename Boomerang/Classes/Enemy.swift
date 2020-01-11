//
//  enemy.swift
//  Boomerang
//
//  Created by Andrew Sheron on 1/7/20.
//  Copyright © 2020 Andrew Sheron. All rights reserved.
//

import UIKit
import SpriteKit

class Enemy: SKSpriteNode {
    var colorString = String()
    
    convenience init(Color: String) {
        self.init()
        colorString = Color
        zPosition = 10
        texture = SKTexture.init(imageNamed: "\(colorString)Enemy")
        size = CGSize(width: 20, height: 20)
        name = "enemy"
    }
    
    // Helper function for finding a random point on a radius around the center (player's position)
    func randomPosition(radius:Float, center:CGPoint) -> CGPoint {
        // Random angle in [0, 2*pi]
        let theta = Float(arc4random_uniform(UInt32.max))/Float(UInt32.max-1) * Float.pi * 2.0
        // Convert polar to cartesian
        let x = radius * cos(theta)
        let y = radius * sin(theta)
        return CGPoint(x: CGFloat(x) + center.x, y: CGFloat(y) + center.y)
    }
    
    // Called after initilization and enemy added as child of SKNode
    func setUp(pos: CGPoint) {
            position = randomPosition(radius: 400, center: pos)
    }
    
    func handleCollision() {
        
        let splatter = SKSpriteNode.init(imageNamed: "\(colorString)Splatter")
        splatter.size = CGSize(width: 1, height: 1)
        splatter.position = position
        let randRot = Int(arc4random_uniform(UInt32(360)))
        let randSize = Int(arc4random_uniform(UInt32(20)))
        
        splatter.zRotation = CGFloat(randRot) * (CGFloat.pi/180)
        splatter.run(.scale(to: CGFloat(randSize + 100), duration: 0.2))
        
        if let parent = self.parent {
            parent.addChild(splatter)
        }
        
        splatter.color = .black
        splatter.colorBlendFactor = 0.1
        
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = Enemy.init(Color: colorString)
        return copy
    }
    
}
