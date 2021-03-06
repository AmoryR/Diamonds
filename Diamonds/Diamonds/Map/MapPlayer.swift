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
//        self.currentLevel += 1
        Map.currentLevel += 1
    }
    
    private func previousLevel() {
        if Map.currentLevel > 0 {
//            self.currentLevel -= 1
            Map.currentLevel -= 1
        }
    }
    
    private func moveToCurrentLevel() {
        if Map.currentLevel >= self.levelsPosition.count {
            return
        }
        
        self.run(getMoveAction())
    }
    
    private func getMoveAction() -> SKAction {
        
        // Forward
        if Map.currentLevel - self.previousLevelIndex > 0 {
            
            switch Map.currentLevel {
            case 0, 1, 2, 5:
                // Compute duration
                return SKAction.move(to: self.levelsPosition[Map.currentLevel], duration: 1)
            case 3:
                // Compute duration
                return SKAction.sequence([
                    SKAction.move(to: CGPoint(x: self.levelsPosition[Map.currentLevel].x, y: self.position.y), duration: 0.5),
                    SKAction.move(to: self.levelsPosition[Map.currentLevel], duration: 0.5)
                ])
            case 4:
                // Compute duration
                return SKAction.sequence([
                    SKAction.move(to: CGPoint(x: self.position.x, y: self.levelsPosition[Map.currentLevel].y), duration: 0.5),
                    SKAction.move(to: self.levelsPosition[Map.currentLevel], duration: 0.5)
                ])
            case 6:
                return self.actionForPlanet()
            default:
                return SKAction.move(to: self.position, duration: 0)
            }
        
        // Backward
        } else {
            
            switch Map.currentLevel {
            case 0, 1, 4:
                // Compute duration
                return SKAction.move(to: self.levelsPosition[Map.currentLevel], duration: 1)
            case 3:
                // Compute duration
                return SKAction.sequence([
                    SKAction.move(to: CGPoint(x: self.levelsPosition[Map.currentLevel].x, y: self.position.y), duration: 0.5),
                    SKAction.move(to: self.levelsPosition[Map.currentLevel], duration: 0.5)
                ])
            case 2:
                // Compute duration
                return SKAction.sequence([
                    SKAction.move(to: CGPoint(x: self.position.x, y: self.levelsPosition[Map.currentLevel].y), duration: 0.5),
                    SKAction.move(to: self.levelsPosition[Map.currentLevel], duration: 0.5)
                ])
            case 5:
                return self.actionForEarth()
            default:
                return SKAction.move(to: self.position, duration: 0)
            }
            
        }
        
    }
    
    func actionForPlanet() -> SKAction {
        
        guard let startSpaceshipPosition = self.parentMap?.startSpaceshipNode.position else { fatalError("No start position") }
        guard let endSpaceshipPosition = self.parentMap?.endSpaceshipNode.position else { fatalError("No end position") }
        
        let step1 = SKAction.move(to: startSpaceshipPosition, duration: 1)
        let goToSpaceshipAction = SKAction.run {
            self.parentMap!.spaceshipNode.move(toParent: self)
        }
        // Ready to take off
        let step2 = SKAction.move(to: endSpaceshipPosition, duration: 3)
        // Ready to land
        let step3 = SKAction.move(to: self.levelsPosition[Map.currentLevel], duration: 1)
        let leaveSpaceshipAction = SKAction.run {
            guard let spaceship = self.childNode(withName: "Spaceship") as? SKSpriteNode else {
                fatalError("No spaceship move to player")
            }
            spaceship.move(toParent: self.parentMap!)
        }
        return SKAction.sequence([step1, goToSpaceshipAction, step2, leaveSpaceshipAction, step3])
    }
    
    func actionForEarth() -> SKAction {
        guard let startSpaceshipPosition = self.parentMap?.startSpaceshipNode.position else { fatalError("No start position") }
        guard let endSpaceshipPosition = self.parentMap?.endSpaceshipNode.position else { fatalError("No end position") }
        
        let step1 = SKAction.move(to: endSpaceshipPosition, duration: 1)
        let goToSpaceshipAction = SKAction.run {
            self.parentMap!.spaceshipNode.move(toParent: self)
        }
        let step2 = SKAction.move(to: startSpaceshipPosition, duration: 3)
        let leaveSpaceshipAction = SKAction.run {
            guard let spaceship = self.childNode(withName: "Spaceship") as? SKSpriteNode else {
                fatalError("No spaceship move to player")
            }
            spaceship.move(toParent: self.parentMap!)
        }
        let step3 = SKAction.move(to: self.levelsPosition[Map.currentLevel], duration: 1)
        
        return SKAction.sequence([step1, goToSpaceshipAction, step2, leaveSpaceshipAction, step3])
    }
    
    // MARK: Command callback
    
    func commandRightCallback() {
        
        if self.hasActions() {
            return
        }
        
        self.move(direction: .RIGHT)
    }
    
    func commandLeftCallback() {
        
        if self.hasActions() {
            return
        }
        
        self.move(direction: .LEFT)
    }
    
    func commandACallback() {
        
        if self.hasActions() {
            return
        }
        
        self.select()
    }
    
    func move(direction: Direction) {

        self.previousLevelIndex = Map.currentLevel

        // Assert
        switch direction {
        case .LEFT:
            var nextLevel: Int = 0
            if (Map.currentLevel > 0) {
                nextLevel = Map.currentLevel - 1
            } else {
                nextLevel = Map.currentLevel
            }

            let isLocked: Bool = !Map.levelsDone[nextLevel]
//            let isLocked = Map.isLevelLocked[nextLevel]

            if isLocked {
                print("lock")
                return
            }

            break
        case .RIGHT:
            let isLocked: Bool = !Map.levelsDone[Map.currentLevel]

            if isLocked {
                print("lock")
                return
            }

            break
        }

        // Move
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
    
    func positionAtCurrentLevel() {
        self.position = self.levelsPosition[Map.currentLevel]
    }
    
    func select() {

        if (Map.currentLevel > 0) {
            self.parentMap?.presentScene(index: Map.currentLevel)
        }

    }
//
//    func jump() {
//        fatalError("Jump from Map Player should not be called")
//    }
//
//    func climb() {
//        fatalError("Climb from Map Player should not be called")
//    }

    
}
