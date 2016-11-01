//
//  GameScene.swift
//  CrashyPlane
//
//  Created by Pascal Sturmfels on 10/30/16.
//  Copyright © 2016 KTP. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameState {
    case showingLogo
    case playing
    case dead
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var backgroundMusic: SKAudioNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    var logo: SKSpriteNode!
    var gameOver: SKSpriteNode!
    var gameState = GameState.showingLogo
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
        
        createPlayer()
        createSky()
        createBackground()
        createGround()
        createScore()
        createLogos()
        
        let bg = SKAudioNode(fileNamed: "music.mp3")
        backgroundMusic = bg
        addChild(backgroundMusic)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .showingLogo:
            gameState = .playing
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let wait = SKAction.wait(forDuration: 0.5)
            let activatePlayer = SKAction.run { [unowned self] in
                self.player.physicsBody?.isDynamic = true
                self.startRocks()
            }
            
            let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
            logo.run(sequence)
            
        case .playing:
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
            
        case .dead:
            let scene = GameScene(fileNamed: "GameScene")!
            let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard player != nil else { return }
        
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        
        player.run(rotate)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
            if contact.bodyA.node == player {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
            
            let sound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
            run(sound)
            
            score += 1
            
            return
        }
        if contact.bodyA.node == player || contact.bodyB.node == player {
            if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
                explosion.position = player.position
                addChild(explosion)
            }
            
            let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
            run(sound)
            
            gameOver.alpha = 1
            gameState = .dead
            backgroundMusic.run(SKAction.stop())
            
            player.removeFromParent()
            speed = 0
        }
    }
    
    func createLogos() {
        logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logo)
        
        gameOver = SKSpriteNode(imageNamed: "gameover")
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.alpha = 0
        addChild(gameOver)
    }
    
    func createPlayer() {
        let frame1 = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: frame1)
        player.position = CGPoint(x: self.frame.width / 6, y: self.frame.height * 0.75)
        player.zPosition = 10
        
        self.addChild(player)
        
        player.physicsBody = SKPhysicsBody(texture: frame1, size: frame1.size())
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody!.isDynamic = false
        
        // player.physicsBody!.collisionBitMask = 0
        
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
            
            ground.physicsBody = SKPhysicsBody(texture: groundTexture, size: groundTexture.size())
            ground.physicsBody!.isDynamic = false
            
            let moveLeft = SKAction.moveBy(x: -ground.frame.width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: ground.frame.width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
        }
    }
    
    func createRocks() {
        let topRockTexture = SKTexture(imageNamed: "topRock")
        let bottomRockTexture = SKTexture(imageNamed: "bottomRock")
        
        let topRock = SKSpriteNode(texture: topRockTexture)
        let bottomRock = SKSpriteNode(texture: bottomRockTexture)
        
        topRock.zPosition = -20
        bottomRock.zPosition = -20
        
        addChild(topRock)
        addChild(bottomRock)
        
        let xPosition = frame.width + topRock.frame.width
        
        let max = Int(frame.height * 0.80)
        let min = Int(frame.height * 0.20)
        
        let rand = GKShuffledDistribution(lowestValue: min, highestValue: max)
        let yPosition = CGFloat(rand.nextInt())
        
        let rockDistance: CGFloat = 70
        
        topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.frame.height * 0.5 + rockDistance)
        bottomRock.position = CGPoint(x: xPosition, y: yPosition - bottomRock.frame.height * 0.5 - rockDistance)
        
        let endPosition = frame.width + (topRock.frame.width * 2)
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        
        let rockCollision = SKSpriteNode(color: UIColor.red, size: CGSize(width: 32, height: frame.height))
        rockCollision.name = "scoreDetect"
        addChild(rockCollision)
        rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
        rockCollision.run(moveSequence)
        
        topRock.physicsBody = SKPhysicsBody(texture: topRockTexture, size: topRockTexture.size())
        topRock.physicsBody?.isDynamic = false
        bottomRock.physicsBody = SKPhysicsBody(texture: bottomRockTexture, size: bottomRockTexture.size())
        bottomRock.physicsBody?.isDynamic = false
        rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
        rockCollision.physicsBody?.isDynamic = false
    }
    
    func startRocks() {
        let create = SKAction.run { [unowned self] in
            self.createRocks()
        }
        
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        run(repeatForever)
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        scoreLabel.fontSize = 28
        
        scoreLabel.position = CGPoint(x: self.frame.width - 20, y: self.frame.height - 40)
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.black
        
        addChild(scoreLabel)
    }
}
