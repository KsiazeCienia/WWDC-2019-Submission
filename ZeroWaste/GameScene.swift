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
    private let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private var timer: Timer?
    private var counter: Int = 0
    private let prepareTime: Int = 3

    // MARK: - Variables

    var board: Board = Board(rows: 5, cols: 5)

    // MARk: - Scene life cycle
    
    override func didMove(to view: SKView) {
        setupBoard()
        setupLabel()
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

    private func animateLabel(completion: (() -> Void)? = nil) {
        let duration = 0.2
        let show = showAction(with: duration)
        let wait = SKAction.wait(forDuration: 0.6)
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
        let size = CGSize(width: frame.width - 30, height: frame.width - 30)
        boardNode = BoardNode(board: board, size: size)
        boardNode.delegate = self
        boardNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(boardNode)
    }

    private func setupLabel() {
        addChild(label)
        label.text = "Prepare"
        label.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        label.setScale(0.5)
        label.run(SKAction.fadeOut(withDuration: 0))
    }
}

extension GameScene: BoardNodeDelegate {
    func gameEnded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.boardNode.prepareNewGame()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.boardNode.displayTraps()
                self.turnOnCountDown()
            }
        }
    }
}
