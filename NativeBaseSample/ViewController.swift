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
        navigationController?.view.backgroundColor = .blackColor()
        view.backgroundColor = .blackColor()
    }

    @IBAction func urlString(sender: AnyObject!) {
        let appdelegateWindow = (UIApplication.sharedApplication().delegate as! AppDelegate).window!
        Kitchen.serve(
            urlString: Sample.tvmlUrl,
            redirectWindow: appdelegateWindow,

            // - Note: This is what Kitchen would do when animatedWindowTransition is true.
            kitchenWindowWillBecomeVisible: {
                Kitchen.window.alpha = 0.0
                UIView.animateWithDuration(
                    0.3,
                    animations: {
                        Kitchen.window.alpha = 1.0
                    },
                    completion: {
                        _ in
                        appdelegateWindow.alpha = 0.0
                    }
                )
            },
            willRedirectToWindow: {
                appdelegateWindow.alpha = 0.0
                UIView.animateWithDuration(
                    0.3,
                    animations: {
                        appdelegateWindow.alpha = 1.0
                    },
                    completion: {
                        _ in
                        Kitchen.window.alpha = 0.0
                    }
                )
            }
        )
    }
    @IBAction func xmlString(sender: AnyObject!) {
        let appdelegateWindow = (UIApplication.sharedApplication().delegate as! AppDelegate).window!
        Kitchen.window.alpha = 1.0
        Kitchen.serve(
            xmlString: Sample.tvmlString,
            redirectWindow: appdelegateWindow,
            animatedWindowTransition: true
        )
    }
}
