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
        navigationController?.view.backgroundColor = .black()
        view.backgroundColor = .black()
    }

    @IBAction func urlString(_ sender: AnyObject!) {
        let appdelegateWindow = (UIApplication.shared.delegate as! AppDelegate).window!
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
    @IBAction func xmlString(_ sender: AnyObject!) {
        let appdelegateWindow = (UIApplication.shared.delegate as! AppDelegate).window!
        Kitchen.window.alpha = 1.0
        Kitchen.serve(
            xmlString: Sample.tvmlString,
            redirectWindow: appdelegateWindow,
            animatedWindowTransition: true
        )

        let seconds: Double = 2.0
        let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
        let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.reset()
        }
    }
    @IBAction func urlStringError() {
        let appdelegateWindow = (UIApplication.shared.delegate as! AppDelegate).window!
        Kitchen.serve(
            urlString: "tvmlkitchen://helloworld.com/helloworld",
            redirectWindow: appdelegateWindow
        )
    }
    @IBAction func reset() {
        Kitchen.navigationController.popToRootViewControllerAnimated(false)
        Kitchen.navigationController.setViewControllers([], animated: false)
    }
}
