//
//  GameRandomizer.swift
//  ZeroWaste
//
//  Created by Marcin Włoczko on 18/03/2019.
//  Copyright © 2019 Marcin Włoczko. All rights reserved.
//

import GameplayKit

final class GameRandomizer {

    func prepareGame(for board: Board, numberOfTraps: Int) -> [[Box]] {
        var graph: GKGridGraph<GKGridGraphNode>
        var readyBoxes:[[Box]] = []
        while true {
            let boxes = createBoxes(for: board)
            graph = GKGridGraph(nodes: boxes.flatMap{ $0 }.map { $0.node })
            if let randomizeBoxes = GameRandomizer().randomize(boxes: boxes.flatMap{ $0 }, numberOfTraps: numberOfTraps, graph: graph) {
                readyBoxes = randomizeBoxes
                break
            }
        }
        return readyBoxes
    }

    func createBoxes(for board: Board) -> [[Box]] {
        var boxes: [[Box]] = []
        for i in 0 ..< board.rows {
            var boxRow: [Box] = []
            for j in 0 ..< board.cols {
                let position = Location(row: i, col: j)
                let node = GKGraphNode()
                if i != 0 {
                    let top = boxes[i - 1][j].node
                    node.addConnections(to: [top], bidirectional: true)
                }
                if j != 0 {
                    let left = boxRow[j - 1].node
                    node.addConnections(to: [left], bidirectional: true)
                }
                let box = Box(position: position, node: node)
                boxRow.append(box)
            }
            boxes.append(boxRow)
        }
        return boxes
    }

    func randomize(boxes: [Box], numberOfTraps: Int, graph: GKGridGraph<GKGridGraphNode>) -> [[Box]]? {
        var mutableBoxes = boxes
        let mutableGraph = graph
        var finalBoxes: [Box] = []
        for _ in 0 ..< numberOfTraps {
            let box = mutableBoxes.dropRandom()
            box.type = .trap
            mutableGraph.remove([box.node])
            finalBoxes.append(box)
        }

        var isDone: Bool = false

        while !isDone {
            let start = mutableBoxes.dropRandom()
            let end = mutableBoxes.dropRandom()
            let path = mutableGraph.findPath(from: start.node, to: end.node)
            if path.isEmpty {
                isDone = true
                return nil
            } else if path.count < 6 || path.count > 12 {
                mutableBoxes.append(start)
                mutableBoxes.append(end)
                continue
            } else {
                start.type = .start
                end.type = .end
                finalBoxes.append(contentsOf: [start, end])
                isDone = true
            }
        }

        finalBoxes.append(contentsOf: mutableBoxes)
        return finalBoxes.sort()
    }
}
