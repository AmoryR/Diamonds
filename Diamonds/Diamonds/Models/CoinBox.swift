//
//  CoinBox.swift
//  Diamonds
//
//  Created by Amory Rouault on 05/04/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class CoinBox: SKSpriteNode {
    
    private let emptyTexture = SKTexture(imageNamed: "Level1_045")
    private var coins: Int = 2
    private var lastHit: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func hit() -> Bool {
        // TODO: Run hit animation
        
        self.coins -= 1
        
        if self.lastHit {
            return false
        } else if self.coins <= 0 {
            self.texture = self.emptyTexture
            self.lastHit = true
            return true
        } else {
            return true
        }
    }
    
}
