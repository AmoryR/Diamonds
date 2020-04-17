//
//  CommandSelect.swift
//  Diamonds
//
//  Created by Amory Rouault on 17/04/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import Foundation

class CommandSelect: Command {
    init() {}
    
    func execute(actor: Actor) {
        actor.select()
    }
}
