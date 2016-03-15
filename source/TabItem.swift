//
//  TabItem.swift
//  TVMLKitchen
//
//  Created by Stephen Radford on 15/03/2016.
//  Copyright © 2016 toshi0383. All rights reserved.
//

public protocol TabItem {
    
    var title: String { get }
    
    func handler()
    
}
