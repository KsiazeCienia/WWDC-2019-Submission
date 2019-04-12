//
//  MenuScene.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 19/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit
import GameplayKit

public final class MenuScene: SKScene {

    public enum DisplayMode {
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

    public init(mode: DisplayMode, size: CGSize) {
        self.mode = mode
        super.init(size: size)
        if mode == .initial {
            setupButton()
            setupTimer()
            let texture = SKTexture(imageNamed: "earth")
            setupEarth(with: texture)

        } else {
            fillScreenWithTrashes()
            setupFinalLabel()
             let texture = SKTexture(imageNamed: "happy_earth")
            setupEarth(with: texture)
            setupRepeatButton()
        }
        setupWorld()
        setupLogo()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Scene's life cycle

    override public func didMove(to view: SKView) {
        if mode == .final {
            let sound = SKAction.playSoundFileNamed("garbage.mp3", waitForCompletion: false)
            run(sound)
            physicsBody = nil
        } else {
            let sound = SKAction.playSoundFileNamed("garbage_win.mp3", waitForCompletion: false)
            run(sound)
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

        removeChildren(in: [button])
        setupLevelBox()
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

    @objc
    private func playAgainTapped() {
        setupLevelBox()
    }

    // MARK: - Setup

    private func setupEarth(with texture: SKTexture) {
        let size = CGSize(width: 250 * scale, height: 250 * scale)
        let earth = SKSpriteNode(texture: texture, color: .clear, size: size)
        earth.position = CGPoint(x: frame.midX, y: frame.midY)
        earth.zPosition = -1
        addChild(earth)
    }

    private func setupRepeatButton() {
        let size = CGSize(width: 260 * scale, height: 60 * scale)
        let texture = SKTexture(imageNamed: "cleanup")
        button = ButtonNode(size: size, texture: texture)
        button.position = CGPoint(x: frame.midX, y: frame.minY + 70 * scale)
        button.zPosition = 1
        button.setTarget(self, action: #selector(playAgainTapped))
        button.setTitle("Play again!")
        button.setFontSize(28 * scale)
        addChild(button)
    }

    private func setupFinalLabel() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "Congratulations!"
        label.fontSize = 30 * scale
        label.position = CGPoint(x: frame.midX, y: frame.midY - 180 * scale)
        addChild(label)
    }

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

    private func setupLevelBox() {
        let blurNode = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.8), size: self.size)
        blurNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(blurNode)
        let size = CGSize(width: 320 * scale, height: 250 * scale)
        let levelHandler = LevelHandler(levels: [.hard, .medium, .easy], scale: scale, size: size)
        levelHandler.delegate = self
        levelHandler.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(levelHandler)
    }

    private func setupLogo() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "Zero Waste"
        label.fontSize = 50 * scale
        label.position = CGPoint(x: frame.midX, y: frame.maxY - 150 * scale)
        addChild(label)
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
        button.position = CGPoint(x: frame.midX, y: frame.minY + 80 * scale)
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
        let images = ["apple", "plastic", "glass", "paper", "metal"]
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

extension MenuScene: LevelHandlerDelegate {
    func didSelectLevel(_ level: GameLevel) {
        let gameScene = GameScene(settings: level.settings(), size: size)
        scene?.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 1)
        view?.presentScene(gameScene, transition: transition)
    }
}
