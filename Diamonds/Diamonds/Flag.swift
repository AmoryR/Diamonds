//
//  Flag.swift
//  Diamonds
//
//  Created by Amory Rouault on 04/04/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class Flag: SKSpriteNode {
    
    private var flagFrames: [SKTexture] = []
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.buildFrames()
        self.run(SKAction.repeatForever(SKAction.animate(with: self.flagFrames, timePerFrame: 0.3)))
    }
    
    func buildFrames() {
        
        // Left
        let flagAtlas = SKTextureAtlas(named: "blueFlag")
        let numFlag = flagAtlas.textureNames.count
        
        for i in 1...numFlag {
            let textureName = "flagBlue\(i)"
            self.flagFrames.append(flagAtlas.textureNamed(textureName))
        }
    
    }
    
}
