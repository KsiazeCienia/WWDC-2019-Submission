//
//  BoxNode.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 18/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit

final class BoxNode: SKSpriteNode {

    var location: Location!

    var isSelected: Bool = false {
        didSet {
            color = isSelected ? .green : .brown
        }
    }
}
