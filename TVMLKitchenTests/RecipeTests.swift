//
//  RecipeTests.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/21/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import XCTest
@testable import TVMLKitchen

struct SampleTemplateRecipe: TemplateRecipeType {
    let theme = EmptyTheme()
    /// Presentation type is defined in the recipe to keep things consistent.
    var presentationType = PresentationType.Search

    var bundle: NSBundle {
        return NSBundle(forClass: RecipeTests.self)
    }
}

class RecipeTests: XCTestCase {
    func testTemplateRecipeType() {
        let recipe = SampleTemplateRecipe()
        testTemplateRecipe(recipe, expectedFileName: "ExpectedSampleTemplateRecipe")
    }
}
