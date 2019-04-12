//
//  Location.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 17/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import Foundation

struct Location: Equatable {
    let row: Int
    let col: Int

    func canBeAchived(from location: Location) -> Bool {
        let areInOneLine = row == location.row || col == location.col
        let areClose = (abs(row - location.row) <= 1) && (abs(col - location.col) <= 1)
        return areClose && areInOneLine
    }

    func findConnector(to location: Location) -> Location {
        return Location(row: row, col: location.col)
    }

    func postions(between location: Location) -> [Location] {
        let position1 = Location(row: row, col: location.col)
        let position2 = Location(row: location.row, col: col)
        return [position1, position2]
    }

    static func random(in board: Board) -> Location {
        let row = Int.random(in: 0 ..< board.rows)
        let col = Int.random(in: 0 ..< board.cols)
        return Location(row: row, col: col)
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        return (lhs.col == rhs.col) && (rhs.row == lhs.row)
    }

    static func > (lhs: Location, rhs: Location) -> Bool {
        if lhs.row > rhs.row {
            return true
        } else {
            return lhs.col > rhs.col
        }
    }
}
