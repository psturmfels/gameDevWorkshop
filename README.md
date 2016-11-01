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

# 4
- [Return to Menu](#0)

### Adding Obstacles
#### In this section, we learn about Random Number Generation and more advanced Actions
Before we begin this section, make sure that at the top of the file, under the line `import SpriteKit`, you have the line: `import GameplayKit` 

- Alright so now we have a background. Lets get to making obstacles! We want to write a function that creates a ceiling rock and a ground rock, puts them to the right edge of the screen, and then gets them scrolling across the screen to the left. Add the following function under `createGround`:
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
- This looks like a scary function, but in truth, you have seen most of it already! I'll address the new stuff here:
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

# 5
- [Return to Menu](#0)

### Adding Physics
#### In this section, we learn about adding physics to a scene, including gravity and collisions, and responding to player taps.
- We want our `GameScene` to be able to simulate physics. To do so, we need to change the class declaration of `GameScene` to the following:
```swift
class GameScene: SKScene, SKPhysicsContactDelegate {
```
- We added what is called a _protocol_ to the GameScene, making the GameScene a _delegate_ for the game's physics simulation. Although a discussion of _protocols_ and _delegates_ is beyond the scope of this tutorial, adding the `SKPhysicsContactDelegate` protocol to `GameScene` essentially means: "I can simulate physics now!".
- Now we are all set up to add physics to our scene. Lets begin by adding some gravity. In `didMove(to:)`, add the following lines above `createPlayer()`:
```swift
physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
physicsWorld.contactDelegate = self
```
- `physicsWorld` is a property of SKScene, the class that GameScene inherits from (if you don't know what this means, don't worry). Basically, it is a variable that controls global things about our physics, like gravity, and the speed at which the simulation runs. 
- Here, we set the gravity to be -5.0 in the y direction, and 0 in the x direction. This means that everything in our physicsWorld will be accelerated at a rate of 5.0 units / seconds^2 downwards direction (For those curious readers out there: yes, you can set gravity to go in any direction!)
- Cool. Lets add some physics to the player as well. Just below `self.addChild(player)` in `createPlayer`, add the following lines of code: 
```swift
player.physicsBody = SKPhysicsBody(texture: frame1, size: frame1.size())
player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
player.physicsBody!.isDynamic = true

// player.physicsBody!.collisionBitMask = 0
```
- Not much code here, but it does a lot!
    - The first line sets the `physicsBody` of our player. By default, the `physicsBody` of an SKSpriteNode is empty. Only by setting it to a value can a node participate in the physics simulation. We initialize the physics body with a texture and a size, which is perfect for sprites for which we want precise collision detection. For less important sprites, we can approximate them using rectangles or circles; you can read more about how to do this by searching "SKPhysicsBody".
    - The second line sets the `contactTestBitMask` to be the `collisionBitMask`. The `collisionBitMask` is a `phyiscsBody` parameter that represents all of the things that this node should collide with, and by default it is all nodes. When node A collides with node B, node A will tell us about the collision with node B if and only if node B is in node A's `contactTestBitMask`, and so that represents the things the player node tells us about. By default, that value is set to no nodes. With this line, we are saying, "whenever the player collides with anything, let us know". 
    - In the third line, `isDynamic` is a boolean value that, if true, allows the node to be affected by forces like gravity and friction, and those coming from collisions. The default value is true, and I've included the line here just to explain the property.
    - The fourth line makes the plane collide with nothing. It is commented out for now, but we will add it in later, and why we do so we be explained soon.
- If you build and run the project now, you'll notice that the player falls straight off the bottom of the screen! Lets give the ground some physics as well to prevent that. In the `createGround` method, just after `addChild(ground)`, add the following lines of code:
```swift
ground.physicsBody = SKPhysicsBody(texture: groundTexture, size: groundTexture.size())
ground.physicsBody!.isDynamic = false
```
- This sets up the physics for the ground, and ensures that the ground doesn't fall off the screen due to gravity!
- Now for some player input: go to the empty `touchesBegan` method, and add the following two lines of code:
```swift
player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
```
- I've introduced a very important method for games here: the `touchesBegan` method. This method is called whenever the player taps the screen. We use it to handle player input.
    - In this method, we first set the player's velocity to be 0 (If you are curious as to why, consider what happens if the user repeatedly taps on the screen – they could reach astronomical velocities without this line!).
    - Then, we apply an impulse in the positive y direction (Note that the amount of impulse, 20, is arbitrary and is only relative to the mass of the player node, a parameter that you can set!).
- Before we test this out, lets add one more detail. Add the following function to the scene, right below `touchesBegan()`:
```swift 
override func update(_ currentTime: TimeInterval) {
    let value = player.physicsBody!.velocity.dy * 0.001
    let rotate = SKAction.rotate(toAngle: value, duration: 0.1)

    player.run(rotate)
}
```
- Here is a second important method for games: the `update` method. It is called _every single frame_ that your game runs. If you game runs at 60 frames / second, then this method is called 60 times every second your game runs! This method is often used to handle ambient properties about a game, like updating animations and sprite locations.
    - In this method, we take 1/1000th of the player's vertical velocity, and convert it into a rotation. We rotate over a duration of 0.1 seconds, which smoothes the rotation, and then we run the rotation on the player. 
- It is difficult to explain what this rotation does; instead, just build and run the app, and see it at work!

- Now we have to make the player explode whenever it touches an obstacle. 
- First uncomment the line `// player.physicsBody!.collisionBitMask = 0` in `createPlayer`. The player will no longer collide with anything. This is for the better; trust me!
- Add the following lines of code to `createRocks` right at the bottom of the method:
```swift
topRock.physicsBody = SKPhysicsBody(texture: topRockTexture, size: topRockTexture.size())
topRock.physicsBody?.isDynamic = false
bottomRock.physicsBody = SKPhysicsBody(texture: bottomRockTexture, size: bottomRockTexture.size())
bottomRock.physicsBody?.isDynamic = false
rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
rockCollision.physicsBody?.isDynamic = false
```
- Alrighty now lets get into some new stuff! You have already learned about two very important game methods: `touchesBegan()` and `update()`. The third very important game method (VIGM for short!) is the following, which you should add right after `update()`:
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
- Tons of new stuff here! First: the `didBegin()` method is called whenever two nodes that have their `contactTestBitMask` set to each other make contact. In this case, this will happen whenever the plane touches anything. 
    - There is one parameter into the function, called `contact`. This object is of type `SKPhysicsContact`, and contains a bunch of information about the contact. The three most important things that this object contains are `contact.bodyA.node`, `contact.bodyB.node` and `contact.contactPoint`. The first two represent the two bodies that came into contact. The last represents where the contact occured.
    - You may be wondering: "how do we know what bodyA and bodyB are?" Good question! My answer is twofold: 
        - We can compare them to class parameters, like we do in `if contact.bodyA.node == player`. This is useful for specific, individual nodes that we can store as class variables. 
        - We can compare the name of each body to a string that we know represents a type of node in our scene, like we do in `contact.bodyA.node?.name == "scoreDetect"`. Aha! I told you the `name` of an `SKSpriteNode` would come in handy. This is more useful for a class of game nodes that all have a similar behavior.
- So what happens here?
    - First, we check whether either bodyA or bodyB was the red rectangle we set up after the rocks.
    - If so, we figure out which body was the player and which was the red rectangle. We then remove the the red rectangle from the scene, using `removeFromParent()`. We do this to ensure that the plane doesn't contact the same red rectangle more than once!
    - We then encounter yet another use of `SKAction`! We have seen actions that move and animate nodes, and actions that run blocks of code. Here is an action that plays a sound file! (A quick note: the `waitForCompletion` parameter is only really relevant when this action is blocked with a sequence of other actions. When it is in a sequence, `waitForCompletion: false` means that the action directly after the sound action will run once the sound begins. `waitForCompletion: true` means that the action directly after the sound action will run after the sound finishes.)
    - We then increment the score, since if the user hits this rectangle, it means they have successfully navigated through a pair of rocks. Note that this will also update the `scoreLabel`.
    - We then call return. This is so the function stops its execution, and doesn't execute the next block of code we are about to add.
- Cool. The player gets rewarded for being awesome. Lets make them explode when they hit obstacles! Add the following block of code right at the end of `didBegin()`:
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
- What's going on? We know the player can only crash into three things: the scoring rectangle, the rocks, and the ground. If the player was invovled in the contact, and the red rectangle wasn't, the player must have crashed into the scenery.
    - We check whether the player was invovled in the contact.
    - Here is a new type! `SKEmitterNode` is a built-in type used to represent explosions and particle effects. It is particularly neat for explosions involving planes crashing into rocks. We initialize it from a file, "PlayerExplosion", which I provided for you. If you are interested in learning how to create your own explosions, it is actually quite easy! Just search `SKEmitterNode`. More discussion is beyond the scope of this tutorial.
    - We place the explosion over the player, and remove the player from the scene. 
    - We play a sound call explosion, just to make sure the player knows the plane has exploded.
    - We call `speed = 0`. This is new as well! The `speed` parameter of a scene represents how fast time runs for each node attached to an object. If we called `speed = 2.0`, then everything (actions, movements, animations) would happen twice as fast; `speed = 0.5` would make everything go twice as slowly. `speed = 0` freezes everything in-place! This is effectively our way of saying that the game is over: the background, the rocks, and the ground will all stop moving.
- Congratulations for making in this far! We have built the bulk of a simple iOS game! Build and run it!

# 6
- [Return to Menu](#0)

### Music and Scenes
#### In this section, we learn how to add background music to a game. We also learn about scene transitions!
- So far so good, but what is a game without background music? Add this line under `var scoreLabel: SKLabelNode!`: 
```swift
var backgroundMusic: SKAudioNode!
```
- Now add the following lines to `didMove(to:)` under `createScore()`:
```swift
let bg = SKAudioNode(fileNamed: "music.mp3")
backgroundMusic = bg
addChild(backgroundMusic)
```
- We create an `SKAudioNode` object from the music file, and then we add it to our scene. An `SKAudioNode` is a special type of node that is initialized with a song, and once added to a scene, plays that song on loop forever! Perfect for background music.
- You may notice that we don't directly assign the new audio node to the `backgroundMusic` variable, but instead create a copy called `bg`. Long story short, there is an unfixed bug with this type of node, and so we have to create `SKAudioNode` objects like this.
- If you build it and run it, you can here background music!

- The other problem with our game is that the player can't replay after losing! Lets fix that by adding game states. Add the following enumeration above the class declaration at the top of the file:
```swift
enum GameState {
    case showingLogo
    case playing
    case dead
}
```
- An enumeration, declared in swift using `enum`, is a type that represents a fixed set of values. Here, a `GameState` object can take three values, `showingLogo`, `playing` and `dead`.
- To keep track of the new game states we are about to add, lets define three more class variables below the `score` variable:
```swift
var logo: SKSpriteNode!
var gameOver: SKSpriteNode!
var gameState = GameState.showingLogo
```
- Notice how we declare gameState as a `GameState` object with default value `showingLogo`.
- Lets add a function to create the `logo` and `gameOver` nodes. Just above `createPlayer`, add the following function:
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
- The only new thing here is the line `gameOver.alpha = 0`. The `alpha` value of a sprite node is how transparent it is. An alpha value of 1 means that a node is completely opaque, while an alpha value of 0 means the node is invisible. Any value in between gets you that percent transparency. We set the `gameOver` node to be invisible intially, since the player shouldn't see it until they lose!
- Add a call to `createLogos()` inside `didMove(to:)`.
- Inside `didMove(to:)`, _remove_ the call to `createRocks`. We don't want to create rocks until the player begins playing!
- Inside the `createPlayer()` method, change the line `player.physicsBody?.isDynamic = true` to `player.physicsBody?.isDynamic = false`. We don't want the plane to feel the effects of gravity until they begin playing!  
- Now we have a starting splash screen. When the player taps that screen, we should begin the game. Change the `touchesBegan` method to look like this:
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
- Here, we use a switch statement on `gameState`. Notice that if `gameState` is `.playing`, we do the same thing we always did: apply an impulse to the plane. 
    - If `gameState` is `.showingLogo`, then we transition to the `.playing` state.
    - We use a fadeOut action to slowly fade out the logo.
    - We use a remove action to delete the logo.
    - We use a wait action to pause a half-second between removing the logo and activating the player.
    - We use a run action to get the player moving and the rocks spawning.
- Actions are everywhere in iOS game dev! We've succesfully handled the beginning state of the game. Now we need to handle the gameOver state. 
- In the `didBegin` method, just above the call to `player.removeFromParent()`, add the following three lines:
```swift
gameOver.alpha = 1
gameState = .dead
backgroundMusic.run(SKAction.stop())
```
- We make the `gameOver` label visible, we change the state to `.dead`, and we stop the background music. All straightforward stuff. 
- Now we need to add a way for the user to replay from the `.dead` state. In `touchesBegan`, delete the `break` line in `.case dead:` and replace it with:
```swift
let scene = GameScene(fileNamed: "GameScene")!
let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
self.view?.presentScene(scene, transition: transition)
```
- So what is going on here? 
    - We are creating a new object of type `GameScene`. We have been implicity working with this object all along! A `GameScene` object is the object that you have been coding, and it creates our game!
    - We are creating an object of type `SKTransition`. These objects are used to transition between scenes. For example, suppose your game had a menu scene, an in-game scene, a pause scene and so on. We could use transitions to make the changes between scenes look nice. In this case, we will use transitions to transition between a `.dead` game and a fresh new game, ready to play.
    - We call `self.view?.presentScene`. `self.view?` is a property that refers to the view that contains this scene. A discussion of what a view is in relation to a scene is beyond the scope of this tutorial, but you can think of the view as an object that we have placed our scene in and manages our scene from a high-level. 
    - `presentScene` replaces our current scene, which is in the `.dead` state, with a freshly made scene. Notice that the new `GameScene` will be in the `.showingLogo` state. 
- Before we run the game, add the following line to `update()` before anything else:
```swift
guard player != nil else { return }
```
- This is a safety precaution. Note that the `update()` method may be called before the player is created, in which case we are trying to rotate a node that does not yet exist. This line ensures that if the player does not yet exist, we don't try and rotate anything. This line makes use of a `guard` statement, which is swift syntax for "make sure that this condition is true, and if it is not true, get me the heck out of here".
- HORAY! You have finished your first SpriteKit game! Build it, run it, and use it as a springboard for future games!

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
