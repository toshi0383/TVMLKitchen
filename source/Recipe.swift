//
//  Recipe.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

import Foundation


public struct Section {

    struct Content {
        let title: String
        let thumbnailURL: String
    }

    let title: String

    let contents: [Content]

    public init(title: String, args: [(title: String, thumbnailURL: String)]){
        self.title = title
        self.contents = args.map(Content.init)
    }

    public init(title: String, args: (title: String, thumbnailURL: String)...) {
        self.title = title
        self.contents = args.map(Content.init)
    }
}

extension Section: CustomStringConvertible {

    public var description: String {
        var xml = ""
        xml += "<title>\(title)</title>"
        xml += "<decorationLabel>\(contents.count)</decorationLabel>"
        xml += "<relatedContent>"
        xml += "<grid>"
        xml += "<section>"
        xml += contents.map{ content in
            var xml = ""
            xml += "<lockup>"
            xml += "<img src=\"\(content.thumbnailURL)\" "
            xml += "width=\"250\" height=\"376\" />"
            xml += "<title>\(content.title)</title>"
            xml += "</lockup>"
            return xml
        }.joinWithSeparator("")
        xml += "</section>"
        xml += "</grid>"
        xml += "</relatedContent>"
        return xml
    }
}

public struct Catalog {
    let banner: String
    let sections: [Section]
}

public enum Recipe {
    case Catalog(banner:String, sectionsList: [[Section]])
}

extension Recipe: CustomStringConvertible {
    public var description: String {
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
        xml += "<document>"
        xml += "<head>"
//        xml += "<style> title { color: rgb(255, 255, 255); } </style>"
        xml += "</head>"
        switch self {
        case .Catalog(let banner, let sectionsList):
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
            xml += sectionsList.map{ sections in
                var xml = ""
                xml += "<listItemLockup>"
                xml += sections.map{"\($0)"}.joinWithSeparator("")
                xml += "</listItemLockup>"
                return xml
            }.joinWithSeparator("")
        }
        xml += "</section>"
        xml += "</list>"
        xml += "</catalogTemplate>"
        xml += "</document>"
        return xml
    }
}
