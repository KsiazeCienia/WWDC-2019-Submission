//
//  ArrayExtansion.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 17/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import Foundation

extension Array {

    mutating func dropRandom() -> Element {
        let randomIndex = Int.random(in: 0 ..< count)
        let droppedElement = remove(at: randomIndex)
        return droppedElement
    }
}

extension Array where Element == Box {

    func sort() -> [[Box]] {
        guard let maxPosition = self.max(by: { $1.position > $0.position })?.position else {
            return []
        }

        var sortedBoxes: [[Box]] = []
        for row in 0 ... maxPosition.row {
            var rowBox: [Box] = []
            for col in 0 ... maxPosition.col {
                let position = Position(row: row, col: col)
                let box = first(where: { $0.position == position })!
                rowBox.append(box)
            }
            sortedBoxes.append(rowBox)
        }

        return sortedBoxes
    }
}
