//
//  Recipe.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

// MARK: Content and Section
public struct Section {

    struct Content {
        let title: String
        let thumbnailURL: String
        let actionID: String?
        let templateFileName: String?
        let width: Int
        let height: Int
    }

    public typealias ContentTuple = (title: String, thumbnailURL: String,
        actionID: String?, templateFileName: String?, width: Int, height: Int)

    let title: String

    let contents: [Content]

    public init(title: String, args: [ContentTuple]) {
        self.title = title
        self.contents = args.map(Content.init)
    }

    public init(title: String, args: ContentTuple...) {
        self.title = title
        self.contents = args.map(Content.init)
    }
}

extension Section: CustomStringConvertible {

    public var description: String {
        var xml = ""
        xml += "<listItemLockup>"
        xml += "<title class=\"kitchen_highlight_bg\" >\(title)</title>"
        xml += "<decorationLabel class=\"kitchen_highlight_bg\" >\(contents.count)</decorationLabel>"
        xml += "<relatedContent>"
        xml += "<grid>"
        xml += "<section>"
        xml += contents.map{ content in
            var xml = ""
            if let actionID = content.actionID {
                xml += "<lockup actionID=\"\(actionID)\" >"
            } else if let templateFileName = content.templateFileName {
                xml += "<lockup template=\"\(templateFileName)\" >"
            }
            xml += "<img src=\"\(content.thumbnailURL)\" "
            xml += "width=\"\(content.width)\" height=\"\(content.height)\" />"
            xml += "<title class=\"kitchen_no_highlight_bg\">\(content.title)</title>"
            xml += "</lockup>"
            return xml
        }.joinWithSeparator("")
        xml += "</section>"
        xml += "</grid>"
        xml += "</relatedContent>"
        xml += "</listItemLockup>"
        return xml
    }
}


// MARK: ThemeType
public protocol ThemeType {
    var backgroundColor: String {get}
    var color: String {get}
    var highlightBackgroundColor: String {get}
    var highlightTextColor: String {get}
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

}

public struct DefaultTheme: ThemeType {
    public init() {}
}

public struct BlackTheme: ThemeType {
    public let backgroundColor: String = "rgb(0, 0, 0)"
    public let color: String = "rgb(255, 255, 255)"
    public init() {}
}

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

public struct CatalogRecipe<Theme:ThemeType>: RecipeType {

    let banner: String
    let sections: [Section]
    public let theme: Theme = Theme()
    public let presentationType: PresentationType

    public init(banner: String, sections: [Section], presentationType: PresentationType = .Default) {
        self.banner = banner
        self.sections = sections
        self.presentationType = presentationType
    }

    public var template: String {
        var xml = ""
        xml += "<catalogTemplate>"

        /// Top Banner
        xml += "<banner>"
        xml += "<title>\(banner)</title>"
        xml += "</banner>"

        /// Section and Contents
        xml += "<list>"
        xml += "<section>"
        xml += "<header>"
        xml += "<title></title>"
        xml += "</header>"
        xml += sections.map{"\($0)"}.joinWithSeparator("")
        xml += "</section>"
        xml += "</list>"
        xml += "</catalogTemplate>"
        return xml
    }
}
