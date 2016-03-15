//
//  AlertRecipe.swift
//  TVMLKitchen
//
//  Created by Stephen Radford on 14/03/2016.
//  Copyright © 2016 toshi0383. All rights reserved.
//

public struct AlertButton {
    
    let title: String
    let actionID: String?
    
    public init(title: String, actionID: String? = nil) {
        self.title = title
        self.actionID = actionID
    }
    
}

public class AlertRecipe: RecipeType {
    
    public let theme = DefaultTheme()
    public let presentationType = PresentationType.Modal
    public let title: String
    public let description: String
    public let buttons: [AlertButton]
    var templateFile: String {
        return "AlertRecipe"
    }
    
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
    
    private var buttonString: String {
        let mapped: [String] = buttons.map {
            var string = ($0.actionID != nil) ? "<button actionID=\"\($0.actionID!)\">" : "<button>"
            string += "<text>\($0.title)</text>"
            string += "</button>"
            return string
        }
        return mapped.joinWithSeparator("")
    }
    
    public var template: String {
        var xml = ""
        if let url = NSBundle.mainBundle().URLForResource(templateFile, withExtension: "xml") {
            xml = try! String(contentsOfURL: url)
            xml = xml.stringByReplacingOccurrencesOfString("{{TITLE}}", withString: title)
            xml = xml.stringByReplacingOccurrencesOfString("{{DESCRIPTION}}", withString: description)
            xml = xml.stringByReplacingOccurrencesOfString("{{BUTTONS}}", withString: buttonString)
        }
        return xml
    }
}