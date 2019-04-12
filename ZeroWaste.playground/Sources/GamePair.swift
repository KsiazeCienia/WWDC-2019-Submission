//
//  GamePair.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 24/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import Foundation

struct IconsSet {
    let trash: String
    let bin: String
}

enum GameType {
    case paper
    case metal
    case bio
    case plastic
    case glass

    func icons() -> IconsSet {
        switch self {
        case .paper:
            return IconsSet(trash: "paper", bin: "blue_bin")
        case .metal:
            return IconsSet(trash: "metal", bin: "red_bin")
        case .bio:
            return IconsSet(trash: "apple", bin: "gray_bin")
        case .plastic:
            return IconsSet(trash: "plastic", bin: "yellow_bin")
        case .glass:
            return IconsSet(trash: "glass", bin: "green_bin")
        }
    }
}
