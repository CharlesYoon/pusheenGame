//
//  GameScene.swift
//  SpriteKitSimpleGame
//
//  Created by Charles Yoon on 7/10/17.
//  Copyright © 2017 Charles Yoon. All rights reserved.
//

import SpriteKit
import GameplayKit

//Physics Engine

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
}

//Overloading Operators

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //adding a scoreBoard to the screen
    
    let scoreBoard = SKLabelNode(fontNamed: "ChalkDuster")
    
    let highScoreBoard = SKLabelNode(fontNamed: "ChalkDuster")
    
    
    //adding a lives counter on, you need three hearts
    //have to implement this as well
    //make sure you have to display this!!!!!
    let heart = SKSpriteNode(imageNamed: "heart")
    let heart2 = SKSpriteNode(imageNamed: "heart")
    let heart3 = SKSpriteNode(imageNamed: "heart")
    
    var monstersDestroyed = 0
    var score = 0
    var lives = 3
    
    // Have to change the orientation of the game
    
    // 1
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMove(to view: SKView) {
        // 2
        backgroundColor = SKColor.white
        // 3
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        // 4
        addChild(player)
        
        //adding the Lives Bar
        heart.position = CGPoint(x: size.width/4, y: size.height/4)
        heart.setScale(0.1)
    
        heart2.position = CGPoint(x: size.width/4 + 50, y: size.height/4)
        heart2.setScale(0.1)
        
        heart3.position = CGPoint(x: size.width/4 + 100, y: size.height/4)
        heart3.setScale(0.1)
        
        addChild(heart)
        addChild(heart2)
        addChild(heart3)
        
        //setting the ScoreBoard settings
        scoreBoard.text = "\(score)"
        scoreBoard.fontSize = 40
        scoreBoard.fontColor = SKColor.black
        scoreBoard.position = CGPoint(x: size.width/6, y: size.height/6)
        addChild(scoreBoard)
        
        //setting the HighScore settings
        
        highScoreBoard.fontSize = 30
        highScoreBoard.fontColor = SKColor.red
        highScoreBoard.position = CGPoint(x: size.width/8, y: size.height/8)
        addChild(highScoreBoard)
        
        //adding the physics into the scene
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run(hideTheHearts),
                SKAction.run(playerScoreUpdate),
                SKAction.run(addMonster), SKAction.run(addMonster),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
        //adding backgroud music
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        //UserDefaults().set(10, forKey: "highscore")

    }
    
    //hide the hearts as the number of lives disappear
    func hideTheHearts() {
        if (lives == 2){
            heart.removeFromParent()
        } else if (lives == 1){
            heart2.removeFromParent()
        } else if (lives == 0){
            heart3.removeFromParent()
        }
    }
    
    func playerScoreUpdate() {
        let highScore = UserDefaults().integer(forKey: "highscore")
        if monstersDestroyed > highScore {
            UserDefaults().set(monstersDestroyed, forKey: "highscore")
        }
        highScoreBoard.text = "\(UserDefaults().integer(forKey: "highscore"))"
    }

    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode){
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
        
        //to keep the score
        monstersDestroyed += 1
        score += 20
        scoreBoard.text = "\(monstersDestroyed)"
        if (score < 0) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            if let monster = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
        
    }
    
    
    //should create a separate class for this so that I can spawn mutliple monsters at once without having to worry about writing the same code over and over again
    func addMonster() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
        // Add the monster to the scene
        addChild(monster)
        
        
        // Adding the physics to the monsters
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
        monster.physicsBody?.isDynamic = true // 2
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        
        // Determine speed of the monsters
        var actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // As the score increases, make the duration of the monsters crossing the screen
        //shorter
        
        if (score >= 100){
            actualDuration = random(min: CGFloat(1.0), max: CGFloat(2.0))
        }else if (score >= 200){
            actualDuration = random(min: CGFloat(0.5), max: CGFloat(1.0))
        }else if (score >= 260){
            actualDuration = random(min: CGFloat(0.2), max: CGFloat(0.5))
        }else if (score >= 300){
            actualDuration = random(min: CGFloat(0.1), max: CGFloat(0.2))
        }
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        //the monsters attacking makes you lose
        
        let loseAction = SKAction.run() {
            self.lives -= 1
            self.scoreBoard.text = "\(self.monstersDestroyed)"
        }

        if (lives == 0){
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
            lives = 3
            score = 0
        }else{
             monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        
        //adding the physics of the projectile
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if (offset.x < 0) { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))

        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
}
