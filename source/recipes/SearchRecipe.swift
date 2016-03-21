//
//  SearchRecipe.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/21/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import Foundation

/// SearchRecipe
///
/// Usage:
/// 1. Subclass and override filterSearchText method.
/// 2. Instantiate with preferred PresentationType.
public class SearchRecipe: SearchRecipeType {

    public let theme = EmptyTheme()

    /// Presentation type is defined in the recipe to keep things consistent.
    public var presentationType = PresentationType.Search

    public init(type: PresentationType = .Search) {
        self.presentationType = type
    }

    public var templateFileName: String {
        // Always use SearchRecipe.xml unless this property is overridden.
        return "SearchRecipe"
    }

    public func filterSearchText(text: String, callback: (String -> Void)) {
        fatalError("Must be overridden.")
    }

    internal var noData: String {
        return"<list> <section> <header> <title>No Results</title> </header> </section> </list>"
    }
}
