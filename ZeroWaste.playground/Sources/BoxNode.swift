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
    private var selectedNode: LocalizedNode!

    // MARK: - Constants

    private let animationDuration: Double = 0.5
    private let scale: CGFloat

    // MARK: - Variable

    var location: Location!
    var box: Box!
    var icons: IconsSet

    var isSelected: Bool = false {
        didSet {
            updateSelectedState()
        }
    }

    // MARk: - Initalizers

    init(box: Box, location: Location, size: CGSize, icons: IconsSet, scale: CGFloat) {
        self.scale = scale
        self.location = location
        self.box = box
        self.icons = icons
        super.init(texture: nil, color: .clear, size: size)
        texture = SKTexture(imageNamed: "dirt")
        setupSelectedNode()
        setupAsset()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func update(with box: Box, icons: IconsSet) {
        self.box = box
        self.icons = icons
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

    // MARK: - Logic

    private func updateSelectedState() {
        if isSelected {
            let sound = SKAction.playSoundFileNamed("step_grass.wav", waitForCompletion: false)
            let changeVolumeAction = SKAction.changeVolume(to: 3, duration: 0)
            let effectAudioGroup = SKAction.group([sound,changeVolumeAction])
            run(effectAudioGroup)
            let texture = SKTexture(imageNamed: "grass")
            showSelectedNode(duration: 0, texture: texture)
        } else {
            let sound = SKAction.playSoundFileNamed("step_grass.wav", waitForCompletion: false)
            let changeVolumeAction = SKAction.changeVolume(to: 3, duration: 0)
            let effectAudioGroup = SKAction.group([sound,changeVolumeAction])
            run(effectAudioGroup)
            hideSelectedNode(duration: 0)
        }
    }

    // MARK: - Animations

    private func hideAsset(with duration: Double, completion: (() -> Void)? = nil) {
        let fadeOut = SKAction.fadeOut(withDuration: duration)
        let scale = SKAction.scale(to: size, duration: 0)
        let actions = SKAction.sequence([fadeOut, scale])
        assetNode.run(actions, completion: {
            completion?()
        })
    }

    private func showAsset(with duration: Double, with texture: SKTexture) {
        let showTexture = SKAction.setTexture(texture, resize: true)
        let scale = assetNode.scaleToFit(size: size, texture: texture, offset: 15 * self.scale)
        let rescale = SKAction.scale(to: scale, duration: 0)
        let fadeIn = SKAction.fadeIn(withDuration: duration)
        let actions = SKAction.sequence([showTexture, rescale, fadeIn])
        assetNode.run(actions)
    }

    private func showSelectedNode(duration: Double, texture: SKTexture) {
        let showTexture = SKAction.setTexture(texture)
        let fadeIn = SKAction.fadeIn(withDuration: duration)
        let actions = SKAction.sequence([showTexture, fadeIn])
        selectedNode.run(actions)
    }

    private func hideSelectedNode(duration: Double) {
        let fadeOut = SKAction.fadeOut(withDuration: duration)
        selectedNode.run(fadeOut)
    }

    // MARK: - Setup

    private func setupSelectedNode() {
        selectedNode = LocalizedNode(color: .clear, size: size)
        selectedNode.location = location
        selectedNode.position = .zero
        addChild(selectedNode)
    }

    private func setupAsset() {
        assetNode = LocalizedNode(color: .clear, size: size)
        assetNode.location = location
        assetNode.position = .zero
        assetNode.isUserInteractionEnabled = false
        addChild(assetNode)
        hideAsset(with: 0)
    }

    private func setupForInitialMode() {
        hideAsset(with: animationDuration)
        hideSelectedNode(duration: animationDuration)
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
                    let texture = SKTexture(imageNamed: imageString)
                    self.showAsset(with: self.animationDuration, with: texture)
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
            selectedNode.texture = SKTexture(imageNamed: "red")
        }
    }

    private func imageAsset(for type: BoxType) -> String? {
        var imageAsset: String
        switch box.type {
        case .standard:
            return nil
        case .start:
            imageAsset = icons.trash
        case .end:
            imageAsset = icons.bin
        case .trap:
            imageAsset = "trap.png"
        }
        return imageAsset
    }
}
