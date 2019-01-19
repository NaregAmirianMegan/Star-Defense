//
//  GameViewController.swift
//  StarDefense
//
//  Created by Nareg Megan on 1/16/19.
//  Copyright © 2019 Nareg Megan. All rights reserved.
//

import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = HomeScene(size: view.frame.size)
        let skView = view as! SKView
        skView.presentScene(scene)
    }
    
}
