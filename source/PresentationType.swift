//
//  PresentationType.swift
//  TVMLKitchen
//
//  Created by Stephen Radford on 14/03/2016.
//  Copyright © 2016 toshi0383. All rights reserved.
//

public enum PresentationType: Int {
    case Default = 0
    case Modal = 1
    case Tab = 2
    case Search = 3
    case TabSearch = 4
    init?(string: String) {
        switch string.lowercaseString {
        case "modal":
            self = .Modal
        case "tab":
            self = .Tab
        case "search":
            self = .Search
        case "tabsearch":
            self = .TabSearch
        default:
            self = .Default
        }
    }
}
