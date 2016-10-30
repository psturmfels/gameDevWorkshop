# iOS Game Development Workshop, 11/02/16
### Setting Up
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
- Open up "GameScene.sks" and delete helloLabel. Then, click "View->Utilities->Show Attributes Inspector". In the top bar in the attributes inspector, click the middle button (with the cube). Change the Anchor Point to be X = 0, Y = 0. It should look like the following (it is ok if the width/height are different): 

<img src="/images/SceneAnchorPoint.png">
- Drag all the files in "assets/GFX/" to the "Assets.xcassets" file.
- Control-click on the yellow folder called "CrashyPlane" on the left side and click "New Group". Rename the "New Group" to be "Content".
- Drag the remaining files in assets (PlayerExplosion.sks, coin.wave, explosion.wav, music.m4a, spark.png) to the Content folder.
