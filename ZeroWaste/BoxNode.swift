//
//  BoxNode.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 18/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit

final class BoxNode: SKSpriteNode {

    var location: Location!
    var box: Box!

    var isSelected: Bool = false {
        didSet {
            color = isSelected ? .green : .brown
        }
    }

    func setup(with box: Box) {
        self.box = box
        color = box.isSelected ? .green : .brown
        guard box.type != .standard else { return }
        texture = SKTexture(imageNamed: imageAsset(for: box.type))
    }

    func updatePhase(_ phase: GamePhase) {
        switch phase {
        case .prepare:
            setupForPrepareMode()
        case .play:
            setupForPlayMode()
        case .end:
            setupForEndMode()
        }
    }

    private func setupForPrepareMode() {
        switch box.type {
        case .standard:
            return
        case .start, .end:
            texture = nil
        case .trap:
            texture = SKTexture(imageNamed: imageAsset(for: box.type))
        }
    }

    private func setupForPlayMode() {
        switch box.type {
        case .standard:
            return
        case .start, .end:
            texture = SKTexture(imageNamed: imageAsset(for: box.type))
        case .trap:
            texture = nil
        }
    }

    private func setupForEndMode() {
        guard box.type != .standard else { return }
        texture = SKTexture(imageNamed: imageAsset(for: box.type))
    }

    private func imageAsset(for type: BoxType) -> String {
        var imageAsset: String
        switch box.type {
        case .standard:
            imageAsset = ""
        case .start:
            imageAsset = "waste.png"
        case .end:
            imageAsset = "bin.png"
        case .trap:
            imageAsset = "trap.png"
        }
        return imageAsset
    }
}
