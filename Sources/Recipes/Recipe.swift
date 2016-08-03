//
//  Recipe.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

// MARK: RecipeType
public protocol RecipeType {

    /// Theme
    associatedtype Theme
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

    /// Custom pairs of replacement strings.
    ///
    /// e.g.
    ///
    ///    ["title": "Sherlock Holmes: A Game of Shadows (2011)"]
    ///     will modifies this `<title>{{title}}</title>`
    ///     to this `<title>Sherlock Holmes: A Game of Shadows (2011)</title>`
    var replacementDictionary: [String: String] {get}

    /// The Bundle in which the corresponding Template file.
    /// Defaults to the bundle of this class/struct/enum.
    static var bundle: Bundle {get}
}

public protocol SearchRecipeType: TemplateRecipeType {

    /// Filter text and pass the result to callback.
    /// - parameter text: keyword
    /// - parameter callback: pass the result template xmlString.
    /// - SeeAlso: SampleRecipe.MySearchRecipe.swift, SearchResult.xml
    func filterSearchText(_ text: String, callback: ((String) -> Void))
}

// MARK: - Default Implementations
extension RecipeType {

    public var theme: ThemeType {
        return EmptyTheme()
    }

    public var presentationType: PresentationType {
        return .default
    }
}

extension TemplateRecipeType {

    public static var bundle: Bundle {
        return Kitchen.bundle()
    }

    public var replacementDictionary: [String: String] {
        return [:]
    }

    public var base: String {
        let url = Kitchen.bundle().url(forResource: "Base", withExtension: "xml")!
        // swiftlint:disable:next force_try
        let xml = try! String(contentsOf: url)
        return xml
    }

    public var template: String {
        let url = Self.bundle.url(forResource: templateFileName, withExtension: "xml")!
        // swiftlint:disable:next force_try
        let xml = try! String(contentsOf: url)
        return xml
    }

    public var templateFileName: String {
        return String(self.dynamicType)
            .components(separatedBy: ".")
            .last!
    }
}

extension TemplateRecipeType where Self.Theme: ThemeType {

    public var xmlString: String {

        // Start with Base
        var result = base

        // Replace template part.
        result = result
            .replacingOccurrences(of: "{{template}}", with: template)
            .replacingOccurrences(of: "{{style}}", with: theme.style)

        // Replace user-defined variables.
        for (k, v) in replacementDictionary {
            result = result.replacingOccurrences(
                of: "{{\(k)}}", with: v
            )
        }
        return result
    }
}
