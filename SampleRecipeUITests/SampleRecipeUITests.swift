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

    func testUI() {
        let app = XCUIApplication()
        XCUIRemote.sharedRemote().pressButton(.Right)
        XCUIRemote.sharedRemote().pressButton(.Right)
        XCUIRemote.sharedRemote().pressButton(.Select)
        let catalog = app.buttons["Catalog.xml"]
        XCTAssert(catalog.hasFocus)
        XCUIRemote.sharedRemote().pressButton(.Select)
        sleep(1)
        XCUIRemote.sharedRemote().pressButton(.Menu)
        sleep(1)
        XCUIRemote.sharedRemote().pressButton(.Right)
        let xmlString = app.buttons["XMLString"]
        XCTAssert(xmlString.hasFocus)
        XCUIRemote.sharedRemote().pressButton(.Select)
        sleep(1)
        XCUIRemote.sharedRemote().pressButton(.Menu)
        sleep(1)
        XCUIRemote.sharedRemote().pressButton(.Down)
        XCTAssert(app.buttons["Custom Theme"].hasFocus)
        XCUIRemote.sharedRemote().pressButton(.Select)
        sleep(1)
        XCUIRemote.sharedRemote().pressButton(.Menu)
        sleep(1)
        XCUIRemote.sharedRemote().pressButton(.Down)
        XCUIRemote.sharedRemote().pressButton(.Down)
        XCTAssert(app.buttons["URL"].hasFocus)
        XCUIRemote.sharedRemote().pressButton(.Select)
        sleep(1)
        XCUIRemote.sharedRemote().pressButton(.Menu)

    }
}
