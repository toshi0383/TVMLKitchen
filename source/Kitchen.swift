//
//  Kitchen.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

import Foundation
import TVMLKit

public typealias JavaScriptEvaluationHandler = (TVApplicationController, JSContext) -> Void
public typealias KitchenLaunchErrorHandler = NSError -> Void

public class Kitchen: NSObject {
    /// singleton instance
    private static let sharedKitchen = Kitchen()

    private var evaluateAppJavaScriptInContext: JavaScriptEvaluationHandler?

    private var kitchenLaunchErrorHandler: KitchenLaunchErrorHandler?

    private var window: UIWindow

    private var appController: TVApplicationController!

    override init() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        super.init()
    }

}

extension Kitchen {

    public static var window: UIWindow {
        return sharedKitchen.window
    }

    public static var navigationController: UINavigationController {
        return sharedKitchen.appController.navigationController
    }

    public static func prepare(launchOptions: [NSObject: AnyObject]?,
        evaluateAppJavaScriptInContext: JavaScriptEvaluationHandler? = nil,
        onLaunchError kitchenLaunchErrorHandler: KitchenLaunchErrorHandler? = nil) -> Bool
    {
        sharedKitchen.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        /*
        Create the TVApplicationControllerContext for this application
        and set the properties that will be passed to the `App.onLaunch` function
        in JavaScript.
        */
        let appControllerContext = TVApplicationControllerContext()

        /*
        The JavaScript URL is used to create the JavaScript context for your
        TVMLKit application. Although it is possible to separate your JavaScript
        into separate files, to help reduce the launch time of your application
        we recommend creating minified and compressed version of this resource.
        This will allow for the resource to be retrieved and UI presented to
        the user quickly.
        */
        let javaScriptURL = NSBundle.mainBundle().URLForResource("application", withExtension: "js")!
        appControllerContext.javaScriptApplicationURL = javaScriptURL
        appControllerContext.launchOptions[UIApplicationLaunchOptionsURLKey] = javaScriptURL

        let TVBaseURL = javaScriptURL.URLByDeletingLastPathComponent

        appControllerContext.launchOptions["BASEURL"] = TVBaseURL!.absoluteString
        let info = NSBundle.mainBundle().infoDictionary!
        let bundleid = info[String(kCFBundleIdentifierKey)]!
        appControllerContext.launchOptions[UIApplicationLaunchOptionsSourceApplicationKey] = bundleid

        if let launchOptions = launchOptions as? [String: AnyObject] {
            for (kind, value) in launchOptions {
                appControllerContext.launchOptions[kind] = value
            }
        }

        sharedKitchen.appController = TVApplicationController(context: appControllerContext,
            window: sharedKitchen.window, delegate: sharedKitchen)

        sharedKitchen.evaluateAppJavaScriptInContext = evaluateAppJavaScriptInContext
        sharedKitchen.kitchenLaunchErrorHandler = kitchenLaunchErrorHandler
        return true
    }

}

// MARK: TVApplicationControllerDelegate
extension Kitchen: TVApplicationControllerDelegate {

    public func appController(appController: TVApplicationController,
        didFinishLaunchingWithOptions options: [String: AnyObject]?)
    {
        LOG("\(__FUNCTION__) invoked with options: \(options)")
    }

    public func appController(appController: TVApplicationController,
        didFailWithError error: NSError)
    {
        LOG("\(__FUNCTION__) invoked with error: \(error)")
        self.kitchenLaunchErrorHandler?(error)
    }

    public func appController(appController: TVApplicationController,
        didStopWithOptions options: [String: AnyObject]?)
    {
            LOG("\(__FUNCTION__) invoked with options: \(options)")
    }

    public func appController(appController: TVApplicationController,
        evaluateAppJavaScriptInContext jsContext: JSContext)
    {
        self.evaluateAppJavaScriptInContext?(appController, jsContext)
    }
}
