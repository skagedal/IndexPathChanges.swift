//
//  FunctionalIndexPathChanges.swift
//  IndexChanges
//
//  Created by Simon Kågedal Reimer on 2017-02-20.
//  Copyright © 2017 Simon Kågedal Reimer. All rights reserved.
//

// Just an attempt at implementing IndexPathChanges in a functional way.  
// I don't think it improves readability.  Suggestions welcome!

import Foundation

private func indexes<T>(of elements: [T], containedIn excludedElements: [T], using equals: (T, T) -> Bool) -> [Int] {
    return elements.enumerated().flatMap { index, element -> Int? in
        excludedElements.contains(where: { equals($0, element) }) ? index : nil
    }
}

private func indexes<T>(of elements: [T], notContainedIn excludedElements: [T], using equals: (T, T) -> Bool) -> [Int] {
    return elements.enumerated().flatMap { index, element -> Int? in
        excludedElements.contains(where: { equals($0, element) }) ? nil : index
    }
}

extension IndexPathChanges {
    init<T>(fromx oldElements: [T], to newElements: [T], in section: Int, using equals: (T, T) -> Bool) {
        let makeIndexPath : (Int) -> IndexPath = { IndexPath(item: $0, section: section) }

        let deletes = indexes(of: oldElements, notContainedIn: newElements, using: equals).map(makeIndexPath)
        let inserts = indexes(of: newElements, notContainedIn: oldElements, using: equals).map(makeIndexPath)
        
        let moves: [IndexPathMove] = oldElements.enumerated().flatMap { oldIndex, oldElement in
            if let newIndex = newElements.index(where: { equals($0, oldElement) }), newIndex != oldIndex {
                return IndexPathMove(source: IndexPath(item: oldIndex, section: section),
                                     destination: IndexPath(item: newIndex, section: section))
            } else {
                return nil
            }
        }
        
        self.init(indexPathsToDelete: deletes, indexPathsToInsert: inserts, indexPathMoves: moves)
    }
}

