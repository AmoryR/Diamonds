//
//  Background.swift
//  Diamonds
//
//  Created by Amory Rouault on 30/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class Background {
    
    private let moveRightAction = SKAction.moveBy(x: 30, y: 0, duration: 0.1)
    private let moveLeftAction = SKAction.moveBy(x: -30, y: 0, duration: 0.1)
    
    var backgroundTexture: SKTexture?
    let backgrounds = SKNode()
    
    init(parent: SKNode, imageNamed: String) {
        self.backgroundTexture = SKTexture(imageNamed: imageNamed)
        
        for i in -6...15 {
            let background = SKSpriteNode(texture: self.backgroundTexture)
            background.position.x = CGFloat(i) * self.backgroundTexture!.size().width
            self.backgrounds.addChild(background)
        }
        
        self.backgrounds.position.y = -100
        self.backgrounds.zPosition = -100
        parent.addChild(self.backgrounds)
    }
    
    func move(direction: Direction) {
        switch direction {
        case .LEFT:
            self.backgrounds.run(SKAction.repeatForever(self.moveLeftAction))
            
            break
        case .RIGHT:
            self.backgrounds.run(SKAction.repeatForever(self.moveRightAction))
            
            break
        }
    }
    
    func stop() {
        self.backgrounds.removeAllActions()
    }
}
