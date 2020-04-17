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
    var controller: Controller!
    var myCamera: SKCameraNode = SKCameraNode()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Player
        self.player = self.childNode(withName: "Player") as? MapPlayer
        
        // Camera
        self.myCamera = SKCameraNode()
        self.camera = self.myCamera
        self.player?.addChild(self.myCamera)
        
        // Get levels node
        self.levelsNode()
        
        // Controller
        self.controller = Controller(actor: self.player)
        let buttons = self.controller?.createButtons(frameSize: self.frame.size)

        for button in buttons! {
            self.myCamera.addChild(button)
        }
        
        self.controller.setCommand(button: .A, command: CommandSelect())
        
    }
    
    private func levelsNode() {
        self.level1Node = self.childNode(withName: "Level1Node") as? SKSpriteNode
        self.level2Node = self.childNode(withName: "Level2Node") as? SKSpriteNode
        self.level3Node = self.childNode(withName: "Level3Node") as? SKSpriteNode
        self.level4Node = self.childNode(withName: "Level4Node") as? SKSpriteNode
        self.level5Node = self.childNode(withName: "Level5Node") as? SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchedNode = atPoint(touch.location(in: self))
            self.controller.pressed(buttonName: touchedNode.name!)
        }
    }
    
}
