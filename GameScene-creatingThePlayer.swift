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
}
