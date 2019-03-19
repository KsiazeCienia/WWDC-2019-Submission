//
//  MenuScene.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 19/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit

final class MenuScene: SKScene {

    // MARK: - Views

    var button: ButtonNode!

    // MARK: - Scene's life cycle

    override func didMove(to view: SKView) {
        setupButton()
    }

    // MARK: - Event handlers

    @objc
    private func playTapped() {
        
    }

    // MARK: - Setup

    private func setupButton() {
        let size = CGSize(width: 200, height: 40)
        button = ButtonNode(size: size)
        button.position = CGPoint(x: frame.midX, y: frame.midY)
        button.setTarget(self, action: #selector(playTapped))
        button.setTitle("KURWY")
        addChild(button)
    }
}
