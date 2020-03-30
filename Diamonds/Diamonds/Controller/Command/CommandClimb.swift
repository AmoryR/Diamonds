//
//  CommandClimb.swift
//  Diamonds
//
//  Created by Amory Rouault on 30/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import Foundation

class CommandClimb: Command {
    init() {}
    
    func execute(actor: Actor) {
        actor.climb()
    }
}
