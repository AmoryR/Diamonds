//
//  HUD.swift
//  Diamonds
//
//  Created by Amory Rouault on 04/04/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class HUD {
    
    // coinsCount | coinTexture      diamondTexture * diamondsCollectable
    
    private let coinTexture = SKTexture(imageNamed: "hudCoin")
    private let emptyDiamondTexture = SKTexture(imageNamed: "hudJewel_blue_empty")
    private let collectedDiamondTexture = SKTexture(imageNamed: "hudJewel_blue")
    
    private var hud: SKNode?
    private var coinsCount: Int = 0
    private var diamondsCount: Int = 0
    private var diamondsCollectable: Int = 3
    
    init(parent: SKNode) {
        
        self.hud = SKNode()
        
        self.createCoinsUI()
        self.createDiamondsUI()
        
        parent.addChild(self.hud!)
        
    }
    
    // MARK: Private methods
    
    private func createCoinsUI() {
        // Coins collected
        // Coints count
    }
    
    private func createDiamondsUI() {
        // 3 empty diamonds texture
        // Fill them as the player collect
        
        for i in 0..<self.diamondsCollectable {
            let diamondNode = SKSpriteNode(texture: self.emptyDiamondTexture)
            // change position ...
            print(i)
            self.hud?.addChild(diamondNode)
        }
        
    }
    
    // MARK: Public methods
    
    func collectCoin() {
        
    }
    
    func collectDiamond() {
        
    }
    
}
