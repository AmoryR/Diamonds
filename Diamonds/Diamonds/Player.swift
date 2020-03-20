//
//  Player.swift
//  Diamonds
//
//  Created by Amory Rouault on 20/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode, Actor {
    
    init(texture: SKTexture, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // Because the player comes from GameScene
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func move(direction: Direction) {
        print("Move : \(direction)")
    }
    
    func jump() {
        print("Jump")
    }
    

}
