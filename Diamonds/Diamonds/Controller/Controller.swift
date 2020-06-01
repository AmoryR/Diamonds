//
//  Controller.swift
//  Diamonds
//
//  Created by Amory Rouault on 20/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class Controller {
    
    enum Button {
        case LEFT
        case RIGHT
        case A
    }
    
    private var actor: Actor
    private var commandes: [Command]
    
    init(actor: Actor) {
        self.actor = actor
        self.commandes = []
        
        self.resetCommands()
    }
    
    func resetCommands() {
        self.commandes = []
        self.commandes.append(CommandLeft())
        self.commandes.append(CommandRight())
        self.commandes.append(CommandA())
    }
    
    func setCommand(button: Button) {
//        switch button {
//        case Button.LEFT:
//            self.commandes[0] = CommandMoveLeft()
//            break
//        case Button.RIGHT:
//            self.commandes[1] = CommandMoveRight()
//            break
//        case Button.A:
//            self.commandes[2] = CommandJump()
//            break
//        }
    }
    
    func setCommand(button: Button, command: Command) {
        switch button {
        case Button.LEFT:
            self.commandes[0] = command
            break
        case Button.RIGHT:
            self.commandes[1] = command
            break
        case Button.A:
            self.commandes[2] = command
            break
        }
    }
    
    func play(button: Button) {
        switch button {
        case Button.LEFT:
            self.commandes[0].execute(actor: self.actor)
            break
        case Button.RIGHT:
            self.commandes[1].execute(actor: self.actor)
            break
        case Button.A:
            self.commandes[2].execute(actor: self.actor)
            break
        }
    }
    
    func pressed(buttonName: String) {
        switch buttonName {
        case "buttonLeft":
            self.play(button: .LEFT)
            break
        case "buttonRight":
            self.play(button: .RIGHT)
            break
        case "buttonA":
            self.play(button: .A)
            break
        default:
            print("No matching button!")
        }
    }
    
    func createButtons(frameSize: CGSize) -> [SKSpriteNode] {
        let buttonScale: CGFloat = 1.5
        let buttonZPosition: CGFloat = 10
        let xOffset: CGFloat = 400
        let yOffset: CGFloat = 200
        let aTexture = SKTexture(imageNamed: "a")
        let leftArrowTexture = SKTexture(imageNamed: "leftArrow")
        let rightArrowTexture = SKTexture(imageNamed: "rightArrow")
        
        let buttonA = SKSpriteNode(texture: aTexture)
        buttonA.name = "buttonA"
        buttonA.position.x = frameSize.width / 2.0 - xOffset
        buttonA.position.y = -yOffset
        buttonA.zPosition = buttonZPosition
        buttonA.setScale(buttonScale)
        
        let buttonLeft = SKSpriteNode(texture: leftArrowTexture)
        buttonLeft.name = "buttonLeft"
        buttonLeft.position.x = -frameSize.width / 2.0 + xOffset
        buttonLeft.position.y = -yOffset
        buttonLeft.zPosition = buttonZPosition
        buttonLeft.setScale(buttonScale)
        
        let buttonRight = SKSpriteNode(texture: rightArrowTexture)
        buttonRight.name = "buttonRight"
        buttonRight.position.x = -frameSize.width / 2.0 + xOffset + leftArrowTexture.size().width + 100
        buttonRight.position.y = -yOffset
        buttonRight.zPosition = buttonZPosition
        buttonRight.setScale(buttonScale)
        
        return [buttonA, buttonLeft, buttonRight]
    }
    
}
