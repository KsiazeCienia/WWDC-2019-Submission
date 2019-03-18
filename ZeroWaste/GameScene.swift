//
//  GameScene.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 16/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var board: Board = Board(rows: 5, cols: 5)
    
    override func didMove(to view: SKView) {
        setupBoard()
    }

    private func setupBoard() {
        let size = CGSize(width: frame.width - 30, height: frame.width - 30)
        let boardNode = BoardNode(board: board, size: size)
        boardNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(boardNode)
    }
}
