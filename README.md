# iOS Game Development Workshop, 11/02/16
### Setting Up
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

### Creating the Player
#### In this section, we put a sprite on the screen and animate it.
- Open up the "GameScene.swift" file. Below the class declaration but above the `didMove(to:)` function, add the following line:
```swift 
var player: SKSpriteNode!
```
- This is a variable that will represent our player! This variable is of type "SKSpriteNode", which is a node in a game that has one or more images (sprites) on the screen. SKSpriteNode objects are used to represent most in-game SpriteKit objects. Now we have told our game scene that there will be a sprite called "player", but we haven't told our game scene what the player will look like! Lets do that now: declare a new function below `touchesBegan(_:)`:
```swift
func createPlayer() {
    let frame1 = SKTexture(imageNamed: "player-1")
    player = SKSpriteNode(texture: frame1)
    player.position = CGPoint(x: self.frame.width / 6, y: self.frame.height * 0.75)
    player.zPosition = 10
    
    self.addChild(player)
}
```
- A lot is going on here. First, we have declared a new function called `createPlayer` inside this game scene. When the function is called, it:
    - Creates a new SKSpriteNode from the image named "player-1", and sets that node to be our player. 
    - Sets that player's position to be 1/6th of the way across the screen from the left, and 3/4th of the way up the screen from the bottom.
    - It sets the player's zPosition to be 10. A "zPosition" value orders which nodes appear in-front of others on the screen: nodes with higher zPosition values will appear in front of nodes with lower zPosition values. 
    - It calls "self.addChild(player)", which adds the newly created player to our scene.
- In `didMove(to:)`, add a call to `createPlayer`. Build and run the app, and you should see a plane on the screen! 
- This is just a static image; not very exciting just yet. The real power of SKSpriteNodes is the ability to add _Actions_. Actions cause SKSpriteNodes to do things, like move, scale, and animate. Add the following code just below `self.addChild(player)`:
```swift
    let frame2 = SKTexture(imageNamed: "player-2")
    let frame3 = SKTexture(imageNamed: "player-3")
    let animation = SKAction.animate(with: [frame1, frame2, frame3, frame2], timePerFrame: 0.01)
    let runForever = SKAction.repeatForever(animation)
        
    player.run(runForever)
```
- What is going on here? 
    - We grab two more textures, player-2, and player-3. 
    - Then, we create an SKAction called "animate" which loops over our textures with 0.01 seconds per texture. 
    - We want put this animation on loop, so we chain it to a repeatForever action (otherwise, it would just run the animation once).
    - We call `player.run(runForever)`, which tells the player to continually loop through the animation frames.
- Build and run the app, and you should see the the plane with a spinning propeller!
 
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
- This is a huge chunk, so lets break it down:
    - We define a `UIColor` object, which represents a color on the screen.
    - We define a `CGSize` object, which has a width and a height.
    - We then define an SKSpriteNode, but instead of giving it an image, we give it a size and a color. This means that this node will be a rectangle of the specified size and with the specified color. 
    - We give the node `topSky` a position which puts it at the middle of the screen and at the top. Notice that since all nodes are positioned relative to their center, we put `topSky` at y position `frame.midY - topSize.height * 0.5` so that the top of the node just touches the top of the screen.
    - We give the topSky a `zPosition` of -40 so it will be behind other stuff.
    - We add the topSky to the scene. 
    - We then repeat the whole process with a slightly darker blue rectangle, and we put it at the bottom of the screen.
- Add a call to `createSky()` in `didMove(to:)`. 
- If you build and run the app, you should see a nice blue sky in the background.

- Now it is time to add scrolling mountains to the background. Define the following function under `createSky()`:
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
- Ohoh! We have our first swift loop here! Other than that, not much is new. We create a background from an image called "background", position it in front of  the sky, and add it to our scene. Lets talk about this for loop:
    - `for i in 0 ... 1` is swift syntax for "repeat this block of code for each number in the range [0,1]". Since there are only two numbers in this range, this loop executes twice: with i = 0, and with i = 1.
    - Inside the foor loop, we set the background's position. 
        - For i = 0, x = background.frame.width * 0.5
        - For i = 1, x = background.frame.width * 1.5
    - This creates two background nodes that are side by side. The first is left-justified with the left-side of the screen, and the second is right next to it, off the side of the screen.
- You may be wondering why we have created an extra background node off the edge of the screen! The reason is this: to achieve a visual "scrolling" effect, we are going to scroll the background nodes to the left. When the first one scrolls off the screen, we will teleport it to the right side, have the second background scroll, and repeat this forever. I promise that this will make more sense when we add the code.
- Lets add the scrolling motion to the background. Add the following code just under `self.addChild(background)`:
```swift
let moveLeft = SKAction.moveBy(x: -background.frame.width, y: 0, duration: 20)
let moveReset = SKAction.moveBy(x: background.frame.width, y: 0, duration: 0)
let moveLoop = SKAction.sequence([moveLeft, moveReset])
let moveForever = SKAction.repeatForever(moveLoop)

background.run(moveForever)
```
- This is our second example of an SKAction! This time, we are using actions to move a node relative to its current position (`SKAction.moveBy()`).
    - We create an action to move the background left (left is the negative direction) over a period of 20 seconds.
    - We create an action to move the background to its original position over a period of 0 seconds.
    - We create an _Action Sequence_. An action sequence, `SKAction.sequence()`, is an array of actions that you want to happen in a specified order.
    - We loop the animation to run forever.
    - We run the animation on _both_ of the background nodes, so it looks like the background is always scrolling.
- Add a call to `createBackground` in `didMove(to:)`. Watch as our plane flies through the sky!

- Unfortunately, there is no ground! Lets fix that by adding the following fucntion below `createBackground`:
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
- This code is _very similar_ to the code used to to create the sky.
    - We loop over a block of code (twice, for i = 0 and i = 1) to create ground nodes.
    - We set the `zPosition` of the ground to be -10, so it appears in front of the background.
    - We set the ground position so that we have two ground nodes that are side by side, starting at the left end of the screen. 
    - We scroll and reset the ground forever. Notice that the ground scrolls faster than the background (5 seconds vs. 20 seconds), which makes a nice visual effect.
- Add a call to `createGround` in `didMove(to:)`, and low and behold our hard work paying off when you build the app!
