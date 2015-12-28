//
//  SampleResource.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

import Foundation

enum RawXMLString: String {
    case Catalog
}

extension RawXMLString: CustomStringConvertible {
    var description: String {
        switch self {
        case .Catalog:
            let path = NSBundle.mainBundle().pathForResource("RawXMLString", ofType: "txt")!
            // swiftlint:disable force_try
            return try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
            // swiftlint:enable force_try
        }
    }
}
