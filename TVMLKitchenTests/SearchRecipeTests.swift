//
//  SearchRecipeTests.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/21/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import XCTest
@testable import TVMLKitchen

class SearchRecipeTests: XCTestCase {

    func testSearchRecipe() {
        let search = SearchRecipe()
        testTemplateRecipe(search, expectedFileName: "ExpectedSearchRecipe")
    }
}
