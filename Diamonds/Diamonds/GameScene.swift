//
//  GameScene.swift
//  Diamonds
//
//  Created by Amory Rouault on 20/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: Player?
    var controller: Controller?
    
    override func didMove(to view: SKView) {
        self.player = self.childNode(withName: "Player") as? Player
        
        print(self.player!)
        
        self.controller = Controller(actor: self.player!)
        let buttons = self.controller?.createButtons()
        
        for button in buttons! {
//            self.scene?.camera?.addChild(button)
            self.addChild(button)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchedNode = atPoint((touches.first?.location(in: self))!)
        self.controller!.pressed(buttonName: touchedNode.name!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
