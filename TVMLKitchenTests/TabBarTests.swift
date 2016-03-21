//
//  TabBarTests.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/21/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import XCTest
@testable import TVMLKitchen

struct MyTab: TabItem {
    let title = "abcdef"
    func handler() { }
}

class TabBarTests: XCTestCase {

    func testTabBar() {
        let tabbar = KitchenTabBar(items: [
            MyTab()
        ])
        testTemplateRecipe(tabbar, expectedFileName: "ExpectedTabBar")
    }
}
