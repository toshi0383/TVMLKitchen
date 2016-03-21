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

}
