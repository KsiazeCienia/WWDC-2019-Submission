//
//  GameViewController.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 16/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {


    private let gameView: GameView = {
        let gameView = GameView(frame: .zero)
        gameView.translatesAutoresizingMaskIntoConstraints = false
        return gameView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupLeyout()
//        gameView.startGame()

        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.frame.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }


//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }


    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setupLeyout() {
        view.addSubview(gameView)

        NSLayoutConstraint.activate([
            gameView.topAnchor.constraint(equalTo: view.topAnchor),
            gameView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gameView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }



}
