//
//  FoxDancingAnimation.swift
//  SpriteKitSimpleGame
//
//  Created by Charles Yoon on 7/14/17.
//  Copyright © 2017 Charles Yoon. All rights reserved.
//

import UIKit
import SpriteKit

class FoxDancingAnimation: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = tickleTheFox(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
