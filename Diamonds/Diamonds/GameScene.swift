//
//  GameScene.swift
//  Diamonds
//
//  Created by Amory Rouault on 20/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player?
    var controller: Controller?
    var myCamera: SKCameraNode = SKCameraNode()
    var buttonsPressed: [String] = []
    var coinsLabel: SKLabelNode?
    var coinsCollected: Int = 0
    var diamondsCollected: Int = 0
    
    override func didMove(to view: SKView) {
        
        // Player
        let playerTexture = SKTexture(imageNamed: "alienGreen_front")
        self.player = Player(texture: playerTexture, color: .red, size: playerTexture.size())
        self.addChild(self.player!)
        
        // Camera
        self.myCamera = SKCameraNode()
        self.camera = self.myCamera
        
        self.player?.addChild(self.myCamera)
        
        // Controller
        self.controller = Controller(actor: self.player!)
        let buttons = self.controller?.createButtons(frameSize: self.frame.size)
        
        for button in buttons! {
            self.myCamera.addChild(button)
        }
        
        // UI
        self.coinsLabel = SKLabelNode(text: "\(self.coinsCollected)")
        self.coinsLabel?.fontColor = .black
        self.coinsLabel?.fontSize = 58
        self.coinsLabel?.position = CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height)
        self.coinsLabel?.zPosition = 100
        self.myCamera.addChild(self.coinsLabel!)
        
        self.physicsWorld.contactDelegate = self
        
    }
    
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
        
            if self.player?.state == PlayerState.NORMAL {
                self.player!.texture = SKTexture(imageNamed: "alienGreen_front")
            } else if self.player?.state == PlayerState.CLIMBING {
                self.player?.stop(actionKey: .CLIMB)
                self.player?.stop(actionKey: .ANIMATE_CLIMB)
            }
            
            break
        default:
            print("No matching button!")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // First method called before each frame is rendered
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Contact with a diamond
        if contact.bodyA.node?.name == "Diamond" || contact.bodyB.node?.name == "Diamond" {
            
            if contact.bodyA.node?.name == "Diamond" {
                contact.bodyA.node?.removeFromParent()
            }
            else {
                contact.bodyB.node?.removeFromParent()
            }
            self.diamondsCollected += 1
        }
        
        // Contact with a coin
        if contact.bodyA.node?.name == "Coin" || contact.bodyB.node?.name == "Coin" {
            
            if contact.bodyA.node?.name == "Coin" {
                contact.bodyA.node?.removeFromParent()
            }
            else {
                contact.bodyB.node?.removeFromParent()
            }
            self.coinsCollected += 1
            self.coinsLabel?.text = "\(self.coinsCollected)"
        }
        
        // Contact with a ladder
        if contact.bodyA.node?.name == "LadderBox" || contact.bodyB.node?.name == "LadderBox" {
            print("contact with ladder")
            
            self.physicsWorld.gravity = .zero
            self.player?.setState(state: .CLIMBING)
            self.controller?.setCommand(button: .A, command: CommandClimb())
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        self.player?.landFromJump()
        
        // End contact with a ladder
        if contact.bodyA.node?.name == "LadderBox" || contact.bodyB.node?.name == "LadderBox" {
            print("End contact with ladder")
            
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
            self.player?.stop(actionKey: .CLIMB)
            self.player?.stop(actionKey: .ANIMATE_CLIMB)
            self.player!.texture = SKTexture(imageNamed: "alienGreen_front")
            self.player?.setState(state: .NORMAL)
            self.controller?.setCommand(button: .A, command: CommandJump())
        }
    }

}
