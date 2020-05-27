//
//  Level5.swift
//  Diamonds
//
//  Created by Amory Rouault on 25/04/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class Level5: GameScene, Level {
    
    private var background: Background?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
 
        self.setPlayerStartingPosition()
        self.setBackground()
        self.setMapPhysics()

    }

    func setPlayerStartingPosition() {
        guard let startPosition = self.childNode(withName: "StartPosition") as? SKSpriteNode else {
            fatalError("No Start Position")
        }
        self.player?.position = startPosition.position
    }
    
    func setBackground() {
        self.backgroundColor = UIColor(red: 208/255, green: 244/255, blue: 247/255, alpha: 1.0)
        self.background = Background(parent: self, imageNamed: "colored_desert")
    }
    
    func setMapPhysics() {
        if let ground = self.childNode(withName: "Ground") as? SKTileMapNode {
            self.giveTileMapPhysicsBody(map: ground)
        }
        
        if let objects = self.childNode(withName: "Objects") as? SKTileMapNode {
            self.giveTileMapPhysicsBody(map: objects)
        }
    }
    
}
