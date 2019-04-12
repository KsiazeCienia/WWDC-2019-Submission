import UIKit
import SpriteKit
import PlaygroundSupport

/*

 ### Zero Waste

 The Earth is buried by rubbish. Every year pepole produce huge quantities of them. Only small part of it is recyled. Help our planet and clean it from garbage!

 It's a game which will pratice your memory and learn you how to sort waste at the same time. The goal of the game is to throw away the garbage into the trash without caming into fire.

 */


let view = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
let scene = MenuScene(mode: .initial, size: CGSize(width: 375, height: 667))
scene.scaleMode = .aspectFill
view.presentScene(scene)

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = view
