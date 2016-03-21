//
//  CatalogRecipe.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/19/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import Foundation

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

public struct CatalogRecipe<Theme:ThemeType>: TemplateRecipeType {

    let banner: String
    let sections: [Section]
    public let theme: Theme = Theme()
    public let presentationType: PresentationType

    public init(banner: String, sections: [Section],
        presentationType: PresentationType = .Default) {
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
