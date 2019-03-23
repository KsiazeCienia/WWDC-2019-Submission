//
//  SKSpriteNodeExtensions.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 19/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {

    func aspectFitToSize(_ fitSize: CGSize) {
        guard let texture = texture else { return }

        size = texture.size()
        let verticalRatio = fitSize.height / texture.size().height
        let horizontalRatio = fitSize.width /  texture.size().width
        let scaleRatio = min(verticalRatio, horizontalRatio)

        self.setScale(scaleRatio)
    }

    func scaleToFit(size: CGSize, texture: SKTexture, offset: CGFloat = 0) -> CGFloat {
        let verticalRatio = (size.height - offset) / texture.size().height
        let horizontalRatio = (size.width - offset) / texture.size().width
        let scaleRatio = min(verticalRatio, horizontalRatio)
        return scaleRatio
    }


}
