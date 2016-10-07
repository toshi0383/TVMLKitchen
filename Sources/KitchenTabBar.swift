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

public struct KitchenTabBar: TemplateRecipeType {

    public let theme = EmptyTheme()

    /// The items that are displayed in the tab bar.
    /// The `displayTabBar` method will automatically be called.
    public var items: [TabItem]! {
        didSet {
            displayTabBar()
        }
    }

    /// for UnitTesting use.
    /// - parameter items:
    public init(items: [TabItem]? = nil) {
        self.items = items
    }

    /// Constructed string from the `items` array.
    public var template: String {
        let url = KitchenTabBar.bundle.url(forResource: templateFileName, withExtension: "xml")!
        // swiftlint:disable:next force_try
        let xml = try! String(contentsOf: url)
        var string = ""
        for (index, item) in items.enumerated() {
            string += "<menuItem menuIndex=\"\(index)\">\n"
            string += "<title>\(item.title)</title>\n"
            string += "</menuItem>\n"
        }
        return xml.replacingOccurrences(of: "{{menuItems}}", with: string)
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
    func tabChanged(_ index: Int) {
        items[index].handler()
    }

}
