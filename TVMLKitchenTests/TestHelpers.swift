//
//  TestHelpers.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/21/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import XCTest
@testable import TVMLKitchen

extension String {
    var trim: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}

func testTemplateRecipe<R: RecipeType>(_ recipe: R, expectedFileName name: String) {
    let target = recipe.xmlString.trim
        let bundle = Bundle(for: RecipeTests.self)
        let url = bundle.url(forResource: name, withExtension: "xml")!
        // swiftlint:disable:next force_try
    let expected = try! String(contentsOf: url).trim
    XCTAssert(target == expected, "\n===result===:\n\(target)\n\n===expected===:\n\(expected)\n\n=======")
}
