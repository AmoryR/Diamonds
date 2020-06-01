//
//  Command.swift
//  Diamonds
//
//  Created by Amory Rouault on 20/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import Foundation

protocol Command {
    func execute(actor: Actor)
}

class CommandRight: Command {
    init() {}
    
    func execute(actor: Actor) {
        actor.commandRightCallback()
    }
}

class CommandLeft: Command {
    init() {}
    
    func execute(actor: Actor) {
        actor.commandLeftCallback()
    }
}

class CommandA: Command {
    init() {}
    
    func execute(actor: Actor) {
        actor.commandACallback()
    }
}
