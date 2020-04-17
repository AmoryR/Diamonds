//
//  Actor.swift
//  Diamonds
//
//  Created by Amory Rouault on 20/03/2020.
//  Copyright © 2020 Amory Rouault. All rights reserved.
//

import Foundation

enum Direction {
    case LEFT
    case RIGHT
}

protocol Actor {
    func move(direction: Direction)
    func jump()
    func climb()
    func select()
}
