//
//  HammerScene.swift
//  Groundhog Day
//
//  Created by Elfstrom, Cole B on 12/19/19.
//  Copyright © 2019 Garcia, Alejandro. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class HammerScene: SKScene
{
    var hammerFrames:[SKTexture]?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize)
    {
        super.init(size: size)
        self.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        var frames:[SKTexture] = []
        let hammerAtlas = SKTextureAtlas(named: "GroundhogDay")
        
        for index in 1...8
        {
            let Name = "Hammer\(index).png"
            let texture = hammerAtlas.textureNamed(Name)
            
            frames.append(texture)
        }
        
        self.hammerFrames = frames
    }
    
    func runHit(x: CGFloat, y: CGFloat)
    {
        let texture = self.hammerFrames![0]
        let hammer = SKSpriteNode(texture: texture)
        
        hammer.size = CGSize(width: 140, height: 140)
        hammer.position = CGPoint(x: x, y: y)
        
        self.addChild(hammer)
        hammer.run(SKAction.repeatForever(SKAction.animate(with: self.hammerFrames!, timePerFrame: 0.1, resize: false, restore: true)))
        
        let moveAction = SKAction.moveBy(x: 0, y: 0, duration: 0.8)
        let removeAction =  SKAction.run
        {
            hammer.removeAllActions()
            hammer.removeFromParent()
        }
        
        let allActions = SKAction.sequence([moveAction, removeAction])
        hammer.run(allActions)
    }
}
