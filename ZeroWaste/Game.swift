//
//  Game.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 16/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import Foundation

protocol GameDelegate: class {
    func changeSelectionBoxStatus(at position: Location, to value: Bool)
    func gameEnded()
}

final class Game {

    weak var delegate: GameDelegate?

    var board = Board(rows: 5, cols: 5)
    var numberOfTraps = 5

    var sortedBoxes: [[Box]] = []
    var startPosition: Location!
    var endPosition: Location!

    private var allBoxes: [Box] {
        return sortedBoxes.flatMap{ $0 }
    }
    private var selectedPositions: [Location] = []
    private var currentPosition: Location?

    init() {

    }

    // MARK: - Public

    func prepareNewGame() {
        let boxes = createBoxes(for: board)
        sortedBoxes = randomizeGameObjects(for: boxes).sort()
    }

    func box(for position: Location) -> Box {
        return sortedBoxes[position.row][position.col]
    }

    func selectingBegan(in position: Location) {
        guard position == startPosition else { return }
        currentPosition = position
        sortedBoxes[position.row][position.col].isSelected = true
        selectedPositions.append(position)
        delegate?.changeSelectionBoxStatus(at: position, to: true)
    }

    func selectionContinue(to position: Location) {
        guard let _currentPosition = currentPosition,
            _currentPosition != position,
            position.canBeAchived(from: _currentPosition) else {
                return
        }

        if sortedBoxes[position.row][position.col].isSelected {
            handleBackwardMove(at: position)
        } else {
            handleForwardMove(at: position)
        }
    }

    func selectionEnded() {
        guard let finalPosition = currentPosition else { return }
        if finalPosition == endPosition {
            
        } else {
            for selectedPostion in selectedPositions {
                sortedBoxes[selectedPostion.row][selectedPostion.col].isSelected = false
                delegate?.changeSelectionBoxStatus(at: selectedPostion, to: false)
            }
            selectedPositions = []
        }
    }

    // MARK: - Privates

    private func handleBackwardMove(at position: Location) {
        selectedPositions.removeLast()
        delegate?.changeSelectionBoxStatus(at: currentPosition!, to: false)
        currentPosition = position
        sortedBoxes[position.row][position.col].isSelected = false
    }

    private func handleForwardMove(at position: Location) {
        sortedBoxes[position.row][position.col].isSelected = true
        currentPosition = position
        selectedPositions.append(position)
        delegate?.changeSelectionBoxStatus(at: position, to: true)
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

    private func randomizeGameObjects(for boxes: [Box]) -> [Box] {
        var boxes = boxes
        var newBoxes: [Box] = []

        for _ in 0 ..< numberOfTraps {
            var box = boxes.dropRandom()
            box.type = .trap
            newBoxes.append(box)
        }

        var startBox =  boxes.dropRandom()
        startPosition = startBox.position
        startBox.type = .start
        newBoxes.append(startBox)

        var endBox = boxes.dropRandom()
        endPosition = endBox.position
        endBox.type = .end
        newBoxes.append(endBox)

        newBoxes.append(contentsOf: boxes)

        return newBoxes
    }
}
