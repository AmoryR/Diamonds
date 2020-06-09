//
//  Map.swift
//  Diamonds
//
//  Created by Amory Rouault on 17/04/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class Map: SKScene {
    
    let initialPosition = CGPoint(x: -1312, y: 320)
    
    var player: MapPlayer!
    var level1Node: SKSpriteNode!
    var level2Node: SKSpriteNode!
    var level3Node: SKSpriteNode!
    var level4Node: SKSpriteNode!
    var level5Node: SKSpriteNode!
    // Start spaceship node
    var startSpaceshipNode: SKSpriteNode!
    // End spaceship node
    var endSpaceshipNode: SKSpriteNode!
    var level6Node: SKSpriteNode!
    
    var spaceshipNode: SKSpriteNode!
    
    var controller: Controller!
    var myCamera: SKCameraNode = SKCameraNode()
    
    static var currentLevel = 0
    static var levelsDone = [
        true, // Initial position
        false,
        false,
        false,
        false,
        false,
        false
    ]
//    static var levelsDone = [
//        true, // Initial position
//        true,
//        true,
//        true,
//        true,
//        true,
//        false
//    ]
//    static var isLevelLocked: [Bool] = [
//        false,
//        false,
//        false,
//        false,
//        false,
//        false,
//        false,
//        false,
//        false,
//        false,
//        false,
//        false,
//        false,
//        false
//    ]
//    static var isLevelLocked: [Bool] = [
//        false,
//        false,
//        true,
//        true,
//        true,
//        true,
//        true,
//        true,
//        true,
//        true
//    ]
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Player
        self.player = self.childNode(withName: "Player") as? MapPlayer
        self.player.parentMap = self
        
        // Camera
        self.myCamera = SKCameraNode()
        self.camera = self.myCamera
        self.player?.addChild(self.myCamera)
        
        // Get levels node
        self.levelsNode()
        self.player.positionAtCurrentLevel()
        
        // Controller
        self.controller = Controller(actor: self.player)
        let buttons = self.controller?.createButtons(frameSize: self.frame.size)

        for button in buttons! {
            self.myCamera.addChild(button)
        }
        
        // Spaceship
        guard let spaceship = self.childNode(withName: "Spaceship") as? SKSpriteNode else {
            fatalError("No spaceship")
        }
        self.spaceshipNode = spaceship
        
        if Map.currentLevel >= 6 {
            self.spaceshipNode.position = self.endSpaceshipNode.position
        } else {
            self.spaceshipNode.position = self.startSpaceshipNode.position
        }
        
//        self.controller.setCommand(button: .A, command: CommandSelect())
        
//        if let isDone = self.userData?.value(forKey: "Level\(Map.currentLevel)") as? String {
//            if isDone == "Done" {
//
//                for i in 1...Map.currentLevel {
//                    if let blockNode = self.childNode(withName: "BlockLevel\(i)") {
//                        blockNode.removeFromParent()
//                    }
//                }
//
//
//                Map.isLevelLocked[Map.currentLevel + 1] = false
//            }
//        }
        
        for (index, levelDone) in Map.levelsDone.enumerated() {
            if (levelDone) {
                if let blockNode = self.childNode(withName: "BlockLevel\(index)") {
                    blockNode.removeFromParent()
                }
            }
        }
        
    }
    
    private func levelsNode() {
        self.level1Node = self.childNode(withName: "Level1Node") as? SKSpriteNode
        self.level2Node = self.childNode(withName: "Level2Node") as? SKSpriteNode
        self.level3Node = self.childNode(withName: "Level3Node") as? SKSpriteNode
        self.level4Node = self.childNode(withName: "Level4Node") as? SKSpriteNode
        self.level5Node = self.childNode(withName: "Level5Node") as? SKSpriteNode
        // Start spaceship
        self.startSpaceshipNode = self.childNode(withName: "StartSpaceship") as? SKSpriteNode
        // End spaceship
        self.endSpaceshipNode = self.childNode(withName: "EndSpaceship") as? SKSpriteNode
        self.level6Node = self.childNode(withName: "Level6Node") as? SKSpriteNode
        
        self.player.levelsPosition.append(self.player.position)
        self.player.levelsPosition.append(self.level1Node.position)
        self.player.levelsPosition.append(self.level2Node.position)
        self.player.levelsPosition.append(self.level3Node.position)
        self.player.levelsPosition.append(self.level4Node.position)
        self.player.levelsPosition.append(self.level5Node.position)
        // Append start
//        self.player.levelsPosition.append(self.startSpaceshipNode.position)
//        // Append end
//        self.player.levelsPosition.append(self.endSpaceshipNode.position)
        self.player.levelsPosition.append(self.level6Node.position)
    }
    
    func presentScene(index: Int) {
        
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks' or 'Level1.sks'
            if let scene = SKScene(fileNamed: "Level\(index)") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
//            view.showsPhysics = true
        }
        
    }
    
//    static func currentLevelDone() {
//        Map.isLevelLocked[Map.currentLevel + 1] = false
//    }
    
    func goHome() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreen")
//        vc.view.frame = rootViewController.view.frame
//        vc.view.layoutIfNeeded()
//        self.view?.window?.rootViewController?.performSegue(withIdentifier: "HomeScreenSegue", sender: GameViewController())
//        self.view?.window?.rootViewController?.present(HomeScreenViewController(), animated: false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.goHome()
        for touch in touches {
            let touchedNode = atPoint(touch.location(in: self))
            self.controller.pressed(buttonName: touchedNode.name!)
        }
    }
    
}
