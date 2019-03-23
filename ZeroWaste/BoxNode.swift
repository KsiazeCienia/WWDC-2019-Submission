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

    private var assetNode: LocalizedNode?

    // MARK: - Constants

    private let animationDuration: Double = 0.5

    // MARK: - Variable

    var location: Location!
    var box: Box!

    var isSelected: Bool = false {
        didSet {
            let imageName = isSelected ? "grass" : "dirt"
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

    func update(with box: Box) {
        self.box = box
        isSelected = false
        hideAsset(with: animationDuration)
//        hideAsset(with: animationDuration) {
//            self.removeChildren(in: [assetNode])
//            self.setupAsset()
//        }
    }


    func updatePhase(_ phase: GamePhase) {
        switch phase {
        case .initial:
            setupForInitialMode()
        case .prepare:
            setupForPrepareMode()
        case .play:
            setupForPlayMode()
        case .end:
            setupForEndMode()
        }
    }

    // MARK: - Private

    private func setup(with box: Box) {
        self.box = box
        let imageName = box.isSelected ? "grass" : "dirt"
        texture = SKTexture(imageNamed: imageName)
    }

    private func hideAsset(with duration: Double, completion: (() -> Void)? = nil) {
        let fadeOut = SKAction.fadeOut(withDuration: duration)
        assetNode?.run(fadeOut, completion: {
            completion?()
        })
    }

    private func showAsset(with duration: Double, with texture: SKTexture) {
        let showTexture = SKAction.setTexture(texture)
        let fadeIn = SKAction.fadeIn(withDuration: duration)
        let actions = SKAction.sequence([showTexture, fadeIn])
        assetNode?.run(actions)
    }

    private func setupAsset() {
        assetNode = LocalizedNode(color: .clear, size: size)
        assetNode?.location = location
        assetNode?.position = .zero
        assetNode?.size = size
        assetNode?.isUserInteractionEnabled = false
        addChild(assetNode!)
        hideAsset(with: 0)
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
            let texture = SKTexture(imageNamed: "trap")
            showAsset(with: animationDuration, with: texture)
        }
    }

    private func setupForPlayMode() {
        switch box.type {
        case .standard:
            return
        case .start, .end:
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                if let imageString = self.imageAsset(for: self.box.type) {
                    self.showAsset(with: self.animationDuration, with: SKTexture(imageNamed: imageString))
                }
            }
        case .trap:
            hideAsset(with: animationDuration)
        }
    }

    private func setupForEndMode() {
        guard box.type != .standard else { return }
        if let imageString = imageAsset(for: box.type) {
            showAsset(with: animationDuration, with: SKTexture(imageNamed: imageString))
        }
        if box.type == .trap && isSelected {
            texture = SKTexture(imageNamed: "wrong")
        }
    }

    private func imageAsset(for type: BoxType) -> String? {
        var imageAsset: String
        switch box.type {
        case .standard:
            return nil
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
