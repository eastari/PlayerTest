//
//  GettingNextElementInArrayTest.swift
//  PlayerTest
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import XCTest
@testable import PlayerTest

class GettingNextElementInArrayTest: XCTestCase {
    
    func testNextPrevElementInArray() {
        let array = [1,2,3,4]
        
        let next = array.next(item: 2)
        let prev = array.prev(item: 2)
        
        XCTAssertEqual(next, 3)
        XCTAssertEqual(prev, 1)
    }
    
    func testNextPrevElementFromLastInArray() {
        let array = [1,2,3,4]
        
        let next = array.next(item: 4)
        let prev = array.prev(item: 4)
        
        XCTAssertEqual(next, 1)
        XCTAssertEqual(prev, 3)
    }
    
    func testNextPrevElementFromFirstInArray() {
        let array = [1,2,3,4]
        
        let next = array.next(item: 1)
        let prev = array.prev(item: 1)
        
        XCTAssertEqual(next, 2)
        XCTAssertEqual(prev, 4)
    }

    
    
}
