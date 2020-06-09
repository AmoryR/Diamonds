//
//  HomeScreen.swift
//  Diamonds
//
//  Created by Amory Rouault on 16/05/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class HomeScreen: SKScene {
    
    override func didMove(to view: SKView) {
        
        // Background
        guard let backgroundNode = self.childNode(withName: "Background") as? SKSpriteNode else {
            fatalError("Can't found background node")
        }
        backgroundNode.texture?.filteringMode = .nearest
        
        // Label
        
        // Play button
        guard let playButtonNode = self.childNode(withName: "PlayButton") as? SKSpriteNode else {
            fatalError("Can't found play button node")
        }
        playButtonNode.texture?.filteringMode = .nearest
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        let frontTouchedNode = atPoint(location).name
        
        if frontTouchedNode == "PlayButton" {
            self.goToMap()
        }
        
    }
    
    private func goToMap() {
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
//            view.showsPhysics = true
        }
    }
    
}
