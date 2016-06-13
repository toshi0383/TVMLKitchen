//
//  SampleResource.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

import Foundation

enum XMLString: String {
    case Catalog
}

extension XMLString: CustomStringConvertible {
    var description: String {
        switch self {
        case .Catalog:
            let path = Bundle.main().pathForResource("Oneup", ofType: "xml")!
            // swiftlint:disable force_try
            return try! NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
            // swiftlint:enable force_try
        }
    }
}
