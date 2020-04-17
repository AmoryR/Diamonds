//
//  MapPlayer.swift
//  Diamonds
//
//  Created by Amory Rouault on 17/04/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class MapPlayer: SKSpriteNode, Actor {
    
    init(texture: SKTexture, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func move(direction: Direction) {
        switch direction {
        case .LEFT:
            print("move left")
            break
        case .RIGHT:
            print("move right")
            break
        }
    }
    
    func select() {
        print("Select level")
    }
    
    func jump() {
        fatalError("Jump from Map Player should not be called")
    }
    
    func climb() {
        fatalError("Climb from Map Player should not be called")
    }

    
}
