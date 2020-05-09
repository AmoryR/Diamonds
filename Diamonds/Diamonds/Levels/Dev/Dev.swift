//
//  Dev.swift
//  Diamonds
//
//  Created by Amory Rouault on 09/05/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class Dev: SKScene {
    
    var player: Player?
    
    override func didMove(to view: SKView) {
        
        guard let map = self.childNode(withName: "Ground") as? SKTileMapNode else {
            print("No map")
            return
        }
        
        self.giveTileMapPhysicsBody(map: map)
    }

    func giveTileMapPhysicsBody(map: SKTileMapNode) {
        let tileMap = map
        
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row) {
                    
                    if let _ = tileDefinition.userData?.value(forKey: "edgeTile") {
                        let tileTexture = tileDefinition.textures[0]
                        let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                        let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                        
                        let tileNode = SKNode()
                        tileNode.position = CGPoint(x: x, y: y)
                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: tileTexture.size())
                        tileNode.physicsBody?.affectedByGravity = false
                        tileNode.physicsBody?.allowsRotation = false
                        tileNode.physicsBody?.restitution = 0.0
                        tileNode.physicsBody?.isDynamic = false
                        
                        tileNode.physicsBody?.categoryBitMask = 0x1
                        
                        tileMap.addChild(tileNode)
                    }
                    
                }
            }
        }
    }
}
