//
//  BoxView.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 16/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import UIKit

final class BoxView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? .green : .brown
        }
    }

    var position: Location!
    var box: Box!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupLayout()
    }

    func setPlayMode() {
        switch box.type {
        case .start, .end:
            imageView.isHidden = false
        default:
            imageView.isHidden = true
        }
    }

    func setPrepareMode() {
        switch box.type {
        case .start, .end:
            imageView.isHidden = true
        default:
            imageView.isHidden = false
        }
    }

    func setup(with box: Box) {
        self.box = box

        backgroundColor = box.isSelected ? .green : .brown

        var imageAsset: String
        switch box.type {
        case .standard:
            return
        case .start:
            imageAsset = "waste.png"
        case .end:
            imageAsset = "bin.png"
        case .trap:
            imageAsset = "trap.png"
        }
        imageView.image = UIImage(named: imageAsset)
    }

    private func setupView() {
        backgroundColor = .brown
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
