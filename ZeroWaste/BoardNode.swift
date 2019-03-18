//
//  BoardNode.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 18/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit

final class BoardNode: SKSpriteNode {

    // MARK: - Constants

    private let itemSpacing: CGFloat = 5

    private let board: Board

    // MARK: - Variables

    private var game = Game()
    private var sortedBoxes: [[BoxNode]] = []
    private var boxes: [BoxNode] {
        return sortedBoxes.flatMap { $0 }
    }

    // MARK: - Initializers

    init(board: Board, size: CGSize) {
        self.board = board
        super.init(texture: nil, color: .clear, size: size)
        setupBoard()
        game.delegate = self
        game.prepareNewGame()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Event handlers

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let selectedView = atPoint(location)
        let selectedBox = boxes.first { $0 === selectedView }
        guard let boxView = selectedBox else { return }
        game.selectingBegan(in: boxView.location)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let selectedView = atPoint(location)
        let selectedBox = boxes.first { $0 === selectedView }
        guard let boxView = selectedBox else { return }
        game.selectionContinue(to: boxView.location)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        game.selectionEnded()
    }

    // MARK: - Board setup

    private func setupBoard() {
        for row in 0 ..< board.rows {
            for col in 0 ..< board.cols {
                let size = sizeForNode()
                let location =  Location(row: row, col: col)
                let node = BoxNode(color: .red, size: size)
                node.location = location
                node.position = position(for: location, size: size)
                addChild(node)
            }
        }
    }

    private func sizeForNode() -> CGSize {
        let width = (size.width - itemSpacing * CGFloat(board.cols + 1)) / CGFloat(board.cols)
        let height = (size.height - itemSpacing * CGFloat(board.rows + 1)) / CGFloat(board.rows)
        return CGSize(width: width, height: height)
    }

    private func position(for location: Location, size: CGSize) -> CGPoint {
        let x = frame.minX + CGFloat(location.row) * (size.width + itemSpacing) + itemSpacing + size.width * 0.5
        let y = frame.minY + CGFloat(location.col) * (size.height + itemSpacing) + itemSpacing + size.height * 0.5
        return CGPoint(x: x, y: y)
    }
}

extension BoardNode: GameDelegate {
    func changeSelectionBoxStatus(at position: Location, to value: Bool) {
        sortedBoxes[position.row][position.col].isSelected = value
    }

    func gameEnded() {

    }
}
