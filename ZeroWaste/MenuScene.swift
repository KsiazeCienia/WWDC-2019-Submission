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

    private let dropDuration: TimeInterval = 0.1

    // MARK: - Variables

    private var timer: Timer!
    private var screenFilledArea: CGFloat = 0

    // MARK: - Scene's life cycle

    override func didMove(to view: SKView) {
        setupWorld()
        setupButton()
        setupTimer()
    }

    // MARk: - Logic

    private func incrementFilledSize(with size: CGSize) {
        let area = size.width * size.height
        screenFilledArea += area
    }

    private func isFilled() -> Bool {
        let screenArea = UIScreen.main.bounds.size.height * UIScreen.main.bounds.size.width
        return (screenFilledArea / screenArea) > 0.85
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
        guard !isFilled() else {
            timer.invalidate()
            return
        }

        let trash = createTrash()
        incrementFilledSize(with: trash.size)
        addChild(trash)
    }

    // MARK: - Setup

    private func setupWorld() {
        view?.showsFPS = true
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.isDynamic = false
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
    }

    private func setupButton() {
        let size = CGSize(width: 200, height: 40)
        button = ButtonNode(size: size)
        button.position = CGPoint(x: frame.midX, y: frame.midY)
        button.zPosition = 1
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
        let images = ["Apple", "plastic_bottle", "glass_bottle", "paper"]
        let random = images.randomElement()!
        let trash = SKSpriteNode(imageNamed: random)
        print(UIScreen.main.bounds)
        let scale = UIScreen.main.bounds.height / 667
        let size = CGSize(width: 40 * scale, height: 80 * scale)
        trash.size = size
        trash.zRotation = CGFloat.random(in: 0 ... 360)
        trash.aspectFillToSize(fillSize: size)
        let xPosition = GKRandomDistribution(lowestValue: Int(frame.minX),
                                             highestValue: Int(frame.maxX))
        trash.position = CGPoint(x: CGFloat(xPosition.nextInt()),
                                 y: frame.maxY - 1)
        trash.physicsBody = SKPhysicsBody(rectangleOf: trash.size)
        trash.physicsBody?.mass = 1
        return trash
    }
}
