//
//  MenuScene.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 19/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit
import GameplayKit

final class MenuScene: SKScene {

    // MARK: - Views

    var button: ButtonNode!

    // MARk: - Constants

    private let dropDuration: TimeInterval = 0.5

    // MARK: - Variables

    private var timer: Timer!

    // MARK: - Scene's life cycle

    override func didMove(to view: SKView) {
        setupWorld()
        setupButton()
        setupTimer()
    }

    // MARK: - Event handlers

    @objc
    private func playTapped() {
        timer.invalidate()

        let gameScene = GameScene(size: size)
        scene?.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 1)
        view?.presentScene(gameScene, transition: transition)
    }

    @objc
    private func dropTrash() {
        let trash = createTrash()
        addChild(trash)
    }

    // MARK: - Setup

    private func setupWorld() {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.isDynamic = false
        physicsWorld.gravity = CGVector(dx: 0, dy: -3)
    }

    private func setupButton() {
        let size = CGSize(width: 200, height: 40)
        button = ButtonNode(size: size)
        button.position = CGPoint(x: frame.midX, y: frame.midY)
        button.physicsBody = SKPhysicsBody(rectangleOf: size)
        button.physicsBody?.isDynamic = false
        button.setTarget(self, action: #selector(playTapped))
        button.setTitle("KURWY")
        addChild(button)
    }

    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: dropDuration,
                                     target: self,
                                     selector: #selector(dropTrash),
                                     userInfo: nil,
                                     repeats: true)
    }

    private func createTrash() -> SKSpriteNode {
        let trash = SKSpriteNode(imageNamed: "bin")
        trash.size = CGSize(width: 70, height: 70)
        let xPosition = GKRandomDistribution(lowestValue: Int(frame.minX),
                                             highestValue: Int(frame.maxX))
        trash.position = CGPoint(x: CGFloat(xPosition.nextInt()),
                                 y: frame.maxY - 1)
        trash.physicsBody = SKPhysicsBody(rectangleOf: trash.size)
        return trash
    }
}
