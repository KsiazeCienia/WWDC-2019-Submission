//
//  SummaryNode.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 24/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit

final class SummaryNode: SKSpriteNode {

    private let smallFontSize: CGFloat = 18

    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "summary")
        super.init(texture: texture, color: .clear, size: size)
        setupSummaryLabel()
        setupScoreLabel()
        setupScore()
        setupCorrect()
        setupCorrectLabel()
        setupDoneButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSummaryLabel() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = 26
        label.text = "Summary"
        label.position = CGPoint(x: frame.midX,y: frame.maxY - 50)
        addChild(label)
    }

    private func setupScoreLabel() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = smallFontSize
        label.text = "Score:"
        label.position = CGPoint(x: frame.minX + 60, y: frame.midY + 5)
        addChild(label)
    }

    private func setupScore() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = smallFontSize
        label.text = "1400"
        label.position = CGPoint(x: frame.maxX - 60, y: frame.midY + 5)
        addChild(label)
    }

    private func setupCorrectLabel() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = smallFontSize
        label.text = "Correct:"
        label.position = CGPoint(x: frame.minX + 67, y: frame.midY - 25)
        addChild(label)
    }

    private func setupCorrect() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = smallFontSize
        label.text = "2/5"
        label.position = CGPoint(x: frame.maxX - 53, y: frame.midY - 25)
        addChild(label)
    }

    private func setupDoneButton() {
        let size = CGSize(width: 160, height: 40)
        let texture = SKTexture(imageNamed: "done")
        let button = ButtonNode(size: size, texture: texture)
        button.setTitle("Done")
        button.setFontSize(22)
        button.position = CGPoint(x: frame.midX, y: frame.minY + 35)
        addChild(button)
    }
}
