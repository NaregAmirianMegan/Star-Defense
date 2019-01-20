//
//  GameScene.swift
//  StarDefense
//
//  Created by Nareg Megan on 1/16/19.
//  Copyright © 2019 Nareg Megan. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let background = SKEmitterNode(fileNamed: "stars.sks")!
    let explosion = SKEmitterNode(fileNamed: "explosion.sks")!
    let player = SKSpriteNode(imageNamed: "/Users/nareg/Desktop/iPhoneDev/StarDefense/ship.png")
    let alien_images = ["/Users/nareg/Desktop/iPhoneDev/StarDefense/alien_ship_one.png", "/Users/nareg/Desktop/iPhoneDev/StarDefense/alien_ship_two.png", "/Users/nareg/Desktop/iPhoneDev/StarDefense/alien_ship_three.png"]
    
    var aliens = [SKSpriteNode]()
    
    let alienLaserCategory:UInt32 = 0x1 << 3
    let playerCategory:UInt32 = 0x1 << 2
    let alienCategory:UInt32 = 0x1 << 1
    let laserCategory:UInt32 = 0x1 << 0
    
    static var score:Int = 0
    var spawnTimer:Timer!
    
    var fireTimer:Timer!
    
    let motionManger = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        
        background.position = CGPoint(x: 200, y: view.frame.height)
        background.advanceSimulationTime(10)
        background.zPosition = -5
        
        player.position = CGPoint(x: view.frame.width/2, y: 80)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width, height: player.size.height))
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = alienLaserCategory
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        
        self.addChild(player)
        self.addChild(background)
        
        spawnTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(spawnAlien), userInfo: nil, repeats: true)
    
        fireTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(alienLasers), userInfo: nil, repeats: true)
        
        motionManger.accelerometerUpdateInterval = 0.2
        motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireLaser()
    }

    func fireLaser() {
        let laser = SKSpriteNode(imageNamed: "/Users/nareg/Desktop/iPhoneDev/StarDefense/laser.png")
        laser.position = CGPoint(x: player.position.x, y: player.position.y)
        laser.zPosition = -1
        
        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: laser.size.width, height: laser.size.height))
        laser.physicsBody?.categoryBitMask = laserCategory
        laser.physicsBody?.contactTestBitMask = alienCategory
        laser.physicsBody?.collisionBitMask = 0
        laser.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(laser)
        
        let animationDuration:TimeInterval = 0.5
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        laser.run(SKAction.sequence(actionArray))
    }
    
    @objc func alienLasers() {
        for alien in aliens {
            fireAlienLaser(alien: alien)
        }
    }
    
    //TODO: delete these lasers
    @objc func fireAlienLaser(alien: SKSpriteNode) {
        let alienLaser = SKSpriteNode(imageNamed: "/Users/nareg/Desktop/iPhoneDev/StarDefense/alien_laser.png")
        alienLaser.position = CGPoint(x: alien.position.x, y: alien.position.y)
        alienLaser.zPosition = -1
        
        alienLaser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: alienLaser.size.width, height: alienLaser.size.height))
        alienLaser.physicsBody?.categoryBitMask = alienLaserCategory
        alienLaser.physicsBody?.contactTestBitMask = playerCategory
        alienLaser.physicsBody?.collisionBitMask = 0
        alienLaser.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(alienLaser)
        
        let animationDuration:TimeInterval = 0.8
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: alien.position.x, y: -10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        alienLaser.run(SKAction.sequence(actionArray))
    }
    
    @objc func spawnAlien() {
        let image = alien_images[Int.random(in: 0 ... 2)]
        let alien = SKSpriteNode(imageNamed: image)
        let max = Int(view!.frame.width) - 30
        alien.position = CGPoint(x: Int.random(in: 0 ... max), y: Int(view!.frame.height) + 50)
        alien.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: alien.size.width, height: alien.size.height))
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = laserCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        aliens.append(alien)
        
        let animationDuration:TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: alien.position.x, y: -alien.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & laserCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0 {
            laserHitAlien(laser: firstBody.node as! SKSpriteNode, alien: secondBody.node as! SKSpriteNode)
        } else if (firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & alienLaserCategory) != 0 {
            laserHitPlayer(laser: firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode)
        }
    }
    
    func laserHitPlayer(laser: SKSpriteNode, player: SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "explosion.sks")!
        explosion.position = player.position
        
        self.addChild(explosion)
        
        laser.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 0.5)) {
            explosion.removeFromParent()
             self.loseGame()
        }
    }
    
    func laserHitAlien(laser: SKSpriteNode, alien: SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "explosion.sks")!
        explosion.position = alien.position
        
        self.addChild(explosion)
        
        laser.removeFromParent()
        alien.removeFromParent()
        aliens.remove(at: aliens.firstIndex(of: alien)!)
        
        self.run(SKAction.wait(forDuration: 0.5)) {
            explosion.removeFromParent()
        }
        
        GameScene.score += 10
    }
    
    override func didSimulatePhysics() {
        player.position.x += xAcceleration * 50
        
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
        
    }
    
    func loseGame() {
        //execute when game is lost
        spawnTimer.invalidate()
        fireTimer.invalidate()
        let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
        let scene:SKScene = EndScene(size: self.size)
        view?.presentScene(scene, transition: transition)
    }
    
}
