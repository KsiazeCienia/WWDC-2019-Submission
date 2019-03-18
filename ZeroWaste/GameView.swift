//
//  GameView.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 16/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import UIKit

final class GameView: UIView {

    // MARK: - Constants

    private let boxSpacing: CGFloat = 5
    private let prepareTime: TimeInterval = 3

    // MARK: - Views

    private lazy var boardView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = boxSpacing
        stackView.distribution = .fillEqually
        return stackView
    }()
    private var sortedBoxes: [[BoxView]] = []
    private var boxes: [BoxView] {
        return sortedBoxes.flatMap { $0 }
    }

    // MARK: - Variables

    var game = Game()

    private var timer: Timer?


    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        game.delegate = self
        game.prepareNewGame()
        setupLayout()
        initalizeBoard()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        game.delegate = self
        game.prepareNewGame()
        setupLayout()
        initalizeBoard()
    }

    // MARK: - Public

    func startGame() {
        turnOnPrepareMode()
        timer = Timer.scheduledTimer(timeInterval: prepareTime, target: self, selector: #selector(turnOnPlayMode), userInfo: nil, repeats: false)
    }

    // MARK: - Game logic

    @objc
    private func turnOnPlayMode() {
        boxes.forEach { $0.setPlayMode() }
    }

    private func turnOnPrepareMode() {
        boxes.forEach { $0.setPrepareMode() }
    }

    // MARK: - Event handlers

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let selectedView = hitTest(location, with: event)
        let selectedBox = boxes.first { $0 === selectedView }
        guard let boxView = selectedBox else { return }
        game.selectingBegan(in: boxView.position)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let selectedView = hitTest(location, with: event)
        let selectedBox = boxes.first { $0 === selectedView }
        guard let boxView = selectedBox else { return }
        game.selectionContinue(to: boxView.position)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        game.selectionEnded()
    }

    // MARK: - Setup

    private func initalizeBoard() {
        for i in 0 ..< game.board.rows {
            let stackView = createHorizontalStackView()
            var boxRow: [BoxView] = []
            for j in 0 ..< game.board.cols {
                let boxView = BoxView(frame: .zero)
                let position = Location(row: i, col: j)
                boxView.position = position
                boxView.setup(with: game.box(for: position))
                stackView.addArrangedSubview(boxView)
                boxRow.append(boxView)
            }
            sortedBoxes.append(boxRow)
            boardView.addArrangedSubview(stackView)
        }
    }

    private func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = boxSpacing
        return stackView
    }

    private func setupLayout() {
        addSubview(boardView)

        NSLayoutConstraint.activate([
            boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor),
            boardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            boardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            boardView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension GameView: GameDelegate {
    func gameEnded() {
        
    }

    func changeSelectionBoxStatus(at position: Location, to value: Bool) {
        sortedBoxes[position.row][position.col].isSelected = value
    }
}
