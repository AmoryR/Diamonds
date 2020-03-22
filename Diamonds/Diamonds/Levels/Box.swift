//
//  Box.swift
//  Diamonds
//
//  Created by Amory Rouault on 22/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class Box: SKSpriteNode {
    
    init(texture: SKTexture, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.color = .clear
    }
    
}
