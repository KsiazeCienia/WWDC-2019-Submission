//
//  BoardNode.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 18/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit

protocol BoardNodeDelegate: class {
    func gameEnded(with result: Bool)
}

final class BoardNode: SKSpriteNode {

    // MARK: - Constants

    private let scale = UIScreen.main.bounds.height / 667
    private lazy var itemSpacing: CGFloat = 5 * scale

    // MARK: - Variables

    private let settings: GameSettings
    private let game: Game
    private var icons: IconsSet
    private var sortedBoxes: [[BoxNode]] = []
    private var boxes: [BoxNode] {
        return sortedBoxes.flatMap { $0 }
    }

    // MARK: - Delegates

    weak var delegate: BoardNodeDelegate?

    // MARK: - Initializers

    init(settings: GameSettings, size: CGSize, icons: IconsSet) {
        self.settings = settings
        self.game = Game(settings: settings)
        self.icons = icons
        super.init(texture: nil, color: .clear, size: size)
        isUserInteractionEnabled = true
        game.delegate = self
        game.prepareNewGame()
        setupBoard()
        changeBoxMode(to: .initial)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Game logic

    func prepareNewGame(with icons: IconsSet) {
        game.prepareNewGame()
        boxes.forEach {
            $0.update(with: game.box(for: $0.location), icons: icons)
        }
        changeBoxMode(to: .initial)
    }

    func displayTraps() {
        changeBoxMode(to: .prepare)
    }

    func turnOnPlayMode() {
        changeBoxMode(to: .play)
    }

    private func changeBoxMode(to phase: GamePhase) {
        boxes.forEach { $0.updatePhase(phase) }
    }

    // MARK: - Event handlers

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let box = atPoint(location) as? Localizable else { return }
        game.selectingBegan(in: box.location)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let box = atPoint(location) as? Localizable else { return }
        game.selectionContinue(to: box.location)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        game.selectionEnded()
    }

    // MARK: - Board setup

    private func setupBoard() {
        let board = settings.board
        for row in 0 ..< board.rows {
            var rowBox: [BoxNode] = []
            for col in 0 ..< board.cols {
                let size = sizeForNode()
                let location =  Location(row: row, col: col)
                let box = game.box(for: location)
                let node = BoxNode(box: box, location: location, size: size, icons: icons)
                node.position = position(for: location, size: size)
                addChild(node)
                rowBox.append(node)
            }
            sortedBoxes.append(rowBox)
        }
    }

    private func sizeForNode() -> CGSize {
        let board = settings.board
        let height = (size.width - itemSpacing * CGFloat(board.cols + 1)) / CGFloat(board.cols)
        let width = (size.height - itemSpacing * CGFloat(board.rows + 1)) / CGFloat(board.rows)
        return CGSize(width: width, height: width)
    }

    private func position(for location: Location, size: CGSize) -> CGPoint {
        let x = frame.minX + CGFloat(location.row) * (size.width + itemSpacing) + itemSpacing + size.width * 0.5
        let y = frame.minY + CGFloat(location.col) * (size.height + itemSpacing) + itemSpacing + size.height * 0.5
        return CGPoint(x: x, y: y)
    }
}

extension BoardNode: GameDelegate {
    func gameEnded(with result: Bool) {
        boxes.forEach { $0.updatePhase(.end) }
        delegate?.gameEnded(with: result)
    }

    func changeSelectionBoxStatus(at position: Location, to value: Bool) {
        sortedBoxes[position.row][position.col].isSelected = value
    }
}
