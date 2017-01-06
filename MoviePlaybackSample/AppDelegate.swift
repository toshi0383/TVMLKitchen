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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
    {
        let vc = AVPlayerViewController()
        
        vc.player = AVPlayer(URL: url)
        
        dispatch_async(dispatch_get_main_queue())
        {
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
    
    var window: UIWindow?
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //        Kitchen.prepare(Cookbook(launchOptions: launchOptions))
        
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

