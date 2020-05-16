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
    var hud: HUD?
    var myCamera: SKCameraNode = SKCameraNode()
    var buttonsPressed: [String] = []
 
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
        self.hud = HUD(parent: self.myCamera)
        
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
        
        // Flag
        if contact.bodyA.node?.name == "Flag" || contact.bodyB.node?.name == "Flag" {
            
            // 1. Show coins and diamonds collected
            // 2. Button to go back to map
            
            self.goToMap()
            return
        }
        
        // Contact with a diamond
        if contact.bodyA.node?.name == "Diamond" || contact.bodyB.node?.name == "Diamond" {
            
            if contact.bodyA.node?.name == "Diamond" {
                contact.bodyA.node?.removeFromParent()
            }
            else {
                contact.bodyB.node?.removeFromParent()
            }
            self.hud?.collectDiamond()
        }
        
        // Contact with a coin
        if contact.bodyA.node?.name == "Coin" || contact.bodyB.node?.name == "Coin" {
            
            if contact.bodyA.node?.name == "Coin" {
                contact.bodyA.node?.removeFromParent()
            }
            else {
                contact.bodyB.node?.removeFromParent()
            }
            self.hud?.collectCoin()
        }
        
        // Coin box
        if contact.bodyA.node?.name == "CoinBox" || contact.bodyB.node?.name == "CoinBox" {
            
            let coinBox = contact.bodyA.node as? CoinBox
            if coinBox!.hit() {
                self.hud?.collectCoin()
            }
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
    
    func goToMap() {
        if let view = self.view {
            // Load the SKScene from 'Map.sks'
            if let scene = SKScene(fileNamed: "Map") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }


}
