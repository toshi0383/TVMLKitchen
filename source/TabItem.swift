//
//  TabItem.swift
//  TVMLKitchen
//
//  Created by Stephen Radford on 15/03/2016.
//  Copyright © 2016 toshi0383. All rights reserved.
//

public protocol TabItem {
    
    /// The title that will be displayed on the tab bar.
    var title: String { get }
    
    /**
     This handler will be called whenever the focus changes to it.
     */
    func handler()
    
}
