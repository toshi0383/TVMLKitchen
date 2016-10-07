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
open class SearchRecipe: SearchRecipeType {

    open let theme = EmptyTheme()

    /// Presentation type is defined in the recipe to keep things consistent.
    open var presentationType = PresentationType.search

    public init(type: PresentationType = .search) {
        self.presentationType = type
    }

    open var templateFileName: String {
        // Always use SearchRecipe.xml unless this property is overridden.
        return "SearchRecipe"
    }

    open func filterSearchText(_ text: String, callback: ((String) -> Void)) {
        fatalError("Must be overridden.")
    }

    open var noData: String {
        return "<list> <section> <header> <title>No Results</title> </header> </section> </list>"
    }
}
