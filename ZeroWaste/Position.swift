//
//  Position.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 17/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import Foundation

struct Position: Equatable {
    let row: Int
    let col: Int

    func isInOneLine(from position: Position) -> Bool {
        return row == position.row || col == position.col
    }

    func canBeAchived(from position: Position) -> Bool {
        let areInOneLine = row == position.row || col == position.col
        let areClose = (abs(row - position.row) <= 1) && (abs(col - position.col) <= 1)
        return areClose && areInOneLine
    }

    func findConnector(to position: Position) -> Position {
        return Position(row: row, col: position.col)
    }

    func postions(between postion: Position) -> [Position] {
        let position1 = Position(row: row, col: postion.col)
        let position2 = Position(row: postion.row, col: col)
        return [position1, position2]
    }

    static func random(in board: Board) -> Position {
        let row = Int.random(in: 0 ..< board.rows)
        let col = Int.random(in: 0 ..< board.cols)
        return Position(row: row, col: col)
    }

    static func == (lhs: Position, rhs: Position) -> Bool {
        return (lhs.col == rhs.col) && (rhs.row == lhs.row)
    }

    static func > (lhs: Position, rhs: Position) -> Bool {
        if lhs.row > rhs.row {
            return true
        } else {
            return lhs.col > rhs.col
        }
    }
}
