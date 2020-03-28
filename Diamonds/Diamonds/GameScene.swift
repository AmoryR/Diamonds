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
//        self.player = self.childNode(withName: "Player") as? Player
        let playerTexture = SKTexture(imageNamed: "alienGreen_front")
        self.player = Player(texture: playerTexture, color: .red, size: playerTexture.size())
//        self.player?.position = CGPoint(x: -3860, y: 0)
        self.player?.position.x = -1500
        self.addChild(self.player!)
        
        self.myCamera = SKCameraNode()
        self.camera = self.myCamera
        
        self.player?.addChild(self.myCamera)
        
        self.controller = Controller(actor: self.player!)
        let buttons = self.controller?.createButtons(frameSize: self.frame.size)
        
        for button in buttons! {
            self.myCamera.addChild(button)
        }
    }

    var buttonsPressed: [String] = []
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchedNode = atPoint(touch.location(in: self))
            self.controller!.pressed(buttonName: touchedNode.name!)
            self.buttonsPressed.append(touchedNode.name!)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        switch self.buttonsPressed.last {
        case "buttonLeft":
            self.player?.stop(actionKey: .MOVE_LEFT)
            self.player?.stop(actionKey: .ANIMATE_LEFT)
            
            self.buttonsPressed.remove(at: self.buttonsPressed.count - 1)
            self.player!.texture = SKTexture(imageNamed: "alienGreen_front")
            break
        case "buttonRight":
            self.player?.stop(actionKey: .MOVE_RIGHT)
            self.player?.stop(actionKey: .ANIMATE_RIGHT)

            self.buttonsPressed.remove(at: self.buttonsPressed.count - 1)
            self.player!.texture = SKTexture(imageNamed: "alienGreen_front")
            break
        case "buttonA":

            self.buttonsPressed.remove(at: self.buttonsPressed.count - 1)
            self.player!.texture = SKTexture(imageNamed: "alienGreen_front")
            break
        default:
            print("No matching button!")
            self.player?.removeAllActions()
            self.player!.texture = SKTexture(imageNamed: "alienGreen_front")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}
