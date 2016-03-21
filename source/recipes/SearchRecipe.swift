//
//  SearchRecipe.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/21/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import Foundation

public class SearchRecipe: SearchRecipeType {

    public typealias Theme = DefaultTheme

    public let theme: Theme = DefaultTheme()

    /// Presentation type is defined in the recipe to keep things consistent.
    public var presentationType = PresentationType.Search

    public init(type: PresentationType = .Search) {
        self.presentationType = type
    }

    public var templateFileName: String {
        return "SearchRecipe"
    }

    public func filterSearchText(text: String, callback: (String -> Void)) {
        fatalError("Must be overridden.")
    }

    internal static var noData: String {
        return"<list> <section> <header> <title>No Results</title> </header> </section> </list>"
    }
}