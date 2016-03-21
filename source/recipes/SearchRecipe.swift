//
//  SearchRecipe.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/21/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import Foundation

public struct SearchRecipe: TemplateRecipeType {

    public typealias Theme = DefaultTheme

    public let theme: Theme = DefaultTheme()

    /// Presentation type is defined in the recipe to keep things consistent.
    public var presentationType = PresentationType.Search

    public init() { }

    /// SearchText filtering
    internal static func filterSearchText(text: String, callback: (String -> Void)) {
        let titles = [
            "hello",
            "yellow"
        ]
        var results = ""
        for title in titles {
            results += "<lockup>"
            results += "<img src=\"http://suptg.thisisnotatrueending.com/archive/2472537/images/1220209533502.jpg\" width=\"350\" height=\"520\" />"
            results += "<title>\(title)</title>"
            results += "</lockup>"
        }
        let url = bundle.URLForResource("SearchResult", withExtension: "xml")!
        // swiftlint:disable:next force_cast
        let resultBase = try! String(contentsOfURL: url)
        let result = resultBase.stringByReplacingOccurrencesOfString("{{results}}", withString: results)

        callback(result)
    }

    internal static var noData: String {
        return"<list> <section> <header> <title>No Results</title> </header> </section> </list>"
    }
}