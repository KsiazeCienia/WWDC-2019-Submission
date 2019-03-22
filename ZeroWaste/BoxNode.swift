//
//  BoxNode.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 18/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit

protocol Localizable: class {
    var location: Location! { get set }
}

final class BoxNode: SKSpriteNode, Localizable {

    // MARK: - Views

    private var assetNode: LocalizedNode!

    // MARK: - Constants

    private let animationDuration: Double = 0.5

    // MARK: - Variable

    var location: Location!
    var box: Box!

    var isSelected: Bool = false {
        didSet {
            let imageName = box.isSelected ? "grass" : "dirt"
            texture = SKTexture(imageNamed: imageName)
        }
    }

    // MARk: - Initalizers

    init(box: Box, location: Location, size: CGSize) {
        self.location = location
        super.init(texture: nil, color: .clear, size: size)
        setup(with: box)
        setupAsset()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func setup(with box: Box) {
        self.box = box
         let imageName = box.isSelected ? "grass" : "dirt"
        texture = SKTexture(imageNamed: imageName)
        guard box.type != .standard else { return }
//        texture = SKTexture(imageNamed: imageAsset(for: box.type))
    }

    func updatePhase(_ phase: GamePhase) {
        switch phase {
        case .prepare:
            setupForPrepareMode()
        case .play:
            setupForPlayMode()
        case .end:
            setupForEndMode()
        case .initial:
            setupForInitialMode()
        }
    }

    // MARK: - Private

    private func hideAsset(with duration: Double) {
        let fadeOut = SKAction.fadeOut(withDuration: duration)
        assetNode.run(fadeOut)
    }

    private func showAsset(with duration: Double) {
        let fadeIn = SKAction.fadeIn(withDuration: duration)
        assetNode.run(fadeIn)
    }

    private func setupAsset() {
        guard box.type != .standard else { return }
        let imageString = imageAsset(for: box.type)
        assetNode = LocalizedNode(imageNamed: imageString)
        assetNode.location = location
        assetNode.position = position
        assetNode.size = size
        assetNode.isUserInteractionEnabled = false
        hideAsset(with: 0)
        addChild(assetNode)
    }

    private func setupForInitialMode() {
//        hideAsset(with: 0)
    }

    private func setupForPrepareMode() {
        switch box.type {
        case .standard:
            return
        case .start, .end:
            hideAsset(with: animationDuration)
        case .trap:
            showAsset(with: animationDuration)
        }
    }

    private func setupForPlayMode() {
        switch box.type {
        case .standard:
            return
        case .start, .end:
            showAsset(with: animationDuration)
        case .trap:
            hideAsset(with: animationDuration)
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
            imageAsset = "plastic_bottle"
        case .end:
            imageAsset = "trash"
        case .trap:
            imageAsset = "trap.png"
        }
        return imageAsset
    }
}
