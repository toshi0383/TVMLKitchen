//
//  LoadingRecipeTests.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/27/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import XCTest
@testable import TVMLKitchen

class LoadingRecipeTests: XCTestCase {
    func testLoadingRecipe() {
        let loading = LoadingRecipe()
        testTemplateRecipe(loading, expectedFileName: "ExpectedLoadingRecipe")
    }
}