//
//  ButtonNode.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 19/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit

final class ButtonNode: SKSpriteNode {

    // MARK: - Views

    private let label = SKLabelNode(fontNamed: "AvenirNext-Bold")

    // MARK: - Variables

    weak var target: AnyObject?
    var action: Selector?
    var level: GameLevel!

    // MARK: - Initializers

    init(size: CGSize, texture: SKTexture? = nil) {
        super.init(texture: texture, color: .clear, size: size)
        setup()
        setupLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func setFontSize(_ fontSize: CGFloat) {
        label.fontSize = fontSize
    }

    func setTitle(_ title: String) {
        label.text = title
    }

    func setTarget(_ target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }

    // MARK: - Event handlers

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let action = action else { return }
        UIApplication.shared.sendAction(action, to: target, from: self, for: nil)
    }

    // MARK: - Setup

    private func setup() {
        isUserInteractionEnabled = true
    }

    private func setupLabel() {
        addChild(label)
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
    }
}
