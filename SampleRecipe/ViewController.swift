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
    fileprivate var presented = false
    var title: String {
        return "Musics"
    }
    func handler() {
        Kitchen.serve(xmlFile: "Catalog.xml", type: .tab)
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
        Kitchen.serve(xmlFile: "Catalog.xml", type: .tab)
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

    @IBAction func openXMLString(_ sender: AnyObject!) {
        Kitchen.serve(xmlString:XMLString.Catalog.description, type: .defaultWithLoadingIndicator)
    }

    @IBAction func openXMLFileFromMainBundle(_ sender: AnyObject!) {
        Kitchen.serve(xmlFile: "Catalog.xml")
    }

    @IBAction func openTemplateFromURL(_ sender: AnyObject!) {
        Kitchen.serve(urlString: "https://raw.githubusercontent.com/toshi0383/TVMLKitchen/master/SampleRecipe/Oneup.xml") {
            result in
            switch result {
            case .success(let xml):
                // Return the xml if you think it's valid xml.
                // You don't have to use `Kitchen.verify`.
                // the `xml` is just a utf8 String representation of HTTP response body.
                // It can be arbitrary data (e.g. a JSON representing error).
                do {
                    try Kitchen.verify(xml)
                } catch {
                    fatalError("error: \(error)")
                }
                return xml
            case .failure(let error):
                // Handle Network error
                fatalError("error: \(error)")
            }
            return nil
        }
    }

    @IBAction func descriptiveAlertRecipe(_ sender: AnyObject) {
        let alert = DescriptiveAlertRecipe(
            title: Sample.title,
            description: Sample.description,
            presentationType: .modal
        )
        Kitchen.serve(recipe: alert)
    }

    @IBAction func alertRecipe(_ sender: AnyObject) {
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
        let thumbnailUrl = Bundle.main.url(forResource: "img",
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

    @IBAction func verify() {
        let valid = Sample.tvmlString
        let invalid = "<><<<<>>aaaa"
        do {
            try Kitchen.verify(valid)
            print("Verify success!!")
        } catch _ as KitchenError {
            fatalError()
        } catch {
            fatalError()
        }
        do {
            try Kitchen.verify(invalid)
            fatalError()
        } catch _ as KitchenError {
            print("Verify success!!")
        } catch {
            fatalError()
        }
    }

}
