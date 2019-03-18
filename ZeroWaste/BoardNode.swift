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


    init(board: Board, size: CGSize) {
        self.board = board
        super.init(texture: nil, color: .clear, size: size)
        setupBoard()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBoard() {
        for row in 0 ..< board.rows {
            for col in 0 ..< board.cols {
                let size = sizeForNode()
                let node = SKSpriteNode(color: .red, size: size)
                node.position = point(for: Position(row: row, col: col),
                                      size: size)
                addChild(node)
            }
        }
    }

    private func sizeForNode() -> CGSize {
        let width = (size.width - itemSpacing * CGFloat(board.cols + 1)) / CGFloat(board.cols)
        let height = (size.height - itemSpacing * CGFloat(board.rows + 1)) / CGFloat(board.rows)
        return CGSize(width: width, height: height)
    }

    private func point(for position: Position, size: CGSize) -> CGPoint {
        let x = frame.minX + CGFloat(position.row) * (size.width + itemSpacing) + itemSpacing + size.width * 0.5
        let y = frame.minY + CGFloat(position.col) * (size.height + itemSpacing) + itemSpacing + size.height * 0.5
        return CGPoint(x: x, y: y)
    }
}
