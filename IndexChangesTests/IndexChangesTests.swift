//
//  IndexChangesTests.swift
//  IndexChangesTests
//
//  Created by Simon Kågedal Reimer on 2017-02-18.
//  Copyright © 2017 Simon Kågedal Reimer. All rights reserved.
//

import Foundation
import XCTest
@testable import IndexChanges

let section = 5

func path(_ item: Int) -> IndexPath {
    return IndexPath(item: item, section: section)
}

func move(_ fromItem: Int, _ toItem: Int) -> IndexPathMove {
    return IndexPathMove(source: path(fromItem), destination: path(toItem))
}

extension IndexPathMove: Equatable {
    public static func ==(_ lhs: IndexPathMove, _ rhs: IndexPathMove) -> Bool {
        return lhs.source == rhs.source && lhs.destination == rhs.destination
    }
}

class IndexChangesTests: XCTestCase {
    
    func testSingleInsertFromEmptyArray() {
        let changes = IndexPathChanges(from: [], to: ["A"], in: section)
        XCTAssertEqual(changes.indexPathsToInsert, [path(0)])
        XCTAssertEqual(changes.indexPathsToDelete, [])
        XCTAssertEqual(changes.indexPathMoves, [])
    }

    func testSingleInsertBeforeObject() {
        let changes = IndexPathChanges(from: ["A"], to: ["B", "A"], in: section)
        XCTAssertEqual(changes.indexPathsToInsert, [path(0)])
        XCTAssertEqual(changes.indexPathsToDelete, [])
        XCTAssertEqual(changes.indexPathMoves, [move(0, 1)])
    }
    
    func testSingleInsertAfterObject() {
        let changes = IndexPathChanges(from: ["A"], to: ["A", "B"], in: section)
        XCTAssertEqual(changes.indexPathsToInsert, [path(1)])
        XCTAssertEqual(changes.indexPathsToDelete, [])
        XCTAssertEqual(changes.indexPathMoves, [])
    }
    
    func testMultipleInserts() {
        let changes = IndexPathChanges(from: ["A"], to: ["B", "A", "C"], in: section)
        XCTAssertEqual(changes.indexPathsToInsert, [path(0), path(2)])
        XCTAssertEqual(changes.indexPathsToDelete, [])
        XCTAssertEqual(changes.indexPathMoves, [move(0, 1)])
    }

    func testSingleDelete() {
        let changes = IndexPathChanges(from: ["A", "B"], to: ["A"], in: section)
        XCTAssertEqual(changes.indexPathsToInsert, [])
        XCTAssertEqual(changes.indexPathsToDelete, [path(1)])
        XCTAssertEqual(changes.indexPathMoves, [])
    }

    func testMultipleDeletes() {
        let changes = IndexPathChanges(from: ["A", "B", "C"], to: ["B"], in: section)
        XCTAssertEqual(changes.indexPathsToInsert, [])
        XCTAssertEqual(changes.indexPathsToDelete, [path(0), path(2)])
        XCTAssertEqual(changes.indexPathMoves, [move(1, 0)])
    }
    
    func testMove() {
        let changes = IndexPathChanges(from: ["A", "B"], to: ["B", "A"], in: section)
        XCTAssertEqual(changes.indexPathsToInsert, [])
        XCTAssertEqual(changes.indexPathsToDelete, [])
        XCTAssertEqual(changes.indexPathMoves, [move(0, 1), move(1, 0)])
    }
    
    func testAllAtOnce() {
        let changes = IndexPathChanges(from: ["A", "D"], to: ["B", "A", "C"], in: section)
        XCTAssertEqual(changes.indexPathsToInsert, [path(0), path(2)])
        XCTAssertEqual(changes.indexPathsToDelete, [path(1)])
        XCTAssertEqual(changes.indexPathMoves, [move(0, 1)])
    }
    
    func testCustomEquals() {
        let changes = IndexPathChanges(from: ["a", "b"], to: ["A", "B"], in: section, using: {
            $0.caseInsensitiveCompare($1) == ComparisonResult.orderedSame
        })
        XCTAssertEqual(changes.indexPathsToInsert, [])
        XCTAssertEqual(changes.indexPathsToDelete, [])
        XCTAssertEqual(changes.indexPathMoves, [])

        let changesNormal = IndexPathChanges(from: ["a", "b"], to: ["A", "B"], in: section)
        XCTAssertEqual(changesNormal.indexPathsToInsert, [path(0), path(1)])
        XCTAssertEqual(changesNormal.indexPathsToDelete, [path(0), path(1)])
        XCTAssertEqual(changesNormal.indexPathMoves, [])
    }
}
