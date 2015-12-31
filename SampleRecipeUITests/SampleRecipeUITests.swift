//
//  SampleRecipeUITests.swift
//  SampleRecipeUITests
//
//  Created by toshi0383 on 12/31/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

import XCTest

class SampleRecipeUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        XCUIApplication().launch()
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIRemote.sharedRemote().pressButton(.Up)
        XCUIRemote.sharedRemote().pressButton(.Down)
        XCUIRemote.sharedRemote().pressButton(.Right)
        XCUIRemote.sharedRemote().pressButton(.Right)
        XCUIRemote.sharedRemote().pressButton(.Right)
        XCUIRemote.sharedRemote().pressButton(.Down)
        XCUIRemote.sharedRemote().pressButton(.Up)
        XCUIRemote.sharedRemote().pressButton(.Left)
        XCUIRemote.sharedRemote().pressButton(.Left)
        XCUIRemote.sharedRemote().pressButton(.Up)
        XCUIRemote.sharedRemote().pressButton(.Down)
        XCUIRemote.sharedRemote().pressButton(.Down)

        let app = XCUIApplication()
        XCUIRemote.sharedRemote().pressButton(.Select)
        XCTAssert(app.buttons["Template.xml.js"].hasFocus)
        XCUIRemote.sharedRemote().pressButton(.Select)
        XCUIRemote.sharedRemote().pressButton(.Menu)
        sleep(1)
        XCTAssert(app.buttons["Template.xml.js"].hasFocus)
        XCUIRemote.sharedRemote().pressButton(.Right)
        XCUIRemote.sharedRemote().pressButton(.Right)
        XCTAssert(app.buttons["XMLString"].hasFocus)
        XCUIRemote.sharedRemote().pressButton(.Select)
        sleep(1)
        XCUIRemote.sharedRemote().pressButton(.Menu)
        sleep(1)
        XCTAssert(app.buttons["XMLString"].hasFocus)
    }
}
