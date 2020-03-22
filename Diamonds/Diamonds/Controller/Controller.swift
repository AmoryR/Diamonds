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
        case JUMP
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
        self.commandes.append(CommandMoveLeft())
        self.commandes.append(CommandMoveRight())
        self.commandes.append(CommandJump())
    }
    
    func setCommand(button: Button) {
        switch button {
        case Button.LEFT:
            self.commandes[0] = CommandMoveLeft()
            break
        case Button.RIGHT:
            self.commandes[1] = CommandMoveRight()
            break
        case Button.JUMP:
            self.commandes[2] = CommandJump()
            break
        }
    }
    
    func setCommand(button: Button, command: Command) {
        switch button {
        case Button.LEFT:
            self.commandes[0] = command
            break
        case Button.RIGHT:
            self.commandes[1] = command
            break
        case Button.JUMP:
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
        case Button.JUMP:
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
            self.play(button: .JUMP)
            break
        default:
            print("No matching button!")
        }
    }
    
    func createButtons() -> [SKSpriteNode] {
        let aTexture = SKTexture(imageNamed: "a")
        let leftArrowTexture = SKTexture(imageNamed: "leftArrow")
        let rightArrowTexture = SKTexture(imageNamed: "rightArrow")
        
        let buttonA = SKSpriteNode(texture: aTexture)
        buttonA.name = "buttonA"
        buttonA.position.x = 200
        buttonA.zPosition = 10
        
        let buttonLeft = SKSpriteNode(texture: leftArrowTexture)
        buttonLeft.name = "buttonLeft"
        buttonLeft.position.x = -200
        buttonLeft.zPosition = 10
        
        let buttonRight = SKSpriteNode(texture: rightArrowTexture)
        buttonRight.name = "buttonRight"
        buttonRight.position.x = 0
        buttonRight.zPosition = 10
        
        return [buttonA, buttonLeft, buttonRight]
    }
    
}
