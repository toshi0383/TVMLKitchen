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
class AppDelegate: UIResponder, UIApplicationDelegate, TVApplicationControllerDelegate {

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        _ = prepareMyKitchen(launchOptions, delegate: self)
        return true
    }

    // Custom TVApplicationControllerDelegate
    func appController(_ appController: TVApplicationController, evaluateAppJavaScriptIn jsContext: JSContext) {
        print("\(#function): hello")
    }

}

private func prepareMyKitchen(_ launchOptions: [AnyHashable: Any]?, delegate: TVApplicationControllerDelegate) -> Bool
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
    cookbook.actionIDHandler = {
        actionID in
        print("actionID: \(actionID)")
    }
    cookbook.playActionIDHandler = {
        playActionID in
        print("playActionID: \(playActionID)")
    }
    cookbook.httpHeaders = [
        "hello": "world"
    ]

    cookbook.responseObjectHandler = { response in
        /// Save cookies
        if let fields = response.allHeaderFields as? [String: String],
            let url = response.url
        {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
            for c in cookies {
                HTTPCookieStorage.sharedCookieStorage(
                    forGroupContainerIdentifier: "group.jp.toshi0383.tvmlkitchen.samplerecipe").setCookie(c)
            }
        }
        return true
    }

    Kitchen.prepare(cookbook, delegate: delegate)
    openViewController()

    return true
}

struct SearchTab: TabItem {
    let title = "Search"
    func handler() {
        let search = MySearchRecipe(type: .tabSearch)
        Kitchen.serve(recipe: search)
    }
}

private func openViewController() {
    let sb = UIStoryboard(name: "ViewController", bundle: Bundle.main)
    let vc = sb.instantiateInitialViewController()!
    Kitchen.navigationController.pushViewController(vc, animated: true)
}
