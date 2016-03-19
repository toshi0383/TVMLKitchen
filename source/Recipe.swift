//
//  Recipe.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

// MARK: RecipeType
public protocol RecipeType {
    typealias Theme
    var theme: Theme {get}
    /// Presentation type is defined in the recipe to keep things consistent.
    var presentationType: PresentationType {get}
    /// Template part of TVML which is used to format full page xmlString.
    /// - SeeAlso: RecipeType.xmlString
    var template: String {get}
    /// XML string representation of whole TVML page.
    /// Uses RecipeType.template for template part by default.
    var xmlString: String {get}
}

extension RecipeType where Self.Theme: ThemeType {
    public var xmlString: String {
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
        xml += "<document>"
        xml += "<head>"
        xml += "<style>"
        xml += "* { background-color: \(theme.backgroundColor);"
        xml += "color: \(theme.color);"
        xml += "tv-highlight-color:\(theme.highlightBackgroundColor);"
        xml += "}"
        xml += ".kitchen_highlight_bg { background-color:transparent;"
        xml += "tv-highlight-color:\(theme.highlightTextColor); }"
        xml += ".kitchen_no_highlight_bg { background-color:transparent;"
        xml += "tv-highlight-color:\(theme.highlightBackgroundColor); }"
        xml += "</style>"
        xml += "</head>"
        xml += template
        xml += "</document>"
        return xml
    }
}
