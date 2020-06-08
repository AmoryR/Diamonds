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
    
    private var numberTexture = SKTexture(imageNamed: "hud0")
    private let coinTexture = SKTexture(imageNamed: "hudCoin")
    private let emptyDiamondTexture = SKTexture(imageNamed: "hudJewel_blue_empty")
    private let collectedDiamondTexture = SKTexture(imageNamed: "hudJewel_blue")
    
    private var hud: SKNode?
    private var coinsCount: Int = 0
    private var diamondsCount: Int = 0
    private var diamondsCollectable: Int = 3
    
    init(parent: SKNode) {
        
        self.hud = SKNode()
        self.hud?.zPosition = 100
        
        self.createCoinsUI()
        self.createDiamondsUI()
        
        self.hud?.position.x = UIScreen.main.bounds.width - self.hud!.calculateAccumulatedFrame().width
        self.hud?.position.y = UIScreen.main.bounds.height
        self.hud?.setScale(0.9)
        
        parent.addChild(self.hud!)
        
    }
    
    // MARK: Private methods
    
    private func createCoinsUI() {
        // Coins collected
        let coinsCollectedNode = SKSpriteNode(texture: self.numberTexture)
        coinsCollectedNode.name = "CoinsCollectedNode"
        self.hud?.addChild(coinsCollectedNode)
        
        // Coints number
        let coinNode = SKSpriteNode(texture: self.coinTexture)
        coinNode.position.x = self.numberTexture.size().width * 0.7
        self.hud?.addChild(coinNode)
    }
    
    private func createDiamondsUI() {
        let offset = self.numberTexture.size().width + self.coinTexture.size().width
        
        // Diamonds
        for i in 0..<self.diamondsCollectable {
            let diamondNode = SKSpriteNode(texture: self.emptyDiamondTexture)
            diamondNode.name = "diamond\(i)"
            diamondNode.position.x = CGFloat(i) * self.emptyDiamondTexture.size().width + offset
            self.hud?.addChild(diamondNode)
        }
    }
    
    // MARK: Public methods
    
    func collectCoin() {
        if self.coinsCount >= 9 {
            return
        }
        
        self.coinsCount += 1
        self.numberTexture = SKTexture(imageNamed: "hud\(self.coinsCount)")
        let node = self.hud?.childNode(withName: "CoinsCollectedNode") as? SKSpriteNode
        node?.texture = self.numberTexture
    }
    
    func collectDiamond() {
        if self.diamondsCount >= self.diamondsCollectable {
            return
        }
        
        self.diamondsCount += 1
        let node = self.hud?.childNode(withName: "diamond\(self.diamondsCount - 1)") as? SKSpriteNode
        node?.texture = self.collectedDiamondTexture
    }
    
    func remove() {
        self.hud?.removeFromParent()
    }
    
}
