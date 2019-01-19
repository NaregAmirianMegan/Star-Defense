//
//  HomeScene.swift
//  StarDefense
//
//  Created by Nareg Megan on 1/16/19.
//  Copyright © 2019 Nareg Megan. All rights reserved.
//

import SpriteKit

class HomeScene: SKScene {
    
    let label = SKLabelNode(text: "Space Defense")
    let background = SKEmitterNode(fileNamed: "stars.sks")!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        
        label.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        label.fontName = "Futura"
        
        background.position = CGPoint(x: 200, y: view.frame.height)
        background.advanceSimulationTime(10)
        
        self.addChild(label)
        self.addChild(background)
        
        let button = UIButton(frame: CGRect(x: view.frame.width/2 - 50, y: view.frame.height/2 + 25, width: 100, height: 50))
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "Futura", size: 20.0)
        button.setTitle("Play", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        //execute when play button is pressed
        let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
        let scene:SKScene = GameScene(size: self.size)
        sender.frame = CGRect(x: -100, y: -100, width: 0, height: 0)
        view?.presentScene(scene, transition: transition)
    }

}
