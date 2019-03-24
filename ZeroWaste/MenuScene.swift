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

    enum DisplayMode {
        case initial
        case final
    }

    // MARK: - Views

    var button: ButtonNode!

    // MARk: - Constants

    private let dropDuration: TimeInterval = 0.1

    // MARK: - Variables

    private var timer: Timer!
    private var screenFilledArea: CGFloat = 0
    private var currentPosition: CGPoint = .zero
    private let mode: DisplayMode
    private lazy var scale = size.height / 667

    init(mode: DisplayMode, size: CGSize) {
        self.mode = mode
        super.init(size: size)
        if mode == .initial {
            setupButton()
            setupTimer()
        } else {
            fillScreenWithTrashes()
        }
        setupWorld()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Scene's life cycle

    override func didMove(to view: SKView) {
        if mode == .final {
            physicsBody = nil
        }
    }

    // MARk: - Logic

    private func incrementFilledSize(with size: CGSize) {
        let area = size.width * size.height
        screenFilledArea += area
    }

    private func isFilled() -> Bool {
        let screenArea = size.height * size.width
        return (screenFilledArea / screenArea) > 0.85
    }

    // MARK: - Event handlers

    @objc
    private func playTapped() {
        timer.invalidate()

        let gameScene = GameScene(settings: GameLevel.medium.settings(), size: size)
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

    private func fillScreenWithTrashes() {
        currentPosition = CGPoint(x: frame.minX, y: frame.minY)
        while true {
            let trash = createTrash()
            trash.position = currentPosition
            incrementFilledSize(with: trash.size)
            var newX = currentPosition.x + trash.size.width
            var newY = currentPosition.y
            if newX > frame.maxX {
                newX = 0
                newY += trash.size.height
                if newY > frame.maxY {
                    break
                }
            }
            currentPosition = CGPoint(x: newX, y: newY)
            addChild(trash)
        }
    }

    private func setupWorld() {
        view?.showsFPS = true
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.isDynamic = false
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
    }

    private func setupButton() {
        let size = CGSize(width: 300 * scale, height: 70 * scale)
        let texture = SKTexture(imageNamed: "cleanup")
        button = ButtonNode(size: size, texture: texture)
        button.position = CGPoint(x: frame.midX, y: frame.midY)
        button.zPosition = 1
        button.setTarget(self, action: #selector(playTapped))
        button.setTitle("Cleanup the Earth")
        button.setFontSize(28 * scale)
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
