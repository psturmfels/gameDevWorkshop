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

