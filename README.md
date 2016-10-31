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

### Adding Obstacles
#### In this section, we learn about Random Number Generation and more advanced Actions
Before we begin this section, make sure that at the top of the file, under the line `import SpriteKit`, you have the line: `import GameplayKit` 

- Alright so now we have a background. Lets get to making obstacles! We want to write a function that creates a ceiling rock and a ground rock, puts them to the right edge of the screen, and then gets them scrolling across the screen to the left. Add the following function under `createGround`:
```swift
func createRocks() {
    let rockTexture = SKTexture(imageNamed: "rock")
        
    let topRock = SKSpriteNode(texture: rockTexture)
    topRock.zRotation = CGFloat.pi
    topRock.xScale = -1.0
        
    let bottomRock = SKSpriteNode(texture: rockTexture)
        
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
- This looks like a scary function, but in truth, you have seen most of it already! I'll address the new stuff here:
    - We create the topRock by rotating the bottomRock 180 degrees (pi radians). We then flip the topRock along the x-axis so that both rocks are facing "forward": we do this by setting the `xScale` property of topRock, which controls the scaling of the node. A negative scale flips the node.
    - We create an object of type `GKShuffleDistribution`. This object generates uniform random numbers on the interval [min, max]; when we want a new random number, we just call `.nextInt()` on the distribution object.
    - We generate a random yPosition between 20% and 80% of the way up the screen. This random yPosition represents where the space in-between the two rocks will be.
    - We position the top rock to be 70 pixels above yPosition, and the bottom rock to be 70 pixels below yPosition, leaving a gap of 2 * 70 = 140 for the plane to fly through.
    - We add create an action, called `moveAction`, that moves the rocks towards the left (remember: negative is left in coordinates).
    - We generate a sequence that moves the rocks, and then calls `removeFromParent()`. This is a new action. It essentially "deletes" the rocks once they have moved passed the screen. We didn't do this for the background, because we re-used those images, but for the rocks we will continually generate new ones as opposed to re-using them, so we throw away the old ones once they are done. It is a bit like porcelain plates vs. paper plates: you don't throw away porcelain plates because they are expensive and you plan to re-use them, but you definitely need to throw paper plates away, or else you will end up with giant pile of dirty paper plates in your apartment. 
    - We run this sequence on both of the rocks to get them scrolling. 
- If you have been paying attention, you may realize that this function only generates a single set of rocks. What if we want to repeatedly generate rocks forever? Answer: We use a repeatForever action on the function! Observe:
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
- We have seen actions used in the context of SKSpriteNodes: as I've said, they can make nodes move and cycle through animations. But actions can also run blocks of code! The syntax is displayed in the `create` action. The `[unowned self]` line is beyond the scope of this tutorial, but it has to do with memory management. The import point of this action is that every time it is run, it will call `createBlocks`. This type of action is very commonly used to generate repeated events throughout a game, like spawning enemies or obstacles.
- There is a second new action here, `SKAction.wait(forDuration: 3)`. This action does exactly what it promises to: it waits for three seconds! This action is commonly used within a sequence of actions, to put in fixed amounts of time between other actions. 
- The rest of the actions are familiar to you: we create a sequence that creates a block and then waits three seconds. We then repeat this action forever, so that blocks will be created every three seconds.
- If you add a call to `startRocks()` in `didMove(to:)`, you can see the rocks scrolling along by. 

- A couple more things before we get into actual mechanics:
- One: lets put a thin red rectangle right after each pair of rocks. Why you ask? Because I say so! Also, because it is going to help us keep track of the player's score in the next section (Don't fret; we will make these invisible soon). Add the following block of code to `createRocks` underneath `bottomRock.run(moveSequence)`:
```swift
    let rockCollision = SKSpriteNode(color: UIColor.red, size: CGSize(width: 32, height: frame.height))
    rockCollision.name = "scoreDetect"
    addChild(rockCollision)
    rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
    rockCollision.run(moveSequence)
```
- You should recognize this code; it is similar to how we created the blue background rectangles earlier on.
- The only new thing here is that we set `rockCollision.name` to `"scoreDetect"`. The `name` parameter of an SKSpriteNode is a string that is associated with that SKSpriteNode. Why this string is useful will become clear when we implement collision detections, but for now just take my word for it: this is string is useful.
- Two: lets create a label to keep track of how many rocks the player has passed through. First, we need a class variable to keep track of the player's score, and a variable for the label itself. Add the following below `var player: SKSpriteNode!`:
```swift
var scoreLabel: SKLabelNode!

var score = 0 {
    didSet {
        scoreLabel.text = "SCORE: \(score)"
    }
}
```
- A couple new things here:
    - We define variable of type `SKLabelNode` which is like an `SKSpriteNode`, except it represents text instead of sprites.
    - We define an integer variable called `score` with a default value of 0. Furthermore, we use the swift keyword `didSet`. This keyword means: "whenever the value of this variable changes, call the block of code inside the `didSet` block". In this example, whenever the score changes, we update the score label to reflect the new score. 
- Now add the following code, below `startRocks()` to create the SKLabel:
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
- We get a hands-on look at this new `SKLabelNode` type:
    - To create an `SKLabelNode`, we initialize it with a fontName parameter. You can look up all of the built-in fonts online; Personally, I enjoy AmericanTypeWriter-Bold.
    - We set the the `fontSize` parameter of the `scoreLabel`, which does exactly what you'd think: controls the size of the font
    - We put the label in the top left corner of the screen, 20 pixels away from the right edge of the screen and 40 pixels down from the top. 
    - We set the `horizontalAlignmentMode` of the label to be `.right`, which justifies the text to the right side of the label (as opposed to `.left` or `.center`).
    - We set the text of the `scoreLabel` to be "SCORE: 0".
    - We set the `fontColor` to be black. Notice that we use a built-in color, `UIColor.black`, as opposed to manually setting the hue and saturation like we did with the background. For a list of a bunch of built-in colors, type `UIColor.` and check out the auto-complete menu.
- Add a call to `createScore` in `didMove(to:)`; build and run to see `scoreLabel` in the top right corner.
