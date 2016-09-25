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
    var style: String {get}
    init()
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

    public var style: String {
        return parse(styleTemplate)
    }

    fileprivate var styleTemplate: String {
        return "* { background-color: {{__kitchenBackgroundColor}};"
            + "    color: {{__kitchenColor}};"
            + "    tv-highlight-color:{{__kitchenHighlightBackgroundColor}};"
            + "}"
            + ".kitchen_highlight_bg { background-color:transparent;"
            + "    tv-highlight-color:{{__kitchenHighlightTextColor}}; }"
            + ".kitchen_no_highlight_bg { background-color:transparent;"
            + "    tv-highlight-color:{{__kitchenHighlightBackgroundColor}}; }"
    }

    fileprivate func parse(_ xml: String) -> String {
        var result = xml
        result = result.replacingOccurrences(
            of: "{{__kitchenBackgroundColor}}", with: backgroundColor
        )
        result = result.replacingOccurrences(
            of: "{{__kitchenHighlightBackgroundColor}}", with: highlightBackgroundColor
        )
        result = result.replacingOccurrences(
            of: "{{__kitchenHighlightTextColor}}", with: highlightTextColor
        )
        result = result.replacingOccurrences(
            of: "{{__kitchenColor}}", with: color
        )
        return result
    }

}

public struct EmptyTheme: ThemeType {
    public let style: String = ""
    public init() {}
}

public struct DefaultTheme: ThemeType {
    public init() {}
}

public struct BlackTheme: ThemeType {
    public let backgroundColor: String = "rgb(0, 0, 0)"
    public let color: String = "rgb(255, 255, 255)"
    public init() {}
}
