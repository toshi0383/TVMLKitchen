//
//  KitchenTabBar.swift
//  TVMLKitchen
//
//  Created by Stephen Radford on 15/03/2016.
//  Copyright © 2016 toshi0383. All rights reserved.
//

public struct KitchenTabBar {

    public static var sharedBar = KitchenTabBar()
    
    public var items: [TabItem]! {
        didSet {
            displayTabBar()
        }
    }
    
    var itemString: String {
        var string = ""
        for (index, item) in items.enumerate() {
            string += "<menuItem menuIndex=\"\(index)\">"
            string += "<title>\(item.title)</title>"
            string += "</menuItem>"
        }
        return string
    }
    
    var xmlString: String {
        get {
            var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
            xml += "<document>"
            xml += "<menuBarTemplate>"
            xml += "<menuBar>"
            xml += itemString
            xml += "</menuBar>"
            xml += "</menuBarTemplate>"
            xml += "</document>"
            return xml
        }
    }
    
    func displayTabBar() {
        openTVMLTemplateFromXMLString(xmlString)
    }
    
    func tabChanged(index: String) {
        if let i = Int(index) {
            items[i].handler()
        }
    }
    
}