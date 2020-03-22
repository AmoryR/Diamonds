//
//  Player.swift
//  Diamonds
//
//  Created by Amory Rouault on 20/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode, Actor {
    
    private var moveLeftFrames: [SKTexture] = []
    private var moveRightFrames: [SKTexture] = []
    
    private let moveRightAction = SKAction.moveBy(x: 30, y: 0, duration: 0.1)
    private let moveLeftAction = SKAction.moveBy(x: -30, y: 0, duration: 0.1)
    
    init(texture: SKTexture, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // Because the player comes from GameScene
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
        self.buildFrames()
    }
    
    func buildFrames() {
        
        // Left
        let moveLeftAtlas = SKTextureAtlas(named: "moveLeft")
        let numImagesLeft = moveLeftAtlas.textureNames.count
        
        for i in 1...numImagesLeft {
            let textureName = "alienGreen_walk\(i)_left"
            self.moveLeftFrames.append(moveLeftAtlas.textureNamed(textureName))
        }
        
        // Right
        let moveRightAtlas = SKTextureAtlas(named: "moveRight")
        let numImageRight = moveRightAtlas.textureNames.count
        
        for i in 1...numImageRight {
            let textureName = "alienGreen_walk\(i)_right"
            self.moveRightFrames.append(moveRightAtlas.textureNamed(textureName))
        }
        
        
    }
    
    func move(direction: Direction) {
        switch direction {
        case .LEFT:
            self.run(SKAction.repeatForever(self.moveLeftAction), withKey: "moveLeft")
            self.run(SKAction.repeatForever(SKAction.animate(with: self.moveLeftFrames, timePerFrame: 0.1)))
            
            break
        case .RIGHT:
            self.run(SKAction.repeatForever(self.moveRightAction), withKey: "moveRight")
            self.run(SKAction.repeatForever(SKAction.animate(with: self.moveRightFrames, timePerFrame: 0.1)))
            break
        }

    }
    
    func stopMoving() {
        self.removeAllActions()
        
        self.texture = SKTexture(imageNamed: "alienGreen_front")
    }
    
    func jump() {
        print("Make a great jump")
        let jumpUpAction = SKAction.moveBy(x: 0, y: 138, duration: 0.2)
        let jumpDownAction = SKAction.moveBy(x: 0, y: -138, duration: 0.2)
        let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])
        self.run(jumpSequence)
    }
    

}
