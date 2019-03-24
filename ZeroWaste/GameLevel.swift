//
//  GameLevel.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 24/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import Foundation

public enum GameLevel {
    case easy
    case medium
    case hard

    func settings() -> GameSettings {
        switch self {
        case .easy:
            let board = Board(rows: 5, cols: 5)
            let settings = GameSettings(prepareTime: 5,
                                        numberOfRounds: 5,
                                        numberOfTraps: 5,
                                        board: board)
            return settings
        case .medium:
            let board = Board(rows: 5, cols: 5)
            let settings = GameSettings(prepareTime: 3,
                                        numberOfRounds: 3,
                                        numberOfTraps: 7,
                                        board: board)
            return settings
        case .hard:
            let board = Board(rows: 6, cols: 6)
            let settings = GameSettings(prepareTime: 3,
                                        numberOfRounds: 5,
                                        numberOfTraps: 9,
                                        board: board)
            return settings
        }
    }
}
