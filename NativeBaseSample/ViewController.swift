//
//  ViewController.swift
//  NativeBaseSample
//
//  Created by toshi0383 on 8/26/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import UIKit
import TVMLKitchen

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func urlString(sender: AnyObject!) {
        let appdelegateWindow = (UIApplication.sharedApplication().delegate as! AppDelegate).window!
        appdelegateWindow.alpha = 0.0
        Kitchen.serve(urlString: Sample.tvmlUrl, redirectWindow: appdelegateWindow) {
            $0.alpha = 1.0
        }
    }
    @IBAction func xmlString(sender: AnyObject!) {
        let appdelegateWindow = (UIApplication.sharedApplication().delegate as! AppDelegate).window!
        appdelegateWindow.alpha = 0.0
        Kitchen.serve(xmlString: Sample.tvmlString, redirectWindow: appdelegateWindow) {
            $0.alpha = 1.0
        }
    }
}

