//
//  GameScene.swift
//  Diamonds
//
//  Created by Amory Rouault on 20/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameSceneState {
    case PLAYING
    case ENDED
    case LOST
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player?
    var controller: Controller?
    var hud: HUD?
    var myCamera: SKCameraNode = SKCameraNode()
    var buttonsPressed: [String] = []
    
    
    let endTitle = SKLabelNode(text: "Well Done!")
    let endSubTitle = SKLabelNode(text: "Tap the screen to return to the map")
    
    var firework = Firework()
    
    var currentState: GameSceneState = .PLAYING
 
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
        
        self.player?.addChild(self.firework)
        self.currentState = .PLAYING
        
        self.endTitle.fontSize = 48
        self.endTitle.fontColor = .black
        self.endTitle.fontName = "AvenirNext-Bold"
        self.endTitle.position.y = 300
        self.endTitle.zPosition = 10
        
        self.endSubTitle.fontSize = 32
        self.endSubTitle.fontColor = .black
        self.endSubTitle.fontName = "AvenirNext-Bold"
        self.endSubTitle.position.y = 250
        self.endSubTitle.zPosition = 10
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.currentState == .ENDED {
            self.firework.stopFirework()
            self.endTitle.removeFromParent()
            self.endSubTitle.removeFromParent()
//            self.goToMap()
            return
        } else if self.currentState == .LOST {
            self.goToMap()
            return
        }
        
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
            
//            self.buttonsPressed.remove(at: self.buttonsPressed.count - 1)
//
//            if self.player?.state == PlayerState.NORMAL {
//                self.player!.texture = SKTexture(imageNamed: "alienGreen_front")
//            } else if self.player?.state == PlayerState.CLIMBING {
//                self.player?.stop(actionKey: .CLIMB)
//                self.player?.stop(actionKey: .ANIMATE_CLIMB)
//            }

            break
        default:
            print("No matching button!")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // First method called before each frame is rendered
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
//        print("contact")
        
        // Box
        if contact.bodyA.node?.name == "Box" || contact.bodyB.node?.name == "Box" {
            self.player?.isJumping = false
        }
        
        // Flag
        if contact.bodyA.node?.name == "Flag" || contact.bodyB.node?.name == "Flag" {
            
            // Unlock next level
            // 1. Show coins and diamonds collected
            // 2. Button to go back to map
//            Map.currentLevelDone()
//            self.levelEnded()
            // firework animation + text ...
            self.levelEndedAnimations()
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
            
            if CGFloat(self.player!.position.y) > CGFloat(contact.bodyA.node!.position.y) {
                return
            }
            
            let coinBox = contact.bodyA.node as? CoinBox
            if coinBox!.hit() {
                self.hud?.collectCoin()
            }
        }

        
        // Contact with a ladder
        if contact.bodyA.node?.name == "LadderBox" || contact.bodyB.node?.name == "LadderBox" {
//            print("contact with ladder")
            
//            self.physicsWorld.gravity = .zero // Trick so that the animation works
            self.player?.currentLadderBox = contact.bodyA.node! as? SKSpriteNode
            self.player?.setState(state: .CLIMBING)
//            print(contact.bodyA.node?.position)
//            self.controller?.setCommand(button: .A, command: CommandClimb())
        }
        
        // ONLY WORKS ON LEVEL 6
        
        // Teleporter
        if contact.bodyA.node?.name == "TeleporterEntrance1" ||
            contact.bodyB.node?.name == "TeleporterEntrance1" {
//            if let exit = self.childNode(withName: "TeleporterExit1") as? SKSpriteNode{
//                print(exit.position)
//            } else {
//                print("no exit 1")
//            }
            self.player?.teleportEntrancePosition = contact.bodyA.node?.position
            self.player?.teleportExitPosition = CGPoint(x: -576, y: 740)
            self.player?.setState(state: .TELEPORT)
            
        }
        
        if contact.bodyA.node?.name == "TeleporterEntrance2" ||
           contact.bodyB.node?.name == "TeleporterEntrance2" {
           
           self.player?.teleportEntrancePosition = contact.bodyA.node?.position
           self.player?.teleportExitPosition = CGPoint(x: 3012, y: 740)
           self.player?.setState(state: .TELEPORT)
           
       }

        
        
//        if (contact.bodyA.node?.name?.contains("TeleporterEntrance"))! || (contact.bodyB.node?.name!.contains("TeleporterEntrance"))! {
//            
//            print("Contact with teleporter entrance")
//            
//        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
//        self.player?.landFromJump()
//        self.player?.isJumping = false
        
        
//        // End contact with a ladder
        if contact.bodyA.node?.name == "LadderBox" || contact.bodyB.node?.name == "LadderBox" {
//            print("End contact with ladder")
            self.player?.setState(state: .NORMAL)
            
            if self.player!.isClimbing {
//                self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8) // Reset trick
                
//                self.player?.stop(actionKey: .CLIMB)
//                self.player?.stop(actionKey: .ANIMATE_CLIMB)
//                self.player!.texture = SKTexture(imageNamed: "alienGreen_front")
//                self.player?.setState(state: .NORMAL)
//                self.player?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//                self.player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
//                
//                self.player?.isClimbing = false
//                self.player?.physicsBody?.affectedByGravity = true
            }
            
            // Find a way to reset gravity but block player on top of ladder
        }
        
        if contact.bodyA.node?.name == "TeleporterEntrance1" ||
        contact.bodyB.node?.name == "TeleporterEntrance1" {
            self.player?.setState(state: .NORMAL)
        }
        
        if contact.bodyA.node?.name == "TeleporterEntrance2" ||
        contact.bodyB.node?.name == "TeleporterEntrance2" {
            self.player?.setState(state: .NORMAL)
        }
        
        if contact.bodyA.node?.name == "LostBox" ||
        contact.bodyB.node?.name == "LostBox" {
            self.currentState = .LOST
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
                        tileNode.name = "Box"
                        tileNode.position = CGPoint(x: x, y: y)
                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: tileTexture.size())
                        tileNode.physicsBody?.affectedByGravity = false
                        tileNode.physicsBody?.allowsRotation = false
                        tileNode.physicsBody?.restitution = 0.0
                        tileNode.physicsBody?.isDynamic = false
                        
                        tileNode.physicsBody?.categoryBitMask = 0x1
                        
                        tileMap.addChild(tileNode)
                    }
                    
                    // May give problem with water ...
                    if let _ = tileDefinition.userData?.value(forKey: "lostTile") {
                        let tileTexture = tileDefinition.textures[0]
                        let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                        let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                        
                        let tileNode = SKNode()
                        tileNode.name = "LostBox"
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
    
    func levelEndedAnimations() {
        self.currentState = .ENDED
        
        
        self.firework.startFirework()
        self.hud!.remove()
        
        self.player?.addChild(self.endTitle)
        self.player?.addChild(self.endSubTitle)
    }
    
    func levelEnded() {
//        if Map.currentLevel < 6 {
//            self.goToMap()
//        } else {
//            self.goToHome()
//        }
        self.goToMap()
    }
    
    func goToHome() {
        if let view = self.view {
            // Load the SKScene from 'Map.sks'
            if let scene = SKScene(fileNamed: "HomeScreen") {
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
    
    func goToMap() {
        
        if let view = self.view {
            // Load the SKScene from 'Map.sks'
            if let scene = SKScene(fileNamed: "Map") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill

//                if scene.userData == nil {
//                    scene.userData = NSMutableDictionary(capacity: 1)
//                }
//                scene.userData?.setValue("Done", forKey: "Level\(Map.currentLevel)")
                Map.levelsDone[Map.currentLevel] = true
                
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
