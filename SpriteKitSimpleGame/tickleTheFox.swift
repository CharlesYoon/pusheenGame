//
//  tickleTheFox.swift
//  SpriteKitSimpleGame
//
//  Created by Charles Yoon on 7/14/17.
//  Copyright © 2017 Charles Yoon. All rights reserved.
//

import Foundation
import SpriteKit
//import Firebase

//1
//Have to be able to code the background
//programtically change the UI here so that it
//looks nice like the Grocr application


//2 have it so that there are little animations
// so that there are animals running across the screen

class tickleTheFox: SKScene{
    var fox = SKSpriteNode()
    var textureArray = [SKTexture]()
    
    override func didMove(to view: SKView){
        //add the for loops here for the animation
        /*let background = SKSpriteNode(imageNamed: "stars")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 3)
        addChild(background)*/
        
        for i in 1...13{
            let textureName = "\(i)"
            textureArray.append(SKTexture(imageNamed: textureName))
        }
        fox = SKSpriteNode(imageNamed:"1")
        fox.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(fox)
    }
         override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        fox.run(SKAction.animate(with: textureArray, timePerFrame: 0.2))
    }
}

