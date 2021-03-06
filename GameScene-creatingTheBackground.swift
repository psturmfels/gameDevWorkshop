//
//  GameScene.swift
//  CrashyPlane
//
//  Created by Pascal Sturmfels on 10/30/16.
//  Copyright © 2016 KTP. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        createPlayer()
        createSky()
        createBackground()
        createGround()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func createPlayer() {
        let frame1 = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: frame1)
        player.position = CGPoint(x: self.frame.width / 6, y: self.frame.height * 0.75)
        player.zPosition = 10
        
        self.addChild(player)
        
        let frame2 = SKTexture(imageNamed: "player-2")
        let frame3 = SKTexture(imageNamed: "player-3")
        let animation = SKAction.animate(with: [frame1, frame2, frame3, frame2], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)
        
        player.run(runForever)
    }
    
    func createSky() {
        let topBlue = UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1)
        let topSize = CGSize(width: self.frame.width, height: self.frame.height * 0.67)
        let topSky = SKSpriteNode(color: topBlue, size: topSize)
        topSky.position = CGPoint(x: self.frame.midX, y: self.frame.height - topSize.height * 0.5)
        topSky.zPosition = -40
        self.addChild(topSky)
        
        let botBlue = UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1)
        let botSize = CGSize(width: self.frame.width, height: self.frame.height * 0.33)
        let botSky = SKSpriteNode(color: botBlue, size: botSize)
        botSky.position = CGPoint(x: self.frame.midX, y: botSize.height * 0.5)
        botSky.zPosition = -40
        self.addChild(botSky)
    }
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.position = CGPoint(x: background.frame.width * CGFloat(Double(i) + 0.5), y: 100 + background.frame.height * 0.5)
            self.addChild(background)
            
            let moveLeft = SKAction.moveBy(x: -background.frame.width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: background.frame.width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
    
    func createGround() {
        let groundTexture = SKTexture(imageNamed: "ground")
        
        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: ground.frame.width * CGFloat(Double(i) + 0.5), y: ground.frame.height * 0.5)
            
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -ground.frame.width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: ground.frame.width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
        }
    }
}
