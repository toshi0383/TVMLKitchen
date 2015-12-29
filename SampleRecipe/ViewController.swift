//
//  ViewController.swift
//  SampleRecipe
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

import UIKit
import TVMLKitchen

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openCatalogTemplate() {
        LOG()
        Kitchen.serve(jsFile:"Catalog.xml.js")
    }

    @IBAction func openRawXMLFile(sender: AnyObject!) {
        LOG()
        Kitchen.serve(rawXML:RawXMLString.Catalog.description)
    }

}
