//
//  GameScene.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 16/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {

    // MARK: - Views

    private var boardNode: BoardNode!
    private var summaryNode: SummaryNode!
    private var menuScene: MenuScene!
    private var blurNode: SKSpriteNode!
    private let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private var timer: Timer?
    private var types: [GameType] = [.paper, .metal, .bio, .plastic, .glass].shuffled()
    private var counter: Int = 0
    private var roundCounter: Int = 0
    private var correct: Int = 0
    private var score: Int = 0
    private let settings: GameSettings

    // MARK: - Variables

    private lazy var scale = size.height / 667

    // MARK: - Initializers

    init(settings: GameSettings, size: CGSize) {
        self.settings = settings
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARk: - Scene life cycle
    
    override func didMove(to view: SKView) {
        setupBoard()
        setupLabel()
        roundCounter += 1
        animateLabel(sound: false) { [unowned self] in
            self.turnOnCountDown()
            self.boardNode?.displayTraps()
        }
    }

    // MARK: - Logic

    private func prepareNextRound() {
        roundCounter += 1
        let index = roundCounter % types.count
        boardNode.prepareNewGame(with: types[index].icons())
    }

    private func turnOnCountDown() {
        counter = settings.prepareTime
        self.label.text = String(self.counter)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    @objc
    private func updateCounter() {
        if counter == 1 {
            timer?.invalidate()
            boardNode.turnOnPlayMode()
        } else {
            animateLabel(sound: true) {
                self.counter -= 1
                self.label.text = String(self.counter)
            }
        }
    }

    private func animateLabel(hangeTime: Double = 0.6, sound: Bool, completion: (() -> Void)? = nil) {
        let duration = 0.2
        var actionsArray: [SKAction] = []
        let show = showAction(with: duration)
        actionsArray.append(show)
        if sound {
            let sound = SKAction.playSoundFileNamed("count_down.mp3", waitForCompletion: false)
            actionsArray.append(sound)
        }
        let wait = SKAction.wait(forDuration: hangeTime)
        actionsArray.append(wait)
        let hide = hideAction(with: duration)
        actionsArray.append(hide)
        let actions = SKAction.sequence(actionsArray)
        label.run(actions) {
            completion?()
        }
    }

    private func showAction(with duration: Double) -> SKAction {
        let scale = SKAction.scale(to: 1.3, duration: duration)
        let fadeIn = SKAction.fadeIn(withDuration: duration)
        let actions = [scale, fadeIn]
        let group = SKAction.group(actions)
        return group
    }

    private func hideAction(with duration: Double) -> SKAction {
        let scale = SKAction.scale(to: 0.5, duration: duration)
        let fadeOut = SKAction.fadeOut(withDuration: duration)
        let actions = [scale, fadeOut]
        let group = SKAction.group(actions)
        return group
    }

    private func displaySummary() {
        let size = CGSize(width: 280 * scale, height: 200 * scale)
        summaryNode = SummaryNode(size: size,
                                  scale: scale,
                                  score: score,
                                  correct: correct,
                                  numberOfRounds: settings.numberOfRounds)
        summaryNode.delegate = self
        summaryNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(summaryNode)
    }

    private func handleRoundChange() {
        if roundCounter == settings.numberOfRounds {
            blurNode = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.8), size: size)
            blurNode.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(blurNode)
            menuScene = MenuScene(mode: .final, size: size)
            menuScene.scaleMode = .aspectFill
            displaySummary()
        } else {
            prepareNextRound()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.boardNode.displayTraps()
                self.turnOnCountDown()
            }
        }
    }

    private func displayFinalScene() {
        let transition = SKTransition.fade(withDuration: 1)
        view?.presentScene(menuScene, transition: transition)
    }

    // MARK: - Setup

    private func setupBoard() {
        let size = CGSize(width: frame.width - 30 * scale,
                          height: frame.width - 30 * scale)
        boardNode = BoardNode(settings: settings,
                              size: size,
                              icons: types[roundCounter].icons(),
                              scale: scale)
        boardNode.delegate = self
        boardNode.position = CGPoint(x: frame.midX, y: frame.midY - 50 * scale)
        addChild(boardNode)
    }

    private func setupLabel() {
        addChild(label)
        label.text = "Get ready!"
        label.fontSize = 25 * scale
        label.position = CGPoint(x: frame.midX, y: frame.maxY - 100 * scale)
        label.setScale(0.5)
        label.run(SKAction.fadeOut(withDuration: 0))
    }
}

extension GameScene: BoardNodeDelegate {
    func gameEnded(with result: Bool) {
        correct = result ? correct + 1 : correct
        let multiplayer = settings.board.rows * settings.board.cols * settings.numberOfTraps
        score = result ? score + multiplayer : score
        label.text = result ? "Correct!" : "Incorrect!"
        animateLabel(hangeTime: 2.6, sound: false) {
            self.handleRoundChange()
        }
    }
}

extension GameScene: SummaryNodeDelegate {
    func didTapDone() {
        displayFinalScene()
    }
}
