//
//  KitchenTabBar.swift
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

public struct KitchenTabBar: RecipeType {

    /// The shared instance of the tab bar.
    /// Only one tab bar should be created per app.
    public static var sharedBar = KitchenTabBar()

    /// The items that are displayed in the tab bar.
    /// The `displayTabBar` method will automatically be called.
    public var items: [TabItem]! {
        didSet {
            displayTabBar()
        }
    }

    init(items: [TabItem]? = nil) {
        self.items = items
    }

    /// Constructed string from the `items` array.
    public var template: String {
        var string = ""
        for (index, item) in items.enumerate() {
            string += "<menuItem menuIndex=\"\(index)\">"
            string += "<title>\(item.title)</title>"
            string += "</menuItem>"
        }
        return string
    }

    /// The XML string of the `menuBarTemplate`.
    public var xmlString: String {
        get {
            var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
            xml += "<document>"
            xml += "<menuBarTemplate>"
            xml += "<menuBar>"
            xml += template
            xml += "</menuBar>"
            xml += "</menuBarTemplate>"
            xml += "</document>"
            return xml
        }
    }

    /**
     Display the tab bar using the generated `xmlString`.
     */
    func displayTabBar() {
        openTVMLTemplateFromXMLString(xmlString)
    }

    /**
     Called whenever the tab view changes.
     The handler defined by the relevant `TabItem` will automatically be called.

     - parameter index: The new selected index
     */
    func tabChanged(index: String) {
        if let i = Int(index) {
            items[i].handler()
        }
    }

}
