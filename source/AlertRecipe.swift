//
//  AlertRecipe.swift
//  TVMLKitchen
//
//  Created by Stephen Radford on 14/03/2016.
//  Copyright © 2016 toshi0383. All rights reserved.
//

public struct AlertButton {
    
    let title: String
    let actionId: String?
    
    public init(title: String, actionId: String? = nil) {
        self.title = title
        self.actionId = actionId
    }
    
}

public struct AlertRecipe: RecipeType {
    
    public let theme = DefaultTheme()
    public let title: String
    public let description: String
    public let buttons: [AlertButton]
    
    public init(title: String, description: String, buttons: [AlertButton] = []) {
        self.title = title
        self.description = description
        self.buttons = buttons
    }
    
    public var xmlString: String {
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
        xml += "<document>"
        xml += template
        xml += "</document>"
        return xml
    }
    
    public var template: String {
        var xml = ""
        if let url = NSBundle.mainBundle().URLForResource("AlertRecipe", withExtension: "xml") {
            xml = try! String(contentsOfURL: url)
            xml = xml.stringByReplacingOccurrencesOfString("{{TITLE}}", withString: title)
            xml = xml.stringByReplacingOccurrencesOfString("{{DESCRIPTION}}", withString: description)
            xml = xml.stringByReplacingOccurrencesOfString("{{BUTTONS}}", withString: "")
        }
        return xml
    }
}