//
//  Player.swift
//  Diamonds
//
//  Created by Amory Rouault on 20/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

enum PlayerActionsKeys: String {
    case MOVE_LEFT = "moveLeft"
    case ANIMATE_LEFT = "animateLeft"
    case MOVE_RIGHT = "moveRight"
    case ANIMATE_RIGHT = "animateRIGHT"
    case CLIMB = "climb"
    case ANIMATE_CLIMB = "animateClimb"
}

enum PlayerState {
    case NORMAL
    case CLIMBING
}

class Player: SKSpriteNode, Actor {
    
    private var moveLeftFrames: [SKTexture] = []
    private var moveRightFrames: [SKTexture] = []
    private var climbFrames: [SKTexture] = []
    
    private let moveRightAction = SKAction.moveBy(x: 30, y: 0, duration: 0.1)
    private let moveLeftAction = SKAction.moveBy(x: -30, y: 0, duration: 0.1)
    private let climbAction = SKAction.moveBy(x: 0, y: 20, duration: 0.1)
    
    private(set) var state: PlayerState = .NORMAL
    
    var isJumping = false
    private let jumpForce: CGFloat = 100 // 85
    
    init(texture: SKTexture, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        self.buildFrames()
        self.buildPhysics()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        // Climb
        let climbAtlas = SKTextureAtlas(named: "climb")
        let numImageClimb = climbAtlas.textureNames.count
        
        for i in 1...numImageClimb {
            let textureName = "alienGreen_climb\(i)"
            self.climbFrames.append(climbAtlas.textureNamed(textureName))
        }
    }
    
    func buildPhysics() {
        
        // Hack to get the physics body in the right position
        self.anchorPoint = CGPoint(x: 0.5, y: 0.30)
        
        // Maybe use a circle for the leg
        
        // Size based on texture
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 105, height: 150))
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.mass = 0.1
        
        self.physicsBody?.categoryBitMask = 0x1 << 2
        self.physicsBody?.collisionBitMask = 0x1 << 0
        self.physicsBody?.contactTestBitMask = (0x1 << 0) | (0x1 << 2) | (0x1 << 3) | (0x1 << 4) // Ground or ladder or coin or flag
    }
    
    func move(direction: Direction) {
        switch direction {
        case .LEFT:
            self.run(SKAction.repeatForever(self.moveLeftAction), withKey: PlayerActionsKeys.MOVE_LEFT.rawValue)
            self.run(SKAction.repeatForever(SKAction.animate(with: self.moveLeftFrames, timePerFrame: 0.1)), withKey: PlayerActionsKeys.ANIMATE_LEFT.rawValue)
            
            break
        case .RIGHT:
            self.run(SKAction.repeatForever(self.moveRightAction), withKey: PlayerActionsKeys.MOVE_RIGHT.rawValue)
            self.run(SKAction.repeatForever(SKAction.animate(with: self.moveRightFrames, timePerFrame: 0.1)), withKey: PlayerActionsKeys.ANIMATE_RIGHT.rawValue)
            break
        }

    }
    
    func stop(actionKey: PlayerActionsKeys) {
        self.removeAction(forKey: actionKey.rawValue)
    }
    
    func jump() {
        if !self.isJumping {
            self.isJumping = true
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0);
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: self.jumpForce));
        }
    }
    
    func landFromJump() {
        self.isJumping = false
    }
    
    func climb() {
        // Move the player to the ladder center
        // Run animation
        self.run(SKAction.repeatForever(SKAction.animate(with: self.climbFrames, timePerFrame: 0.1)), withKey: PlayerActionsKeys.ANIMATE_CLIMB.rawValue)
        // Run action
        self.run(SKAction.repeatForever(self.climbAction), withKey: PlayerActionsKeys.CLIMB.rawValue)
        
    }
    
    func select() {}
    
    func setState(state: PlayerState) {
        self.state = state
    }
    

}
