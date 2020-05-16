//
//  Level1.swift
//  Diamonds
//
//  Created by Amory Rouault on 22/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class Level1: GameScene, Level {
    
    
    
    private var background: Background?
    private var isBackgroundMoving = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Player
        
        self.setPlayerStartingPosition()
        
        
        // Background
        self.backgroundColor = UIColor(red: 208/255, green: 244/255, blue: 247/255, alpha: 1.0)
        self.background = Background(parent: self, imageNamed: "colored_land")
    }
    
    func setPlayerStartingPosition() {
        guard let startPosition = self.childNode(withName: "StartPosition") as? SKSpriteNode else {
            fatalError("No Start Position")
        }
        self.player?.position = startPosition.position
    }
    
    func setBackground() {
        
    }
    
    func setMapPhysics() {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Parallax effect
        if self.player?.action(forKey: PlayerActionsKeys.MOVE_LEFT.rawValue) != nil && self.isBackgroundMoving == false {
            self.background!.move(direction: .RIGHT)
            self.isBackgroundMoving = true
            
        } else if self.player?.action(forKey: PlayerActionsKeys.MOVE_RIGHT.rawValue) != nil && self.isBackgroundMoving == false {
            self.background!.move(direction: .LEFT)
            self.isBackgroundMoving = true
            
        } else if self.player?.action(forKey: PlayerActionsKeys.MOVE_LEFT.rawValue) == nil && self.player?.action(forKey: PlayerActionsKeys.MOVE_RIGHT.rawValue) == nil && self.isBackgroundMoving == true {
            self.background!.stop()
            self.isBackgroundMoving = false
            
        }
    }
    
}
