//
//  MapPlayer.swift
//  Diamonds
//
//  Created by Amory Rouault on 17/04/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class MapPlayer: SKSpriteNode, Actor {
    
    var parentMap: Map?
    var previousLevelIndex = 0
    var currentLevel = 0
    public var levelsPosition: [CGPoint] = []
    
    init(texture: SKTexture, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func nextLevel() {
        self.currentLevel += 1
    }
    
    private func previousLevel() {
        if self.currentLevel > 0 {
            self.currentLevel -= 1
        }
    }
    
    private func moveToCurrentLevel() {
        if self.currentLevel >= self.levelsPosition.count {
            return
        }
        
        self.run(getMoveAction())
    }
    
    private func getMoveAction() -> SKAction {
        
        // Forward
        if self.currentLevel - self.previousLevelIndex > 0 {
            
            switch self.currentLevel {
            case 0, 1, 2, 5:
                // Compute duration
                return SKAction.move(to: self.levelsPosition[self.currentLevel], duration: 1)
            case 3:
                // Compute duration
                return SKAction.sequence([
                    SKAction.move(to: CGPoint(x: self.levelsPosition[self.currentLevel].x, y: self.position.y), duration: 0.5),
                    SKAction.move(to: self.levelsPosition[self.currentLevel], duration: 0.5)
                ])
            case 4:
                // Compute duration
                return SKAction.sequence([
                    SKAction.move(to: CGPoint(x: self.position.x, y: self.levelsPosition[self.currentLevel].y), duration: 0.5),
                    SKAction.move(to: self.levelsPosition[self.currentLevel], duration: 0.5)
                ])
            default:
                return SKAction.move(to: self.position, duration: 0)
            }
        
        // Backward
        } else {
            
            switch self.currentLevel {
            case 0, 1, 4, 5:
                // Compute duration
                return SKAction.move(to: self.levelsPosition[self.currentLevel], duration: 1)
            case 3:
                // Compute duration
                return SKAction.sequence([
                    SKAction.move(to: CGPoint(x: self.levelsPosition[self.currentLevel].x, y: self.position.y), duration: 0.5),
                    SKAction.move(to: self.levelsPosition[self.currentLevel], duration: 0.5)
                ])
            case 2:
                // Compute duration
                return SKAction.sequence([
                    SKAction.move(to: CGPoint(x: self.position.x, y: self.levelsPosition[self.currentLevel].y), duration: 0.5),
                    SKAction.move(to: self.levelsPosition[self.currentLevel], duration: 0.5)
                ])
            default:
                return SKAction.move(to: self.position, duration: 0)
            }
            
        }
        
    }
    
    func move(direction: Direction) {
        self.previousLevelIndex = self.currentLevel
        
        switch direction {
        case .LEFT:
            self.previousLevel()
            break
        case .RIGHT:
            self.nextLevel()
            break
        }
        
        self.moveToCurrentLevel()
        
    }
    
    func select() {
        
        if (self.currentLevel > 0) {
            self.parentMap?.presentScene(index: self.currentLevel)
        }
        
    }
    
    func jump() {
        fatalError("Jump from Map Player should not be called")
    }
    
    func climb() {
        fatalError("Climb from Map Player should not be called")
    }

    
}
