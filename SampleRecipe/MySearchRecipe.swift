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
    override func filterSearchText(_ text: String, callback: ((String) -> Void)) {
        let titles = [
            "hello",
            "yellow"
        ]
        let imageUrl = "https://i.warosu.org/data/cgl/img/0075/02/1397765684315.png"
        let width = 350, height = 520
        var results = ""
        for title in titles {
            results += "<lockup>"
            results += "<img src=\"\(imageUrl)\" width=\"\(width)\" height=\"\(height)\" />"
            results += "<title>\(title)</title>"
            results += "</lockup>"
        }
        let url = SearchRecipe.bundle.urlForResource("SearchResult", withExtension: "xml")!
        let resultBase = try! String(contentsOf: url)
        let result = resultBase.replacingOccurrences(of: "{{results}}", with: results)

        callback(result)
    }
}
