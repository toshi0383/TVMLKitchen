//
//  MySearchRecipe.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/21/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import Foundation
import TVMLKitchen

class MySearchRecipe: SearchRecipe {
    override func filterSearchText(text: String, callback: (String -> Void)) {
        let titles = [
            "hello",
            "yellow"
        ]
        let url = "https://i.warosu.org/data/cgl/img/0075/02/1397765684315.png"
        let width = 350, height = 520
        var results = ""
        for title in titles {
            results += "<lockup>"
            results += "<img src=\"\(url)\" width=\"\(width)\" height=\"\(height)\" />"
            results += "<title>\(title)</title>"
            results += "</lockup>"
        }
        let url = SearchRecipe.bundle.URLForResource("SearchResult", withExtension: "xml")!
        let resultBase = try! String(contentsOfURL: url)
        let result = resultBase.stringByReplacingOccurrencesOfString("{{results}}", withString: results)

        callback(result)
    }
}
