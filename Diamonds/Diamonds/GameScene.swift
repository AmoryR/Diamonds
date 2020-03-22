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
    var myCamera: SKCameraNode = SKCameraNode()
    
    override func didMove(to view: SKView) {
        self.player = self.childNode(withName: "Player") as? Player
        
        self.myCamera = SKCameraNode()
        self.camera = self.myCamera
        
        self.player?.addChild(self.myCamera)
        
        self.controller = Controller(actor: self.player!)
            let buttons = self.controller?.createButtons()
            
            for button in buttons! {
                self.myCamera.addChild(button)
        }
    }
    
    var buttonPressed: String = ""
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchedNode = atPoint(touch.location(in: self))
            self.controller!.pressed(buttonName: touchedNode.name!)
            self.buttonPressed = touchedNode.name!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.player!.stop(actionKey: .)
//        self.player!.removeAllActions()
        
        switch self.buttonPressed {
        case "buttonLeft":
            self.player?.stop(actionKey: .MOVE_LEFT)
            self.player?.stop(actionKey: .ANIMATE_LEFT)
            break
        case "buttonRight":
            self.player?.stop(actionKey: .MOVE_RIGHT)
            self.player?.stop(actionKey: .ANIMATE_RIGHT)
            break
        case "buttonA":
            
            break
        default:
            print("No matching button!")
        }
        
        self.buttonPressed = ""
        self.player!.texture = SKTexture(imageNamed: "alienGreen_front")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}
