//
//  ViewController.swift
//  SampleRecipe
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

// swiftlint:disable line_length
struct Sample {
    static let title = "TVMLKitchen"
    static let description = "Swift is a high-performance system programming language. It has a clean and modern syntax, offers seamless access to existing C and Objective-C code and frameworks, and is memory safe by default."
    static let tvmlUrl = "https://raw.githubusercontent.com/toshi0383/TVMLKitchen/master/SampleRecipe/Oneup.xml"
}
// swiftlint:enable line_length

import UIKit
import TVMLKitchen

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openCatalogTemplate() {
        print(__FUNCTION__)
        Kitchen.serve(xmlFile: "Search.xml", type: .Search)
    }

    @IBAction func openXMLString(sender: AnyObject!) {
        print(__FUNCTION__)
        Kitchen.serve(xmlString:XMLString.Catalog.description, type: .Modal)
    }

    @IBAction func openTemplateFromURL(sender: AnyObject!) {
        print(__FUNCTION__)
        Kitchen.serve(urlString: Sample.tvmlUrl)
    }

    @IBAction func descriptiveAlertRecipe(sender: AnyObject) {
        Kitchen.serve(recipe: DescriptiveAlertRecipe(
            title: Sample.title,
            description: Sample.description)
        )
    }

    @IBAction func alertRecipe(sender: AnyObject) {
        Kitchen.serve(recipe: AlertRecipe(
            title: Sample.title,
            description: Sample.description)
        )
    }

    struct MyTheme: ThemeType {
        let backgroundColor: String = "rgb(0, 20, 70)"
        let color: String = "rgb(237, 237, 255)"
        init() {}
    }

    @IBAction func openCustomTheme() {
        let banner = "Music"
        let thumbnailUrl = NSBundle.mainBundle().URLForResource("img",
            withExtension: "jpg")!.absoluteString
        let actionID = "/title?titleId=1234"
        let (width, height) = (250, 376)
        let templateURL: String? = nil
        let content: Section.ContentTuple = ("Mission Impossible Ghost Protocol", thumbnailUrl, actionID,
            templateURL, width, height)

        let section1 = Section(title: "Hello", args: (0..<10).map{_ in content})
        let catalog = CatalogRecipe<MyTheme>(banner: banner, sections: (0..<10).map{_ in section1})
        Kitchen.serve(recipe: catalog)
    }

}
