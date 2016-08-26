//
//  ViewController.swift
//  SampleRecipe
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

import UIKit
import TVMLKitchen

class MusicsTab: TabItem {
    private var presented = false
    var title: String {
        return "Musics"
    }
    func handler() {
        Kitchen.serve(xmlFile: "Catalog.xml", type: .Tab)
        if !presented {
            presented = true
        } else {
//            Kitchen.reloadTab(atIndex: 0, xmlFile: "Oneup.xml")
//            Kitchen.reloadTab(atIndex: 0, urlString: Sample.tvmlUrl)
            let search = MySearchRecipe()
            Kitchen.reloadTab(atIndex: 0, recipe: search)
        }
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
        Kitchen.serve(xmlString:XMLString.Catalog.description, type: .DefaultWithLoadingIndicator)
    }

    @IBAction func openXMLFileFromMainBundle(sender: AnyObject!) {
        Kitchen.serve(xmlFile: "Catalog.xml")
    }

    @IBAction func openTemplateFromURL(sender: AnyObject!) {
        Kitchen.serveInNewWindow(urlString: Sample.tvmlUrl)
    }

    @IBAction func descriptiveAlertRecipe(sender: AnyObject) {
        let alert = DescriptiveAlertRecipe(
            title: Sample.title,
            description: Sample.description,
            presentationType: .Modal
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
