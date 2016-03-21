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
    var templateFileName: String {get}
    var replacementDictionary: [String: String] {get}
    var bundle: NSBundle {get}
    func parse(xml: String) -> String
}

extension RecipeType {
    public var presentationType: PresentationType {
        return .Default
    }
}

extension RecipeType where Self.Theme: ThemeType {
    public var xmlString: String {
        let url = Kitchen.bundle().URLForResource("Base", withExtension: "xml")!
        // swiftlint:disable:next force_try
        var xml = try! String(contentsOfURL: url)
        xml = theme.parse(xml)
        return xml
    }
}

extension TemplateRecipeType {
    public var bundle: NSBundle {
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
        let url = bundle.URLForResource(templateFileName, withExtension: "xml")!
        // swiftlint:disable:next force_try
        let xml = try! String(contentsOfURL: url)
        return xml
    }

    public var templateFileName: String {
        return "\(_stdlib_getDemangledTypeName(self))"
            .componentsSeparatedByString(".")
            .last!
    }

    public func parse(xml: String) -> String {
        var result = xml
        // Replace template part.
        result = result.stringByReplacingOccurrencesOfString(
            "{{template}}",    withString: template
        )

        // Replace user-defined variables.
        for (k, v) in replacementDictionary {
            result = result.stringByReplacingOccurrencesOfString(
                "{{\(k)}}",    withString: v
            )
        }
        result = theme.parse(result)
        return result
    }

    public var xmlString: String {
        let xml = parse(base)
        return xml
    }
}
