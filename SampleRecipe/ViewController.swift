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
    static let tvmlUrl = "https://raw.githubusercontent.com/toshi0383/TVMLKitchen/navcon/SampleRecipe/Catalog.xml"
}
// swiftlint:enable line_length

import UIKit
import TVMLKitchen

class MusicsTab: TabItem {
    var title: String {
        return "Musics"
    }
    func handler() {
        Kitchen.serve(xmlFile: "Oneup.xml", type: .Tab)
    }
}

class MoviesTab: TabItem {
    var title: String {
        return "Movies"
    }
    func handler() {
        Kitchen.serve(xmlFile: "Catalog.xml", type: .Tab)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tabbarRecipe() {
        let tabbar = KitchenTabBar(items: [
            MoviesTab(),
            MusicsTab()
        ])
        Kitchen.serve(recipe: tabbar)
    }

    @IBAction func openCatalogTemplate() {
        let search = MySearchRecipe()
        Kitchen.serve(recipe: search)
    }

    @IBAction func openXMLString(sender: AnyObject!) {
        Kitchen.serve(xmlString:XMLString.Catalog.description, type: .ModalWithLoadingIndicator)
    }

    @IBAction func openTemplateFromURL(sender: AnyObject!) {
        Kitchen.serve(urlString: Sample.tvmlUrl, type: .ModalWithLoadingIndicator)
    }

    @IBAction func descriptiveAlertRecipe(sender: AnyObject) {
        let alert = DescriptiveAlertRecipe(
            title: Sample.title,
            description: Sample.description,
            presentationType: .ModalWithLoadingIndicator
        )
        Kitchen.serve(recipe: alert)
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
        let catalog = CatalogRecipe(banner: banner, sections: (0..<10).map{_ in section1})
        Kitchen.serve(recipe: catalog)
    }

}
