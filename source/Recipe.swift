//
//  Recipe.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

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

public struct Catalog {
    let banner: String
    let sections: [Section]
}

struct StyleConfig {
    let backgroundColor: String
    let color: String
    let highlightBackgroundColor: String
    let highlightTextColor: String
    init(backgroundColor: String,
        color: String, highlightBackgroundColor: String,
        highlightTextColor: String)
    {
        self.backgroundColor = backgroundColor
        self.color = color
        self.highlightBackgroundColor = highlightBackgroundColor
        self.highlightTextColor = highlightTextColor
    }
}

public enum Recipe {

    public enum Theme {

        case Default, Black

        var styleConfig: StyleConfig {
            switch self {
            case .Default:
                 return StyleConfig(
                    backgroundColor: "transparent",
                    color: "rgb(0, 0, 0)",
                    highlightBackgroundColor: "rgb(255, 255, 255)",
                    highlightTextColor: "rgb(0, 0, 0)")
            case .Black:
                 return StyleConfig(
                    backgroundColor: "rgb(0, 0, 0)",
                    color: "rgb(255, 255, 255)",
                    highlightBackgroundColor: "rgb(255, 255, 255)",
                    highlightTextColor: "rgb(0, 0, 0)")
            }
        }
    }


    public static var theme: Theme = .Black {
        didSet {
            styleConfig = theme.styleConfig
        }
    }

    private static var styleConfig: StyleConfig = theme.styleConfig

    case Catalog(banner:String, sections: [Section])
}

extension Recipe: CustomStringConvertible {
    public var description: String {
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
        xml += "<document>"
        xml += "<head>"
        xml += "<style>"
        xml += "* { background-color: \(Recipe.styleConfig.backgroundColor);"
        xml += "color: \(Recipe.styleConfig.color);"
        xml += "tv-highlight-color:\(Recipe.styleConfig.highlightBackgroundColor);"
        xml += "}"
        xml += ".kitchen_highlight_bg { background-color:transparent;"
        xml += "tv-highlight-color:\(Recipe.styleConfig.highlightTextColor); }"
        xml += ".kitchen_no_highlight_bg { background-color:transparent;"
        xml += "tv-highlight-color:\(Recipe.styleConfig.highlightBackgroundColor); }"
        xml += "</style>"
        xml += "</head>"
        switch self {
        case .Catalog(let banner, let sections):
            xml += "<catalogTemplate>"

            /// Top Banner
            xml += "<banner>"
            xml += "<title>\(banner)</title>"
            xml += "</banner>"
            xml += "<list>"
            xml += "<section>"

            /// Section and Contents
            xml += "<header>"
            xml += "<title></title>"
            xml += "</header>"
            xml += sections.map{"\($0)"}.joinWithSeparator("")
        }
        xml += "</section>"
        xml += "</list>"
        xml += "</catalogTemplate>"
        xml += "</document>"
        return xml
    }
}
