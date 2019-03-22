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

    // MARK: - Delegate

    weak var delegate: GameDelegate?

    var board = Board(rows: 5, cols: 5)
    var numberOfTraps = 5

    // MARK: - Private variables

    private var sortedBoxes: [[Box]] = []
    private var allBoxes: [Box] {
        return sortedBoxes.flatMap{ $0 }
    }
    private var selectedBoxes: [Box] = []
    private var currentLocation: Location?

    // MARK: - Public

    func prepareNewGame() {
        selectedBoxes = []
        currentLocation = nil
        sortedBoxes = GameRandomizer().prepareGame(for: board, numberOfTraps: numberOfTraps)
    }

    func box(for position: Location) -> Box {
        return sortedBoxes[position.row][position.col]
    }

    func selectingBegan(in position: Location) {
        let selectedBox = sortedBoxes[position.row][position.col]
        guard selectedBox.type == .start else { return }
        currentLocation = position
        selectedBox.isSelected = true
        selectedBoxes.append(selectedBox)
        delegate?.changeSelectionBoxStatus(at: position, to: true)
    }

    func selectionContinue(to position: Location) {
        let selectedBox = sortedBoxes[position.row][position.col]
        guard let _currentPosition = currentLocation,
            _currentPosition != position,
            position.canBeAchived(from: _currentPosition) else {
                return
        }

        if selectedBox.isSelected {
            handleBackwardMove(at: position)
        } else {
            let currentBox = sortedBoxes[_currentPosition.row][_currentPosition.col]
            guard currentBox.type != .end else { return }
            handleForwardMove(at: position)
        }
    }

    func selectionEnded() {
        guard let finalPosition = currentLocation else { return }
        let finalBox = sortedBoxes[finalPosition.row][finalPosition.col]
        if finalBox.type == .end {
            checkResult()
        } else {
            for box in selectedBoxes {
                box.isSelected = false
                delegate?.changeSelectionBoxStatus(at: box.location, to: false)
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
        delegate?.changeSelectionBoxStatus(at: currentLocation!, to: false)
        currentLocation = position
        sortedBoxes[position.row][position.col].isSelected = false
    }

    private func handleForwardMove(at position: Location) {
        let selectedBox = sortedBoxes[position.row][position.col]
        selectedBox.isSelected = true
        currentLocation = position
        selectedBoxes.append(selectedBox)
        delegate?.changeSelectionBoxStatus(at: position, to: true)
    }
}
