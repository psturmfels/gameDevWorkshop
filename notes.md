# iOS Game Development Workshop, 11/02/16
# 0
## Menu
1. [Setup](#1)
2. [Creating the Player](#2)
3. [Creating the Background](#3)
4. [Adding Obstacles](#4)
5. [Adding Physics](#5)
6. [Music and Scenes](#6)
7. [Closing Thoughts](#7)
8. [Pascal's Selfish Promotion + Acknowledgements](#8)
9. [Stretch: Adding an Enemy!](#9)

# 1
- [Return to Menu](#0)

### Setup 
#### In this section, we clean the template project for use.
- Open up Xcode, and create a new project. Choose "Game" for the template.
<img src="/images/SelectGame.png">
- In the settings pane, make the project name "CrashyPlane". Make sure the Language is set to "Swift", the Game Technology is "SpriteKit", the Devices is "iPhone", and all of the boxes are unchecked.
<img src="/images/SelectSettings.png">
- Save the project to a destination.
- In the following screen, click on the top level project "CrashyPlane" (with the blue doc icon in the top left corner). Scroll down to "Deployment Info", and make sure only the "Portrait" device orientation is checked.
<img src="/images/Orientation.png">
- Delete the "Actions.sks" file.
- Click on "Assets.xcassets" and delete the "Spaceship" image.
- Go to the "GameScene.swift" file and delete everything inside the class declaration except for the functions:
```swift
override func didMove(to view: SKView)
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
```
- Within those functions, delete everything (leave the function declaration, but the function should be blank).
- Your "GameScene.swift" file should look something like this:
```swift 
//  GameScene.swift
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
```
- Open up "GameScene.sks" and delete helloLabel. Then, click "View->Utilities->Show Attributes Inspector". In the top bar in the attributes inspector, click the middle button (with the cube). Change the Anchor Point to be X = 0, Y = 0. Make W = 350, H = 667. It should look like this:

<img src="/images/SceneAnchorPoint.png">
- Drag all the files in "assets/GFX/" to the "Assets.xcassets" file.
- Control-click on the yellow folder called "CrashyPlane" on the left side and click "New Group". Rename the "New Group" to be "Content".
- Drag the remaining files in assets (PlayerExplosion.sks, coin.wave, explosion.wav, music.m4a, spark.png) to the Content folder.

# 2
- [Return to Menu](#0)

### Creating the Player
#### In this section, we put a sprite on the screen and animate it.
- Open up the "GameScene.swift" file. Below the class declaration but above the `didMove(to:)` function, add the following line:
```swift 
var player: SKSpriteNode!
```
- Declare a new function below `touchesBegan(_:)`:
```swift
func createPlayer() {
    let frame1 = SKTexture(imageNamed: "player-1")
    player = SKSpriteNode(texture: frame1)
    player.position = CGPoint(x: self.frame.width / 6, y: self.frame.height * 0.75)
    player.zPosition = 10
    
    self.addChild(player)
}
```
- In `didMove(to:)`, add a call to `createPlayer`. 
- Add the following code just below `self.addChild(player)`:
```swift
    let frame2 = SKTexture(imageNamed: "player-2")
    let frame3 = SKTexture(imageNamed: "player-3")
    let animation = SKAction.animate(with: [frame1, frame2, frame3, frame2], timePerFrame: 0.01)
    let runForever = SKAction.repeatForever(animation)
        
    player.run(runForever)
```
 
# 3
- [Return to Menu](#0)

### Creating the Background
#### In this section, we add a multiple-depth scrolling background.
- Still in the "GameScene.swift" file, define a new function below `createPlayer()`: 
```swift
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
```
- Add a call to `createSky()` in `didMove(to:)`. 
- Define the following function under `createSky()`:
```swift
func createBackground() {
    let backgroundTexture = SKTexture(imageNamed: "background")
        
    for i in 0 ... 1 {
        let background = SKSpriteNode(texture: backgroundTexture)
        background.zPosition = -30
        background.position = CGPoint(x: background.frame.width * CGFloat(Double(i) + 0.5), y: 100 + background.frame.height * 0.5)
        self.addChild(background)
    }
}
```
- Add the following code just under `self.addChild(background)`:
```swift
let moveLeft = SKAction.moveBy(x: -background.frame.width, y: 0, duration: 20)
let moveReset = SKAction.moveBy(x: background.frame.width, y: 0, duration: 0)
let moveLoop = SKAction.sequence([moveLeft, moveReset])
let moveForever = SKAction.repeatForever(moveLoop)

background.run(moveForever)
```
- Add a call to `createBackground` in `didMove(to:)`.
- Add the following fucntion below `createBackground`:
```swift
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
```
- Add a call to `createGround` in `didMove(to:)`.

# 4
- [Return to Menu](#0)

### Adding Obstacles
#### In this section, we learn about Random Number Generation and more advanced Actions
Before we begin this section, make sure that at the top of the file, under the line `import SpriteKit`, you have the line: `import GameplayKit` 

- Add the following function under `createGround`:
```swift
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
}
```
- Add the following function under `createRocks`:
```swift
func startRocks() {
    let create = SKAction.run { [unowned self] in
        self.createRocks()
    }
        
    let wait = SKAction.wait(forDuration: 3)
    let sequence = SKAction.sequence([create, wait])
    let repeatForever = SKAction.repeatForever(sequence)
        
    run(repeatForever)
}
```
- Add a call to `startRocks()` in `didMove(to:)`.
- Add the following block of code to `createRocks` underneath `bottomRock.run(moveSequence)`:
```swift
    let rockCollision = SKSpriteNode(color: UIColor.red, size: CGSize(width: 32, height: frame.height))
    rockCollision.name = "scoreDetect"
    addChild(rockCollision)
    rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
    rockCollision.run(moveSequence)
```
- Add the following below `var player: SKSpriteNode!`:
```swift
var scoreLabel: SKLabelNode!

var score = 0 {
    didSet {
        scoreLabel.text = "SCORE: \(score)"
    }
}
```
- Add the following code, below `startRocks()` to create the SKLabel:
```swift
func createScore() {
    scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    scoreLabel.fontSize = 28

    scoreLabel.position = CGPoint(x: self.frame.width - 20, y: self.frame.height - 40)
    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.text = "SCORE: 0"
    scoreLabel.fontColor = UIColor.black

    addChild(scoreLabel)
}
```
- Add a call to `createScore` in `didMove(to:)`.

# 5
- [Return to Menu](#0)

### Adding Physics
#### In this section, we learn about adding physics to a scene, including gravity and collisions, and responding to player taps.
- Change the class declaration of `GameScene` to the following:
```swift
class GameScene: SKScene, SKPhysicsContactDelegate {
```
- In `didMove(to:)`, add the following lines above `createPlayer()`:
```swift
physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
physicsWorld.contactDelegate = self
```
- Just below `self.addChild(player)` in `createPlayer`, add the following lines of code: 
```swift
player.physicsBody = SKPhysicsBody(texture: frame1, size: frame1.size())
player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
player.physicsBody!.isDynamic = true

// player.physicsBody!.collisionBitMask = 0
```
- In the `createGround` method, just after `addChild(ground)`, add the following lines of code:
```swift
ground.physicsBody = SKPhysicsBody(texture: groundTexture, size: groundTexture.size())
ground.physicsBody!.isDynamic = false
```
- In `touchesBegan`, and add the following two lines of code:
```swift
player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
```
- Add the following function to the scene, right below `touchesBegan()`:
```swift 
override func update(_ currentTime: TimeInterval) {
    let value = player.physicsBody!.velocity.dy * 0.001
    let rotate = SKAction.rotate(toAngle: value, duration: 0.1)

    player.run(rotate)
}
```
- First uncomment the line `// player.physicsBody!.collisionBitMask = 0` in `createPlayer`.
- Add the following lines of code to `createRocks` right at the bottom of the method:
```swift
topRock.physicsBody = SKPhysicsBody(texture: topRockTexture, size: topRockTexture.size())
topRock.physicsBody?.isDynamic = false
bottomRock.physicsBody = SKPhysicsBody(texture: bottomRockTexture, size: bottomRockTexture.size())
bottomRock.physicsBody?.isDynamic = false
rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
rockCollision.physicsBody?.isDynamic = false
```
- Add the following function right after `update()`:
```swift
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
}
```
- Add the following block of code right at the end of `didBegin()`:
```swift
if contact.bodyA.node == player || contact.bodyB.node == player {
    if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
        explosion.position = player.position
        addChild(explosion)
    }

    let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    run(sound)

    player.removeFromParent()
    speed = 0
}
```

# 6
- [Return to Menu](#0)

### Music and Scenes
#### In this section, we learn how to add background music to a game. We also learn about scene transitions!
- Add this line under `var scoreLabel: SKLabelNode!`: 
```swift
var backgroundMusic: SKAudioNode!
```
- Now add the following lines to `didMove(to:)` under `createScore()`:
```swift
let bg = SKAudioNode(fileNamed: "music.mp3")
backgroundMusic = bg
addChild(backgroundMusic)
```

- Add the following enumeration above the class declaration at the top of the file:
```swift
enum GameState {
    case showingLogo
    case playing
    case dead
}
```
- Define three more class variables below the `score` variable:
```swift
var logo: SKSpriteNode!
var gameOver: SKSpriteNode!
var gameState = GameState.showingLogo
```
- Just above `createPlayer`, add the following function:
```swift
func createLogos() {
    logo = SKSpriteNode(imageNamed: "logo")
    logo.position = CGPoint(x: frame.midX, y: frame.midY)
    addChild(logo)

    gameOver = SKSpriteNode(imageNamed: "gameover")
    gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
    gameOver.alpha = 0
    addChild(gameOver)
}
```
- Add a call to `createLogos()` inside `didMove(to:)`.
- Inside `didMove(to:)`, _remove_ the call to `createRocks`. We don't want to create rocks until the player begins playing!
- Inside the `createPlayer()` method, change the line `player.physicsBody?.isDynamic = true` to `player.physicsBody?.isDynamic = false`. We don't want the plane to feel the effects of gravity until they begin playing!  
- Change the `touchesBegan` method to look like this:
```swift
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
        break
    }
}
```
- In the `didBegin` method, just above the call to `player.removeFromParent()`, add the following three lines:
```swift
gameOver.alpha = 1
gameState = .dead
backgroundMusic.run(SKAction.stop())
```
- In `touchesBegan`, delete the `break` line in `.case dead:` and replace it with:
```swift
let scene = GameScene(fileNamed: "GameScene")!
let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
self.view?.presentScene(scene, transition: transition)
```
- Add the following line in `createRocks()` above `addChild(rockCollision)`:
```swift
rockCollision.alpha = 0
```
- Before we run the game, add the following line to `update()` before anything else:
```swift
guard player != nil else { return }
```
# 7
- [Return to Menu](#0)

### Closing Thoughts
Now that you've built your first iPhone game, can you expand upon it? Make it more difficult as time goes on? Add different types of obstacles or rewards for the player to avoid or achieve? Add more controls to allow the player to change horizontal position? You can accomplish all of these things with little more than what this tutorial teaches. Give it a try!

# 8
- [Return to Menu](#0)

### Pascal's Selfish Promotion + Acknowledgements
- I'm making my own game, called Avalanche, using much of the technology I've introduced here! Check out my youtube screen capture for it here: <a target="_blank" href="https://youtu.be/O0iLYOxzdm4">Avalanche Promo</a>. Stay tuned – this will be on the app store soon!
- I'm part of a professional tech frat called Kappa Theta Pi at the University of Michigan. This talk wouldn't have happened without their organizational efforts! Big shout out to them. Also, if you are a Michigan student, come check us out at the beginning of next semester! We will be at Festifall, North Fest, and all over Facebook. 
- This tutorial is a more-detailed clone of <a target="_blank" href="https://www.hackingwithswift.com/read/36/0/introduction">Project 36 by HackingWithSwift</a>. HackingWithSwift is an amazing free swift tutorial series, and I learned much of what I know from it!
- Thanks to <a target="_blank" href="http://www.allhandsactive.org">All Hands Active</a> for hosting my talk!

# 9
- [Return to Menu](#0)

### Stretch: Adding an enemy!
#### 
You may have noticed that this game is really easy the way it currently is. Can you make the game more difficult for the player? There are some fairly easy ways to do this:
- Make the rocks spawn more frequently
- Make the rocks move faster
- Make the gap between the rocks smaller
- Make the gravity stronger

But I have another thing in mind: I've included the sprites for an enemy space-ship and a missile, and an emitter node for a trailing blaze of fire. Can you use these to draw an enemy that fires missiles at the player every so often? 
My sample implementation of this is done in GameScene-addingAnEnemy.swift.

So where do we go from here? Try adding on new features to this game! Make a menu screen for it! Make it more difficult as time goes on! You have already learned enough to tweak this game a substantial amount. 
