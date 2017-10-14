//
//  PlayerTestUITests.swift
//  PlayerTestUITests
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import XCTest

class PlayerTestUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {super.tearDown()}
    
    func testFullPlayerViewMatchWithData() {
        
        let app = XCUIApplication()
        app.tables.cells.containing(.staticText, identifier:"Song 1").staticTexts["Aleks"].tap()
        app.otherElements.containing(.navigationBar, identifier:"Songs").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).staticTexts["Aleks"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).images["pause"].tap()
        
        XCTAssert(app.staticTexts["Aleks"].exists)
        XCTAssert(app.staticTexts["Song 1"].exists)
    }
    
}
