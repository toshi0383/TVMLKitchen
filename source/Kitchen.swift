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

    public static var appController: TVApplicationController {
        return sharedKitchen.appController
    }

    public static var navigationController: UINavigationController {
        return sharedKitchen.appController.navigationController
    }

    public static func prepare(launchOptions: [NSObject: AnyObject]?,
        evaluateAppJavaScriptInContext: JavaScriptEvaluationHandler? = nil,
        onLaunchError kitchenLaunchErrorHandler: KitchenLaunchErrorHandler? = nil) -> Bool
    {
        sharedKitchen.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        sharedKitchen.evaluateAppJavaScriptInContext = evaluateAppJavaScriptInContext
        sharedKitchen.kitchenLaunchErrorHandler = kitchenLaunchErrorHandler

        /*
        Create the TVApplicationControllerContext
        */
        let appControllerContext = TVApplicationControllerContext()

        let javaScriptURL = NSBundle(forClass: self).URLForResource("application", withExtension: "js")!
        appControllerContext.javaScriptApplicationURL = javaScriptURL
        appControllerContext.launchOptions[UIApplicationLaunchOptionsURLKey] = javaScriptURL

        /// Cutting `application.js` off
        let TVBaseURL = javaScriptURL.URLByDeletingLastPathComponent

        /// Define framework bundle URL
        appControllerContext.launchOptions["BASEURL"] = TVBaseURL!.absoluteString
        let info = NSBundle(forClass: self).infoDictionary!
        let bundleid = info[String(kCFBundleIdentifierKey)]!
        appControllerContext.launchOptions[UIApplicationLaunchOptionsSourceApplicationKey] = bundleid

        /// Define mainBundle URL
        let mainBundlePath = NSBundle.mainBundle().bundleURL.absoluteString
        appControllerContext.launchOptions["MAIN_BUNDLE_URL"] = mainBundlePath

        if let launchOptions = launchOptions as? [String: AnyObject] {
            for (kind, value) in launchOptions {
                appControllerContext.launchOptions[kind] = value
            }
        }

        sharedKitchen.appController = TVApplicationController(context: appControllerContext,
            window: sharedKitchen.window, delegate: sharedKitchen)
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
        /// inject Debug logger for TVMLKitchen
        let consoleLog: @convention(block) String -> Void = { message in
            LOG(message)
        }
        jsContext.setObject(unsafeBitCast(consoleLog, AnyObject.self),
            forKeyedSubscript: "kitchenDebug")

        self.evaluateAppJavaScriptInContext?(appController, jsContext)
    }
}
