//
//  Level2.swift
//  Diamonds
//
//  Created by Amory Rouault on 25/04/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class Level2: GameScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Player
        self.player?.position = CGPoint(x: -3860, y: -240) // Level 2 start position
        
        // Map
        if let ground = self.childNode(withName: "Ground") as? SKTileMapNode {
            self.giveTileMapPhysicsBody(map: ground)
        }
        
        if let objects = self.childNode(withName: "Objects") as? SKTileMapNode {
            self.giveTileMapPhysicsBody(map: objects)
        }

    }
    
}
