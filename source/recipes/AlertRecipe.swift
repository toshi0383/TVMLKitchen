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

public class AlertRecipe: TemplateRecipeType {

    public let theme = EmptyTheme()
    public let presentationType: PresentationType
    public let title: String
    public let description: String
    public let buttons: [AlertButton]

    public init(title: String, description: String,
        buttons: [AlertButton] = [],
        presentationType: PresentationType = .Modal) {
        self.title = title
        self.description = description
        self.buttons = buttons
        self.presentationType = presentationType
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

    public var replacementDictionary: [String: String] {
        return ["TITLE": title,
            "DESCRIPTION": description,
            "BUTTONS": buttonString
        ]
    }
}
