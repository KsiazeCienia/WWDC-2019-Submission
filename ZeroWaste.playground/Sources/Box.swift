//
//  Box.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 17/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import GameplayKit

final class Box {

    let location: Location
    let node: GKGraphNode
    var isSelected: Bool
    var type: BoxType

    init(position: Location, node: GKGraphNode) {
        self.location = position
        self.isSelected = false
        self.type = .standard
        self.node = node
    }
}

enum BoxType {
    case standard
    case start
    case end
    case trap
}
