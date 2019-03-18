//
//  Box.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 17/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import Foundation

struct Box {

    let position: Position
    var isSelected: Bool
    var type: BoxType

    init(position: Position) {
        self.position = position
        self.isSelected = false
        self.type = .standard
    }
}

enum BoxType {
    case standard
    case start
    case end
    case trap
}
