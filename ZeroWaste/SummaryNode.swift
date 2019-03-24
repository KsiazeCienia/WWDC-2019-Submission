//
//  SummaryNode.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 24/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit

protocol SummaryNodeDelegate: class {
    func didTapDone()
}

final class SummaryNode: SKSpriteNode {

    weak var delegate: SummaryNodeDelegate?

    private lazy var smallFontSize: CGFloat = 18 * scale
    private let scale: CGFloat

    init(size: CGSize, scale: CGFloat, score: Int, correct: Int, numberOfRounds: Int) {
        self.scale = scale
        let texture = SKTexture(imageNamed: "summary")
        super.init(texture: texture, color: .clear, size: size)
        setupSummaryLabel()
        setupScoreLabel()
        setupScore(with: score)
        setupCorrect(with: correct, numberOfRounds: numberOfRounds)
        setupCorrectLabel()
        setupDoneButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Event handlers

    @objc
    private func doneTapped() {
        delegate?.didTapDone()
    }

    // MARK: - Setup

    private func setupSummaryLabel() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = 26 * scale
        label.text = "Summary"
        label.position = CGPoint(x: frame.midX,y: frame.maxY - 50 * scale)
        addChild(label)
    }

    private func setupScoreLabel() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = smallFontSize
        label.text = "Score:"
        label.position = CGPoint(x: frame.minX + 60 * scale, y: frame.midY + 5 * scale)
        addChild(label)
    }

    private func setupScore(with score: Int) {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = smallFontSize
        label.text = "\(score)"
        label.position = CGPoint(x: frame.maxX - 60 * scale, y: frame.midY + 5 * scale)
        addChild(label)
    }

    private func setupCorrectLabel() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = smallFontSize
        label.text = "Correct:"
        label.position = CGPoint(x: frame.minX + 67 * scale, y: frame.midY - 25 * scale)
        addChild(label)
    }

    private func setupCorrect(with correct: Int, numberOfRounds: Int) {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = smallFontSize
        label.text = "\(correct)/\(numberOfRounds)"
        label.position = CGPoint(x: frame.maxX - 53 * scale, y: frame.midY - 25 * scale)
        addChild(label)
    }

    private func setupDoneButton() {
        let size = CGSize(width: 160 * scale, height: 40 * scale)
        let texture = SKTexture(imageNamed: "done")
        let button = ButtonNode(size: size, texture: texture)
        button.setTitle("Done")
        button.setFontSize(22 * scale)
        button.position = CGPoint(x: frame.midX, y: frame.minY + 35 * scale)
        button.setTarget(self, action: #selector(doneTapped))
        addChild(button)
    }
}
