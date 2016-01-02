//
//  Kitchen.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

import TVMLKit

public typealias JavaScriptEvaluationHandler = (TVApplicationController, JSContext) -> Void
public typealias KitchenErrorHandler = NSError -> Void

public class Kitchen: NSObject {
    /// singleton instance
    private static let sharedKitchen = Kitchen()

    private var evaluateAppJavaScriptInContext: JavaScriptEvaluationHandler?

    private var kitchenErrorHandler: KitchenErrorHandler?

    private static let defaultErrorHandler: KitchenErrorHandler = { error in
        let alert = UIAlertController(title: "Error occured.",
            message: "Oops, something's wrong.:\(error.localizedDescription)",
            preferredStyle: UIAlertControllerStyle.Alert)
        Kitchen.navigationController.presentViewController(alert, animated: true, completion: nil)
    }

    private var window: UIWindow

    private var appController: TVApplicationController!

    private var actionIDHandler: (String -> Void)?

    public static var mainBundlePath: String!

    override init() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        super.init()
    }

}

// MARK: Public API (serve)
extension Kitchen {

    public static func serve(xmlString xmlString: String) {
        openTVMLTemplateFromXMLString(xmlString)
    }

    public static func serve(jsFile jsFile: String) {
        openTVMLTemplateFromJSFile(jsFile)
    }

    public static func serve<R: RecipeType>
        (recipe recipe: R, actionIDHandler: (String -> Void)? = nil)
    {
        sharedKitchen.actionIDHandler = actionIDHandler
        openTVMLTemplateFromXMLString(recipe.xmlString)
    }
}

// MARK: window
extension Kitchen {

    public static var window: UIWindow {
        return sharedKitchen.window
    }

}

// MARK: TVApplicationControllerDelegate
extension Kitchen {

    public static var appController: TVApplicationController {
        return sharedKitchen.appController
    }

    public static var navigationController: UINavigationController {
        return sharedKitchen.appController.navigationController
    }
}

extension Kitchen {

    /**
     create TVApplicationControllerContext using launchOptions

     Supposed to be called in application:didFinishedLaunchingWithOptions:
     in UIApplicationDelegate of your @UIApplicationMain .

     - parameter launchOptions: launchOptions
     - parameter evaluateAppJavaScriptInContext:
                 the closure to inject functions or a exceptionHandler into JSContext
     - parameter onError: the Error handler that gets called when any errors occured
                 in Kitchen(both JS and Swift context)
     - returns:  If launch process was successfully or not.
     */
    public static func prepare(launchOptions: [NSObject: AnyObject]?,
        evaluateAppJavaScriptInContext: JavaScriptEvaluationHandler? = nil,
        onError kitchenErrorHandler: KitchenErrorHandler? = defaultErrorHandler) -> Bool
    {
        sharedKitchen.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        sharedKitchen.evaluateAppJavaScriptInContext = evaluateAppJavaScriptInContext
        sharedKitchen.kitchenErrorHandler = kitchenErrorHandler

        /// Create the TVApplicationControllerContext
        let appControllerContext = TVApplicationControllerContext()

        let javaScriptURL = NSBundle(forClass: self).URLForResource("kitchen", withExtension: "js")!
        appControllerContext.javaScriptApplicationURL = javaScriptURL
        appControllerContext.launchOptions[UIApplicationLaunchOptionsURLKey] = javaScriptURL

        /// Cutting `kitchen.js` off
        let TVBaseURL = javaScriptURL.URLByDeletingLastPathComponent

        /// Define framework bundle URL
        appControllerContext.launchOptions["BASEURL"] = TVBaseURL!.absoluteString
        let info = NSBundle(forClass: self).infoDictionary!
        let bundleid = info[String(kCFBundleIdentifierKey)]!
        appControllerContext.launchOptions[UIApplicationLaunchOptionsSourceApplicationKey] = bundleid

        /// Define mainBundle URL
        mainBundlePath = NSBundle.mainBundle().bundleURL.absoluteString
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

    /// Calls TVApplicationController.stop()
    public static func stop() {
        sharedKitchen.appController.stop()
    }

}

// MARK: TVApplicationControllerDelegate
extension Kitchen: TVApplicationControllerDelegate {

    public func appController(appController: TVApplicationController,
        didFinishLaunchingWithOptions options: [String: AnyObject]?)
    {
    }

    public func appController(appController: TVApplicationController,
        didFailWithError error: NSError)
    {
        self.kitchenErrorHandler?(error)
    }

    public func appController(appController: TVApplicationController,
        didStopWithOptions options: [String: AnyObject]?)
    {
    }

    public func appController(appController: TVApplicationController,
        evaluateAppJavaScriptInContext jsContext: JSContext)
    {
        /// inject Debug logger for TVMLKitchen
        let consoleLog: @convention(block) String -> Void = { message in
            #if DEBUG
            debugPrint(message)
            #endif
        }
        jsContext.setObject(unsafeBitCast(consoleLog, AnyObject.self),
            forKeyedSubscript: "__kitchenDebug")

        let actionIDHandler: @convention(block) String -> Void = {[weak self] actionID in
            self?.actionIDHandler?(actionID)
        }
        jsContext.setObject(unsafeBitCast(actionIDHandler, AnyObject.self),
            forKeyedSubscript: "actionIDHandler")

        self.evaluateAppJavaScriptInContext?(appController, jsContext)
    }
}
