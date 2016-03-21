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

public protocol TemplateRecipeType: RecipeType {
    /// File name of this TemplateRecipe.
    /// Defaults to name of the class. (No need to implement)
    var templateFileName: String {get}
    /// Custom pair of replacement strings.
    /// e.g. ["color": "rgb(255, 255, 255)"]
    var replacementDictionary: [String: String] {get}
    /// Bundle of Template file.
    static var bundle: NSBundle {get}
}

extension RecipeType {

    public var theme: ThemeType {
        return EmptyTheme()
    }

    public var presentationType: PresentationType {
        return .Default
    }
}

extension TemplateRecipeType {
    public static var bundle: NSBundle {
        return Kitchen.bundle()
    }
}

extension TemplateRecipeType where Self.Theme: ThemeType {

    public var replacementDictionary: [String: String] {
        return [:]
    }

    public var base: String {
        let url = Kitchen.bundle().URLForResource("Base", withExtension: "xml")!
        // swiftlint:disable:next force_try
        let xml = try! String(contentsOfURL: url)
        return xml
    }

    public var template: String {
        let url = Self.bundle.URLForResource(templateFileName, withExtension: "xml")!
        // swiftlint:disable:next force_try
        let xml = try! String(contentsOfURL: url)
        return xml
    }

    public var templateFileName: String {
        return "\(_stdlib_getDemangledTypeName(self))"
            .componentsSeparatedByString(".")
            .last!
    }

    public var xmlString: String {
        var result = base
        // Replace template part.
        result = result
            .stringByReplacingOccurrencesOfString("{{template}}", withString: template)
            .stringByReplacingOccurrencesOfString("{{style}}", withString: theme.style)

        // Replace user-defined variables.
        for (k, v) in replacementDictionary {
            result = result.stringByReplacingOccurrencesOfString(
                "{{\(k)}}",    withString: v
            )
        }
        return result
    }
}
