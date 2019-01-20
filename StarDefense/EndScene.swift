//
//  File.swift
//  StarDefense
//
//  Created by Nareg Megan on 1/20/19.
//  Copyright © 2019 Nareg Megan. All rights reserved.
//

import SpriteKit

class EndScene: SKScene {
    
    let background = SKEmitterNode(fileNamed: "stars.sks")!
    let label = SKLabelNode(text: "Game Over")
    let scoreLabel = SKLabelNode(text: "Score: \(GameScene.score)")
    
     override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        
        label.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        label.fontName = "Futura"
        scoreLabel.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - 40)
        scoreLabel.fontName = "Futura"
        
        background.position = CGPoint(x: 200, y: view.frame.height)
        background.advanceSimulationTime(10)
        
        
        let button = UIButton(frame: CGRect(x: view.frame.width/2 - 60, y: view.frame.height/2 + 50, width: 125, height: 50))
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "Futura", size: 20.0)
        button.setTitle("Play Again", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
        
        self.addChild(background)
        self.addChild(label)
        self.addChild(scoreLabel)
     }
    
     @objc func buttonAction(sender: UIButton!) {
        //execute when play again button is pressed
        GameScene.score = 0
        let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
        let scene:SKScene = GameScene(size: self.size)
        sender.frame = CGRect(x: -100, y: -100, width: 0, height: 0)
        view?.presentScene(scene, transition: transition)
     }
    
}
