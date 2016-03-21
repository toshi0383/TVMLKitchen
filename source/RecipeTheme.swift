//
//  RecipeTheme.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/19/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import Foundation

// MARK: ThemeType
public protocol ThemeType {
    var backgroundColor: String {get}
    var color: String {get}
    var highlightBackgroundColor: String {get}
    var highlightTextColor: String {get}
    init()
    func parse(xml: String) -> String
}

extension ThemeType {

    public var backgroundColor: String {
        return "transparent"
    }

    public var color: String {
        return "rgb(0, 0, 0)"
    }

    public var highlightBackgroundColor: String {
        return "rgb(255, 255, 255)"
    }

    public var highlightTextColor: String {
        return "rgb(0, 0, 0)"
    }

    public func parse(xml: String) -> String {
        var result = xml
        result = result.stringByReplacingOccurrencesOfString(
            "{{__kitchenBackgroundColor}}",    withString: backgroundColor
        )
        result = result.stringByReplacingOccurrencesOfString(
            "{{__kitchenHighlightBackgroundColor}}", withString: highlightBackgroundColor
        )
        result = result.stringByReplacingOccurrencesOfString(
            "{{__kitchenHighlightTextColor}}", withString: highlightTextColor
        )
        result = result.stringByReplacingOccurrencesOfString(
            "{{__kitchenColor}}",              withString: color
        )
        return result
    }

}

public struct DefaultTheme: ThemeType {
    public init() {}
}

public struct BlackTheme: ThemeType {
    public let backgroundColor: String = "rgb(0, 0, 0)"
    public let color: String = "rgb(255, 255, 255)"
    public init() {}
}
