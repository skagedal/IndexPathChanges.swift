//
//  Written by Simon Kågedal Reimer 2017.
//

import UIKit

struct IndexPathMove {
    let source: IndexPath
    let destination: IndexPath
}

struct IndexPathChanges {
    let indexPathsToDelete: [IndexPath]
    let indexPathsToInsert: [IndexPath]
    let indexPathMoves: [IndexPathMove]
}

extension IndexPathChanges {
    init<T>(from oldElements: [T], to newElements: [T], in section: Int, using equals: (T, T) -> Bool) {
        var deletes: [IndexPath] = []
        var inserts: [IndexPath] = []
        var moves: [IndexPathMove] = []
        
        // Deletes and moves
        for (oldIndex, element) in oldElements.enumerated() {
            if let newIndex = newElements.index(where: { equals($0, element) }) {
                if newIndex != oldIndex {
                    moves.append(IndexPathMove(source: IndexPath(item: oldIndex, section: section),
                                               destination: IndexPath(item: newIndex, section: section)))
                }
            } else {
                deletes.append(IndexPath(item: oldIndex, section: section))
            }
        }
        
        // Inserts
        for (newIndex, element) in newElements.enumerated() {
            if !oldElements.contains(where: { equals($0, element) }) {
                inserts.append(IndexPath(item: newIndex, section: section))
            }
        }
  
        self.init(indexPathsToDelete: deletes, indexPathsToInsert: inserts, indexPathMoves: moves)
    }
    
    init<T>(from oldElements: [T], to newElements: [T], in section: Int) where T: Equatable {
        self.init(from: oldElements, to: newElements, in: section, using: ==)
    }
}

extension UITableView {
    func updateRows(for changes: IndexPathChanges, with animation: UITableViewRowAnimation) {
        deleteRows(at: changes.indexPathsToDelete, with: animation)
        insertRows(at: changes.indexPathsToInsert, with: animation)
        for move in changes.indexPathMoves {
            moveRow(at: move.source, to: move.destination)
        }
    }
    
    func performBatchUpdates(for changes: IndexPathChanges, with animation: UITableViewRowAnimation) {
        beginUpdates()
        updateRows(for: changes, with: animation)
        endUpdates()
    }
}

extension UICollectionView {
    func updateItems(for changes: IndexPathChanges) {
        deleteItems(at: changes.indexPathsToDelete)
        insertItems(at: changes.indexPathsToInsert)
        for move in changes.indexPathMoves {
            moveItem(at: move.source, to: move.destination)
        }
    }
    
    func performBatchUpdates(for changes: IndexPathChanges, completion: ((Bool) -> Void)?) {
        performBatchUpdates({ self.updateItems(for: changes) }, completion: completion)
    }
}
