//
//  Box.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 17/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import Foundation

final class Box {

    let location: Location
    var isSelected: Bool
    var type: BoxType

    init(position: Location) {
        self.location = position
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
