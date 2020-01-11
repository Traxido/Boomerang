//
//  GameViewController.swift
//  Boomerang
//
//  Created by Andrew Sheron on 1/7/20.
//  Copyright © 2020 Andrew Sheron. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneNode = GameScene(size: view.frame.size)
        sceneNode.backgroundColor = UIColor(red:0.07, green:0.07, blue:0.07, alpha:1.0)
        sceneNode.scaleMode = .resizeFill
        
        if let view = self.view as! SKView? {
            view.presentScene(sceneNode)
            view.ignoresSiblingOrder = false
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
