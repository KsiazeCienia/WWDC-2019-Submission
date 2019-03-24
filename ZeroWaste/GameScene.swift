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

    struct GameSettings {
        static let prepareTimer: Int = 3
        static let numberOfRounds: Int = 5
        static let board: Board = Board(rows: 5, cols: 5)
    }

    // MARK: - Views

    private var boardNode: BoardNode!
    private let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private var timer: Timer?
    private let prepareTime: Int = 3
    private var types: [GameType] = [.paper, .metal, .bio, .plastic, .glass].shuffled()
    private var counter: Int = 0
    private var roundCounter: Int = 0

    // MARK: - Variables

    var board: Board = Board(rows: 5, cols: 5)
    private let scale = UIScreen.main.bounds.height / 667

    // MARk: - Scene life cycle
    
    override func didMove(to view: SKView) {
        setupBoard()
        setupLabel()
        roundCounter += 1
        animateLabel { [unowned self] in
            self.turnOnCountDown()
            self.boardNode?.displayTraps()
        }
    }

    // MARK: - Logic

    private func turnOnCountDown() {
        counter = prepareTime
        self.label.text = String(self.counter)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    @objc
    private func updateCounter() {
        if counter == 1 {
            timer?.invalidate()
            boardNode.turnOnPlayMode()
        } else {
            animateLabel {
                self.counter -= 1
                self.label.text = String(self.counter)
            }
        }
    }

    private func animateLabel(hangeTime: Double = 0.6, completion: (() -> Void)? = nil) {
        let duration = 0.2
        let show = showAction(with: duration)
        let wait = SKAction.wait(forDuration: hangeTime)
        let hide = hideAction(with: duration)
        let actions = SKAction.sequence([show, wait, hide])
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

    // MARK: - Setup

    private func setupBoard() {
        let size = CGSize(width: frame.width - 30 * scale, height: frame.width - 30 * scale)
        boardNode = BoardNode(board: board, size: size, icons: types[roundCounter].icons())
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
        if roundCounter == GameSettings.numberOfRounds {

        } else {
            label.text = result ? "Correct!" : "Incorrect!"
            animateLabel(hangeTime: 2.6) {
                self.roundCounter += 1
                self.boardNode.prepareNewGame(with: self.types[self.roundCounter - 1].icons())
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.boardNode.displayTraps()
                    self.turnOnCountDown()
                }
            }
        }
    }
}
