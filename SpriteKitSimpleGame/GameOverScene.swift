//
//  GameOverScene.swift
//  SpriteKitSimpleGame
//
//  Created by Charles Yoon on 7/10/17.
//  Copyright © 2017 Charles Yoon. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    init(size: CGSize, won: Bool){
        super.init(size: size)
        
        //1
        backgroundColor = SKColor.white
        
        //2
        let message = won ? "You're a Cat Savior": "You Lose :["
        
        //3
        let label = SKLabelNode(fontNamed: "ChalkDuster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                // 5
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
