//
//  PresentationType.swift
//  TVMLKitchen
//
//  Created by Stephen Radford on 14/03/2016.
//  Copyright © 2016 toshi0383. All rights reserved.
//

public enum PresentationType: Int {
    case `default` = 0
    case modal = 1
    case tab = 2
    case search = 3
    /// Mix of `.Tab` and `.Search`.
    /// Expected to be used when presenting SearchRecipe as a TabItem.
    case tabSearch = 4
    case defaultWithLoadingIndicator = 6

    init(string: String) {
        switch string.lowercased() {
        case "modal":
            self = .modal
        case "tab":
            self = .tab
        case "search":
            self = .search
        case "tabsearch":
            self = .tabSearch
        case "defaultwithloadingindicator":
            self = .defaultWithLoadingIndicator
        default:
            self = .default
        }
    }
}
