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
    func gameEnded(with result: Bool)
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
    private var selectedBoxes: [Box] = []
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
        let selectedBox = sortedBoxes[position.row][position.col]
        selectedBox.isSelected = true
        selectedBoxes.append(selectedBox)
        delegate?.changeSelectionBoxStatus(at: position, to: true)
    }

    func selectionContinue(to position: Location) {
        guard let _currentPosition = currentPosition,
            _currentPosition != position,
            position != endPosition,
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
            checkResult()
        } else {
            for box in selectedBoxes {
                box.isSelected = false
                delegate?.changeSelectionBoxStatus(at: box.position, to: false)
            }
            selectedBoxes = []
        }
    }

    // MARK: - checking result

    private func checkResult() {
        let traps = selectedBoxes.filter { $0.isSelected && $0.type == .trap }
        let gameResult = traps.isEmpty
        print("RESULT \(gameResult)")
        delegate?.gameEnded(with: gameResult)
    }

    // MARK: - handling move

    private func handleBackwardMove(at position: Location) {
        selectedBoxes.removeLast()
        delegate?.changeSelectionBoxStatus(at: currentPosition!, to: false)
        currentPosition = position
        sortedBoxes[position.row][position.col].isSelected = false
    }

    private func handleForwardMove(at position: Location) {
        let selectedBox = sortedBoxes[position.row][position.col]
        selectedBox.isSelected = true
        currentPosition = position
        selectedBoxes.append(selectedBox)
        delegate?.changeSelectionBoxStatus(at: position, to: true)
    }

    // MARK: - Game preparation

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
            let box = boxes.dropRandom()
            box.type = .trap
            newBoxes.append(box)
        }

        let startBox =  boxes.dropRandom()
        startPosition = startBox.position
        startBox.type = .start
        newBoxes.append(startBox)

        let endBox = boxes.dropRandom()
        endPosition = endBox.position
        endBox.type = .end
        newBoxes.append(endBox)

        newBoxes.append(contentsOf: boxes)

        return newBoxes
    }
}
