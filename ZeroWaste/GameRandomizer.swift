//
//  GameRandomizer.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 18/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import Foundation

final class GameRandomizer {

    private var topLeftSector: Sector = Sector(boxes: [])
    private var topRightSector: Sector = Sector(boxes: [])
    private var bottomLeftSector: Sector = Sector(boxes: [])
    private var bottomRightSector: Sector = Sector(boxes: [])
    private var sectors: [Sector] {
        return [topLeftSector, topRightSector, bottomRightSector, bottomLeftSector]
    }

    private struct Sector {
        var boxes: [Box]
    }

    func prepareGame(for board: Board, numberOfTraps: Int) -> [[Box]] {
        let boxes = createBoxes(for: board)
        splitToSectors(boxes: boxes)
        let typedSectors = assignTypes(to: sectors, numberOfTraps: numberOfTraps)
        return typedSectors.flatMap { $0.boxes }.sort()
    }

    private func createBoxes(for board: Board) -> [Box] {
        var boxes: [Box] = []
        for i in 0 ..< board.rows {
            for j in 0 ..< board.cols {
                let position = Location(row: i, col: j)
                let box = Box(position: position)
                boxes.append(box)
            }
        }
        return boxes
    }

    private func splitToSectors(boxes: [Box]) {
        let maxBox = boxes.max(by: { $1.location > $0.location })!
        let midRow = maxBox.location.row / 2
        let midCol = maxBox.location.col / 2
        for box in boxes {
            let location = box.location
            if location.row <= midRow && location.col <= midCol {
                topLeftSector.boxes.append(box)
            } else if location.row <= midRow && location.col > midCol {
                topRightSector.boxes.append(box)
            } else if location.col <= midCol {
                bottomLeftSector.boxes.append(box)
            } else {
                bottomRightSector.boxes.append(box)
            }
        }
    }

    private func assignTypes(to sectors: [Sector], numberOfTraps: Int) -> [Sector] {

        let startIndex = Int.random(in: 0 ..< sectors.count)
        let startSector = sectors[startIndex]
        assignTypeTo(.start, randomElementIn: startSector)

        let endIndex = startIndex >= (sectors.count / 2) ? startIndex - 2 : startIndex + 2
        let endSector = sectors[endIndex]
        assignTypeTo(.end, randomElementIn: endSector)

        let shuffledSectors = sectors.shuffled()
        for i in 0 ..< numberOfTraps {
            let index = i % shuffledSectors.count
            assignTypeTo(.trap, randomElementIn: shuffledSectors[index])
        }

        return shuffledSectors
    }

    private func assignTypeTo(_ type: BoxType, randomElementIn sector: Sector) {
        var operationDone: Bool = false
        while !operationDone {
            let box = sector.boxes.randomElement()!
            guard box.type == .standard else { continue }
            box.type = type
            operationDone = true
        }
    }
}
