//
//  Loading.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/26/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import Foundation

class LoadingRecipe: TemplateRecipeType {

    typealias Theme = EmptyTheme
    var theme: Theme = EmptyTheme()

    let message: String

    init(message: String = "Loading") {
        self.message = message
    }

    var replacementDictionary: [String : String] {
        return ["LOADING": message]
    }
}
