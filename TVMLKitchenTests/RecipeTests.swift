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

struct EmptyTheme: ThemeType {
    let backgroundColor = ""
    let color = ""
    let highlightBackgroundColor = ""
    let highlightTextColor = ""
}

extension String {
    var trim: String {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "")
    }
}

class RecipeTests: XCTestCase {
    func testTemplateRecipeType() {
        let recipe = SampleTemplateRecipe()
        XCTAssert(recipe.templateFileName == "SampleTemplateRecipe")
        let target = recipe.xmlString.trim
        let expected = expectedXML.trim
        XCTAssert(target == expected, "\(target)\n\(expected)")
    }

    var expectedXML: String {
        let bundle = NSBundle(forClass: RecipeTests.self)
        let url = bundle.URLForResource("ExpectedSampleTemplate", withExtension: "xml")!
        // swiftlint:disable:next force_try
        return try! String(contentsOfURL: url)
    }
}
