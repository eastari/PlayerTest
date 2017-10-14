//
//  SongsJSONParserTests.swift
//  BillScaner
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import XCTest
@testable import PlayerTest

class SongsJSONParserTests: XCTestCase {
    
    var songs: Songs? = nil
    
    override func setUp() {
        super.setUp()
        let stubJSON = try! Data(
            contentsOf: Bundle.main.url(forResource: "json", withExtension: "json")!
        )
   
        do {
            songs = try Songs(json: stubJSON)
        } catch let error  {
            print(error)
        }
    }

    func testJSON() {
        
        // Check items count after parsing
        XCTAssertEqual(songs?.items.count, 5)
        
        // Check some items property
        XCTAssertEqual(songs?.items[0].audioLink, "https://a.clyp.it/iv1xl24p.mp3")
        XCTAssertEqual(songs?.items[0].name, "Song 1")

    }
    
    func testNextSong() {
        
        let next = songs?.items.next(item: (songs?.items[0])!)
        
        XCTAssertEqual(next, (songs?.items[1])!)
        XCTAssertEqual(next?.audioLink, "https://a.clyp.it/mbk0eyht.mp3")
        
        

    }
    
}
