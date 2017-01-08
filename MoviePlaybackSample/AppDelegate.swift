//
//  AppDelegate.swift
//  MoviePlaybackSample
//
//  Created by Wei Xia on 1/6/17.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import UIKit
import TVMLKitchen
import JavaScriptCore
import AVKit

struct Action {
    private let f: (()->())
    func run() {
        f()
    }
    init?(string: String) {
        let ss = string.componentsSeparatedByString(",")
        guard ss.count == 2 else {
            return nil
        }
        switch ss[0] {
        case "playbackURL":
            guard let url = NSURL(string: ss[1]) else {
                return nil
            }
            self.f = {
                startPlayback(url)
            }
        default:
            return nil
        }
    }
}

func startPlayback(url: NSURL) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
        let vc = AVPlayerViewController()
        
        vc.player = AVPlayer(URL: url)
        
        dispatch_async(dispatch_get_main_queue()){
            Kitchen.navigationController.pushViewController(vc, animated: true)
        }
    }
}

private func xmlString() -> String {
    
    let data = NSData(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Sample", ofType: "xml")!))
    
    return String(data)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        let cookbook = Cookbook(launchOptions: launchOptions)
        cookbook.actionIDHandler = {
            actionID in
            // actionID can be any string.
            // In this sample, we're expecting comma separated string.
            if let action = Action(string: actionID) {
                action.run()
            }
        }
        
        // This callback is triggered by `play/pause` button.
        cookbook.playActionIDHandler = {
            playActionID in
            if let action = Action(string: playActionID) {
                action.run()
            }
        }
        Kitchen.prepare(cookbook)
        Kitchen.serve(xmlString: xmlString())
        
        return true
    }
}

