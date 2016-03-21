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

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        _ = prepareMyKitchen(launchOptions)
        openRecipe()
        return true
    }

    private func openRecipe() {

        let banner = "Movie"
        let thumbnailUrl = NSBundle.mainBundle().URLForResource("img",
            withExtension: "jpg")!.absoluteString
        let actionID = "/title?titleId=1234"
        let (width, height) = (250, 376)
        let templateURL: String? = nil
        // let templateURL = Kitchen.mainBundlePath + "Catalog.xml.js"
        let content: Section.ContentTuple = ("Star Wars", thumbnailUrl, actionID, templateURL, width, height)
//        let content: Section.ContentTuple = ("Star Wars", thumbnailUrl, nil,
//                templateURL, width, height)

        let section1 = Section(title: "Section 1", args: (0...100).map{_ in content})
        let catalog = CatalogRecipe<BlackTheme>(banner: banner, sections: (0...10).map{_ in section1})
//        Kitchen.serve(recipe: catalog)
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
    let cookbook = Cookbook(launchOptions: launchOptions)
    cookbook.evaluateAppJavaScriptInContext = {appController, jsContext in
        /// set Exception handler
        /// called on JS error
        jsContext.exceptionHandler = {context, value in
            #if DEBUG
            debugPrint(context)
            debugPrint(value)
            #endif
            assertionFailure("You got JS error. Check your javascript code.")
        }

        // - SeeAlso: http://nshipster.com/javascriptcore/

    }
    cookbook.actionIDHandler = { actionID in
        let identifier = actionID // parse action ID here
        dispatch_async(dispatch_get_main_queue()) {
            openViewController(identifier)
        }
    }
    cookbook.playActionIDHandler = {actionID in
        print(actionID)
    }
    cookbook.httpHeaders = [
        "hello": "world"
    ]

    cookbook.responseObjectHandler = { response in
        /// Save cookies
        if let fields = response.allHeaderFields as? [String: String],
            let url = response.URL
        {
            let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: url)
            for c in cookies {
                NSHTTPCookieStorage.sharedCookieStorageForGroupContainerIdentifier(
                    "group.jp.toshi0383.tvmlkitchen.samplerecipe").setCookie(c)
            }
        }
        return true
    }
    Kitchen.prepare(cookbook)
    KitchenTabBar.sharedBar.items = [
        SearchTab()
    ]

    return true
}

struct SearchTab: TabItem {
    let title = "Search"
    func handler() {
        let search = SearchRecipe(type: .TabSearch)
        Kitchen.serve(recipe: search)
    }
}

private func openViewController(identifier: String) {
    print(__FUNCTION__)
    print(identifier)
    let sb = UIStoryboard(name: "ViewController", bundle: NSBundle.mainBundle())
    let vc = sb.instantiateInitialViewController()!
    Kitchen.navigationController.pushViewController(vc, animated: true)
}
