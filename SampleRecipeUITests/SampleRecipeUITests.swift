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

    func gotoSampleScreen() {
        XCUIRemote.shared().press(.right)
        XCUIRemote.shared().press(.right)
        XCUIRemote.shared().press(.select)
    }

    func testUI() {
        gotoSampleScreen()
        let app = XCUIApplication()
        let catalog = app.buttons["Catalog.xml"]
        XCTAssert(catalog.hasFocus)
        XCUIRemote.shared().press(.select)
        sleep(1)
        XCUIRemote.shared().press(.menu)
        sleep(1)
        XCUIRemote.shared().press(.right)
        let xmlString = app.buttons["XMLString"]
        XCTAssert(xmlString.hasFocus)
        XCUIRemote.shared().press(.select)
        sleep(1)
        XCUIRemote.shared().press(.menu)
        sleep(1)
        XCUIRemote.shared().press(.down)
        XCTAssert(app.buttons["Custom Theme"].hasFocus)
        XCUIRemote.shared().press(.select)
        sleep(1)
        XCUIRemote.shared().press(.menu)
        sleep(1)
        XCUIRemote.shared().press(.down)
        XCTAssert(app.buttons["URL"].hasFocus)
    }

    func testUI2() {
        let app = XCUIApplication()
        gotoSampleScreen()
        XCUIRemote.shared().press(.down)
        XCUIRemote.shared().press(.down)
        XCUIRemote.shared().press(.down)
        XCUIRemote.shared().press(.down)
        XCUIRemote.shared().press(.down)
        XCTAssert(app.buttons["AlertRecipe"].hasFocus)
        XCUIRemote.shared().press(.select)
        sleep(1)
        XCUIRemote.shared().press(.menu)
        sleep(1)
        XCUIRemote.shared().press(.down)
        XCTAssert(app.buttons["DescriptiveAlertRecipe"].hasFocus)
        XCUIRemote.shared().press(.select)
        sleep(1)
        XCUIRemote.shared().press(.menu)
        sleep(1)
        XCTAssert(app.buttons["DescriptiveAlertRecipe"].hasFocus)

    }
}
