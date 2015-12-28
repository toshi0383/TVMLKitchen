//
//  AppDelegate.swift
//  SampleRecipe
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

import UIKit
import TVMLKitchen
import JavaScriptCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = Kitchen.window

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        _ = prepareMyKitchen(launchOptions)
        openTVMLTemplateFromXMLFile("Catalog.xml.js")
        return true
    }

    // swiftlint:disable line_length
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
    // swiftlint:enable line_length
}

private func prepareMyKitchen(launchOptions: [NSObject: AnyObject]?) -> Bool
{
    Kitchen.prepare(launchOptions, evaluateAppJavaScriptInContext:
    {appController, jsContext in
        /// set Exception handler
        /// called on JS error
        jsContext.exceptionHandler = {context, value in
            LOG(context)
            LOG(value)
            assertionFailure("You got JS error. Check your javascript code.")
        }

        // - SeeAlso: http://nshipster.com/javascriptcore/
        let consoleLog: @convention(block) String -> Void = { message in
            LOG(message)
        }
        jsContext.setObject(unsafeBitCast(consoleLog, AnyObject.self),
            forKeyedSubscript: "debug")

    }, onLaunchError: { error in
        let title = "Error Launching Application"
        let message = error.localizedDescription
        let alertController = UIAlertController(title: title, message: message, preferredStyle:.Alert )

        Kitchen.navigationController.presentViewController(alertController, animated: true) { }

    })

    return true
}
