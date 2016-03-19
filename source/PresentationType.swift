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
    init?(string: String) {
        switch string {
        case "Modal":
            self = .Modal
        case "Tab":
            self = .Tab
        default:
            self = .Default
        }
    }
}
