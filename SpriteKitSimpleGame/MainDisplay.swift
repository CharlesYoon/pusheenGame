//
//  MainDisplay.swift
//  SpriteKitSimpleGame
//
//  Created by Charles Yoon on 7/13/17.
//  Copyright © 2017 Charles Yoon. All rights reserved.
//


//I need to set the UI properly here
import Foundation
import SpriteKit
//import Firebase

//1
//Have to be able to code the background 
//programtically change the UI here so that it 
//looks nice like the Grocr application


//2 have it so that there are little animations
// so that there are animals running across the screen

class MainDisplay: SKScene{
    var catBand = SKSpriteNode()
    var textureArray = [SKTexture]()
    
    override func didMove(to view: SKView){
        //add the for loops here for the animation
        let background = SKSpriteNode(imageNamed: "stars")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 3)
        addChild(background)
    }
}

