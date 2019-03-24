//
//  LevelHandler.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 24/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit

protocol LevelHandlerDelegate: class {
    func didSelectLevel(_ level: GameLevel)
}

final class LevelHandler: SKSpriteNode {

    private let scale: CGFloat
    weak var delegate: LevelHandlerDelegate?

    init(levels: [GameLevel], scale: CGFloat, size: CGSize) {
        self.scale = scale
        let texture = SKTexture(imageNamed: "summary")
        super.init(texture: texture, color: .clear, size: size)
        setupButtons(levels: levels)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButtons(levels: [GameLevel]) {
        let spacing: CGFloat = 20
        let itemHeight = (size.height - spacing * CGFloat(levels.count + 1)) / CGFloat(levels.count)

        for (index, level) in levels.enumerated() {
            let width = size.width - 40 * scale
            let itemSize = CGSize(width: width, height: itemHeight)
            let texture = SKTexture(imageNamed: "done")
            let button = ButtonNode(size: itemSize, texture: texture)
            button.level = level
            button.setTarget(self, action: #selector(buttonTapped))
            let y = frame.minY + CGFloat(index) * (itemSize.height + spacing) + spacing + itemSize.height * 0.5
            button.position = CGPoint(x: frame.midX, y: y)
            button.setTitle(level.rawValue)
            button.setFontSize(18 * scale)
            addChild(button)
        }
    }

    @objc
    private func buttonTapped(_ button: ButtonNode) {
        delegate?.didSelectLevel(button.level)
    }

}
