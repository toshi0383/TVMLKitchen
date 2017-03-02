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
        // Here we want to verify that at least initial UI loads correctly.
        let xmlFileFromMainBundleButton = XCUIApplication().buttons["XML File from main bundle"]
        XCTAssert(xmlFileFromMainBundleButton.hasFocus)
        XCUIRemote.shared().press(.select)
        XCTAssert(xmlFileFromMainBundleButton.hasFocus)
        XCUIRemote.shared().press(.select)
        XCUIRemote.shared().press(.menu)
        XCTAssert(xmlFileFromMainBundleButton.hasFocus)
        XCUIRemote.shared().press(.down)
        XCUIRemote.shared().press(.down)
    }
}
