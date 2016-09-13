//
//  SampleResource.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
struct Sample {
    static let title = "TVMLKitchen"
    static let description = "Swift is a high-performance system programming language. It has a clean and modern syntax, offers seamless access to existing C and Objective-C code and frameworks, and is memory safe by default."
    static let tvmlUrl = "https://raw.githubusercontent.com/toshi0383/TVMLKitchen/swift2.2/SampleRecipe/Catalog.xml"
    static var tvmlString: String {
        return XMLString.Catalog.description
    }
}
// swiftlint:enable line_length

enum XMLString: String {
    case Catalog
}

extension XMLString: CustomStringConvertible {
    var description: String {
        switch self {
        case .Catalog:
            let path = NSBundle.mainBundle().pathForResource("Oneup", ofType: "xml")!
            // swiftlint:disable force_try
            return try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
            // swiftlint:enable force_try
        }
    }
}
