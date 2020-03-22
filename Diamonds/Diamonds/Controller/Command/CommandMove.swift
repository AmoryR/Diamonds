//
//  CommandMove.swift
//  Diamonds
//
//  Created by Amory Rouault on 20/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import Foundation

class CommandMoveLeft: Command {
    init() {}
    
    func execute(actor: Actor) {
        actor.move(direction: .LEFT)
    }
}

class CommandMoveRight: Command {
    init() {}
    
    func execute(actor: Actor) {
        actor.move(direction: .RIGHT)
    }
}
