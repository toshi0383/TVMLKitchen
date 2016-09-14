//
//  Kitchen.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

@_exported import TVMLKit

public typealias JavaScriptEvaluationHandler = (TVApplicationController, JSContext) -> Void
public typealias KitchenErrorHandler = NSError -> Void
public typealias KitchenActionIDHandler = (String -> Void)
public typealias KitchenTabItemHandler = (Int -> Void)

let kitchenErrorDomain = "jp.toshi0383.TVMLKitchen.error"

public class Kitchen: NSObject {
    /// singleton instance
    private static let sharedKitchen = Kitchen()
    private static weak var redirectWindow: UIWindow?
    private static var _navigationControllerDelegateWillShowCount = 0
    private static var didRedirectToWindow: (UIWindow -> ())?

    private var evaluateAppJavaScriptInContext: JavaScriptEvaluationHandler?

    private var kitchenErrorHandler: KitchenErrorHandler? {
        didSet {
            Kitchen.appController.evaluateInJavaScriptContext({jsContext in
                let errorHandler: @convention(block) String -> Void =
                { [unowned self] (message: String) in
                    let error = NSError(domain: kitchenErrorDomain,
                        code: 1, userInfo: [NSLocalizedDescriptionKey:message])
                    self.kitchenErrorHandler?(error)
                }
                jsContext.setObject(unsafeBitCast(errorHandler, AnyObject.self),
                    forKeyedSubscript: "kitchenErrorHandler")
            }, completion: nil)
        }
    }

    private static let defaultErrorHandler: KitchenErrorHandler = { error in
        let alert = UIAlertController(title: "Oops, something's wrong.",
            message: "\(error.localizedDescription)",
            preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(ok)
        main {
            Kitchen.navigationController.presentViewController(alert, animated: true, completion: nil)
        }
    }

    private var window: UIWindow

    private var appController: TVApplicationController!

    private var actionIDHandler: KitchenActionIDHandler?
    private var playActionIDHandler: KitchenActionIDHandler?
    private var cookbook: Cookbook!

    public static var mainBundlePath: String!

    override init() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        super.init()
    }

}


// MARK: Public API (serve)
extension Kitchen {

    public static func serve(xmlString xmlString: String, type: PresentationType = .Default) {
        openTVMLTemplateFromXMLString(xmlString, type: type)
    }

    public static func serve(xmlFile xmlFile: String, type: PresentationType = .Default) {
        do {
            try openTVMLTemplateFromXMLFile(xmlFile, type: type)
        } catch let error as NSError {
            sharedKitchen.kitchenErrorHandler?(error)
        }
    }

    /// Serve TVML with xmlString
    /// Calls `redirectWindow.makeKeyAndVisible()` when the TVML is dismissing.
    /// - parameter urlString:
    /// - parameter type:
    /// - parameter redirectWindow: UIWindow.
    ///     Expected to be the parent window of Native Views(not Kitchen.window)
    /// - parameter didRedirectToWindow: Redirect Callback
    /// - Note: **BETA API** This API is subject to change.
    public static func serve(xmlString xmlString: String,
       type: PresentationType = .Default, redirectWindow: UIWindow,
       didRedirectToWindow: (UIWindow -> ())? = nil)
    {
        Kitchen._navigationControllerDelegateWillShowCount = 0
        Kitchen.navigationController.setViewControllers([UIViewController()], animated: true)
        Kitchen.navigationController.delegate = sharedKitchen
        Kitchen.didRedirectToWindow = didRedirectToWindow
        Kitchen.redirectWindow = redirectWindow
        Kitchen.serve(xmlString: xmlString, type: type)
        Kitchen.window.makeKeyAndVisible()
    }

    /// Serve TVML with urlString
    /// Calls `redirectWindow.makeKeyAndVisible()` when the TVML is dismissing.
    /// - parameter urlString:
    /// - parameter type:
    /// - parameter redirectWindow: UIWindow.
    ///     Expected to be the parent window of Native Views(not Kitchen.window)
    /// - parameter didRedirectToWindow: Redirect Callback
    /// - Note: **BETA API** This API is subject to change.
    public static func serve(urlString urlString: String,
       type: PresentationType = .Default, redirectWindow: UIWindow,
       didRedirectToWindow: (UIWindow -> ())? = nil)
    {
        Kitchen._navigationControllerDelegateWillShowCount = 0
        Kitchen.navigationController.setViewControllers([UIViewController()], animated: true)
        Kitchen.navigationController.delegate = sharedKitchen
        Kitchen.didRedirectToWindow = didRedirectToWindow
        Kitchen.redirectWindow = redirectWindow
        Kitchen.serve(urlString: urlString, type: type)
        Kitchen.window.makeKeyAndVisible()
    }

    public static func serve(urlString urlString: String, type: PresentationType = .Default) {
        Kitchen.appController.evaluateInJavaScriptContext({
            context in
            let js = "showLoadingIndicatorForType(\(type.rawValue))"
            context.evaluateScript(js)
        }, completion: nil)
        sharedKitchen.sendRequest(urlString) { result in
            switch result {
            case .Success(let xmlString):
                openTVMLTemplateFromXMLString(xmlString, type: type)
            case .Failure(let error):
                sharedKitchen.kitchenErrorHandler?(error)
            }
        }
    }

    public static func serve<R: RecipeType>(recipe recipe: R) {
        if let recipe = recipe as? SearchRecipe {
            sharedKitchen.cookbook.searchRecipe = recipe
        }
        if let recipe = recipe as? KitchenTabBar {
            sharedKitchen.cookbook.tabChangedHandler = recipe.tabChanged
        }
        openTVMLTemplateFromXMLString(recipe.xmlString, type: recipe.presentationType)
    }

    public static func reloadTab<R: RecipeType>(atIndex index: Int, recipe: R) {
        _reloadTab(atIndex: index, xmlString: recipe.xmlString)
    }

    public static func reloadTab(atIndex index: Int, xmlFile: String) {
        do {
            _reloadTab(atIndex: index, xmlString: try xmlStringFromMainBundle(xmlFile))
        } catch let error as NSError {
            sharedKitchen.kitchenErrorHandler?(error)
        }
    }

    public static func reloadTab(atIndex index: Int, urlString: String) {
        sharedKitchen.sendRequest(urlString) {
            result in
            switch result {
            case .Success(let xmlString):
                _reloadTab(atIndex: index, xmlString: xmlString)
            case .Failure(let error):
                sharedKitchen.kitchenErrorHandler?(error)
            }
        }
    }

    public static func reloadTab(atIndex index: Int, xmlString: String) {
        _reloadTab(atIndex: index, xmlString: xmlString)
    }

    public static func dismissModal() {
        dismissTVMLModal()
    }

    public static func bundle() -> NSBundle {
        return NSBundle(forClass: self)
    }
}


// MARK: Network Request

internal enum Result<T, E> {
    case Success(T)
    case Failure(E)
}

extension Kitchen {
    internal func sendRequest(urlString: String, responseHandler: Result<String, NSError> -> ()) {
        guard let url = NSURL(string: urlString) else {
            print("Invalid URL")
            responseHandler(.Failure(
                NSError(domain: kitchenErrorDomain, code: 0, userInfo: nil)
            ))
            return
        }

        /// Create Request
        let req = NSMutableURLRequest(URL: url)

        /// Custom Headers
        for (k, v) in cookbook.httpHeaders {
            req.setValue(v, forHTTPHeaderField: k)
        }

        /// Session Handler
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(req) {[unowned self] data, res, error in
            if let error = error {
                responseHandler(.Failure(error))
            }

            /// Call user-defined responseObjectHander if no errors.
            if let res = res as? NSHTTPURLResponse,
                let resume = self.cookbook.responseObjectHandler?(res)
                where resume == false
            {
                return
            }

            if let data = data,
                let xml = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
            {
                responseHandler(Result.Success(xml))
            } else {
                responseHandler(Result.Failure(
                    NSError(domain: kitchenErrorDomain, code: 0, userInfo: nil)
                ))
            }
        }
        task.resume()
    }
}

// MARK: window
extension Kitchen {

    public static var window: UIWindow {
        return sharedKitchen.window
    }

}

// MARK: UINavigationControllerDelegate
extension Kitchen: UINavigationControllerDelegate {
    public func navigationController(
        navigationController: UINavigationController,
        willShowViewController viewController: UIViewController, animated: Bool)
    {
        // Workaround: This delegate is called on presenting, too..
        //     We want to handle this only on dismissing.
        guard Kitchen._navigationControllerDelegateWillShowCount == 1 else {
            Kitchen._navigationControllerDelegateWillShowCount = 1
            return
        }
        if viewController == Kitchen.navigationController.viewControllers[0] {
            Kitchen.redirectWindow?.makeKeyAndVisible()
            if let redirectWindow = Kitchen.redirectWindow {
                Kitchen.didRedirectToWindow?(redirectWindow)
                Kitchen.didRedirectToWindow = nil
            }
        }
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
     - parameter cookbook: a Cookbook configuration object
     - returns:  If launch process was successfully or not.
    */
    public static func prepare(cookbook: Cookbook) -> Bool {
        sharedKitchen.cookbook = cookbook
        sharedKitchen.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        sharedKitchen.evaluateAppJavaScriptInContext = cookbook.evaluateAppJavaScriptInContext

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

        if let launchOptions = cookbook.launchOptions as? [String: AnyObject] {
            for (kind, value) in launchOptions {
                appControllerContext.launchOptions[kind] = value
            }
        }

        sharedKitchen.appController = TVApplicationController(context: appControllerContext,
            window: sharedKitchen.window, delegate: sharedKitchen)

        /// Must be place this statement after appController is initialized
        sharedKitchen.kitchenErrorHandler = cookbook.onError
        sharedKitchen.actionIDHandler = cookbook.actionIDHandler
        sharedKitchen.playActionIDHandler = cookbook.playActionIDHandler

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
        if let playActionIDHandler = playActionIDHandler {
            let playActionIDHandler: @convention(block) String -> Void = { actionID in
                playActionIDHandler(actionID)
            }
            jsContext.setObject(unsafeBitCast(playActionIDHandler, AnyObject.self),
                forKeyedSubscript: "playActionIDHandler")
        }

        if let actionIDHandler = actionIDHandler {
            let actionIDHandler: @convention(block) String -> Void = { actionID in
                actionIDHandler(actionID)
            }
            jsContext.setObject(unsafeBitCast(actionIDHandler, AnyObject.self),
                forKeyedSubscript: "actionIDHandler")
        }

        // Add loadTemplateFromURL
        let loadTemplateFromURL: @convention(block) (String, String) -> Void =
        { (url, presentationType) -> () in
            self.sendRequest(url) {[unowned self] result in
                switch result {
                case .Success(let xmlString):
                    openTVMLTemplateFromXMLString(
                        xmlString,
                        type: PresentationType(string: presentationType) ?? .Default
                    )
                case .Failure(let error):
                    self.cookbook.onError?(error)
                }
            }
        }
        jsContext.setObject(unsafeBitCast(loadTemplateFromURL, AnyObject.self),
            forKeyedSubscript: "loadTemplateFromURL")

        let filterSearchTextBlock: @convention(block) (String, JSValue) -> () =
        {[unowned self] (text, callback) in
            self.cookbook.searchRecipe?.filterSearchText(text) { string in
                if callback.isObject {
                    callback.callWithArguments([string])
                }
            }
        }
        jsContext.setObject(unsafeBitCast(filterSearchTextBlock, AnyObject.self),
            forKeyedSubscript: "filterSearchText")

        let loadingTemplate: @convention(block) Void -> String =
        {
            return LoadingRecipe().xmlString
        }
        jsContext.setObject(unsafeBitCast(loadingTemplate, AnyObject.self),
            forKeyedSubscript: "loadingTemplate")


        // Add the tab bar handler
        let tabBarHandler: @convention(block) Int -> Void = {
            index in
            self.cookbook.tabChangedHandler?(index)
        }
        jsContext.setObject(unsafeBitCast(tabBarHandler, AnyObject.self),
            forKeyedSubscript: "tabBarHandler")

        self.evaluateAppJavaScriptInContext?(appController, jsContext)
    }
}
