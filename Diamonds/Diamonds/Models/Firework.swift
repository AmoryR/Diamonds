//
//  Firework.swift
//  Player CAI
//
//  Created by Amory Rouault on 11/12/2019.
//  Copyright © 2019 Amory Rouault. All rights reserved.
//

import SpriteKit

class Firework: SKNode {
    
    var timer: Timer?
    private let fireworkColor: [UIColor] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
        .gray,
        .white
    ]

    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public functions
    func startFirework() {
        if let firework = SKEmitterNode(fileNamed: "Firework") {
           self.addChild(firework)
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.7,
                                          target: self,
                                          selector: #selector(showFirework),
                                          userInfo: nil, repeats: true)
    }
    
    func stopFirework() {
        self.timer?.invalidate()
    }
    
    // MARK: Private functions
    @objc private func showFirework() {
        self.removeAllChildren()
        
        if let firework = SKEmitterNode(fileNamed: "Firework") {
            firework.position.x = CGFloat.random(in: -150.0..<150.0)
            firework.position.y = CGFloat.random(in: -200.0..<200.0)
            
            firework.particleColorSequence = nil;
            firework.particleColorBlendFactor = 1.0;
            firework.particleColor = self.fireworkColor.randomElement()!
            
            self.addChild(firework)
        }
    }

}
