//
//  Kitchen.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

@_exported import TVMLKit

public enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

public typealias JavaScriptEvaluationHandler = (TVApplicationController, JSContext) -> Void
public typealias KitchenErrorHandler = (Error) -> Void
public typealias KitchenActionIDHandler = ((String) -> Void)
public typealias KitchenTabItemHandler = ((Int) -> Void)

let kitchenErrorDomain = "jp.toshi0383.TVMLKitchen.error"

open class Kitchen: NSObject {
    /// singleton instance
    fileprivate static let sharedKitchen = Kitchen()
    fileprivate static weak var redirectWindow: UIWindow?
    fileprivate static var animatedWindowTransition: Bool = false
    fileprivate static var _navigationControllerDelegateWillShowCount = 0
    fileprivate static var willRedirectToWindow: (() -> ())?

    fileprivate var evaluateAppJavaScriptInContext: JavaScriptEvaluationHandler?

    fileprivate var kitchenErrorHandler: KitchenErrorHandler?

    fileprivate static let defaultErrorHandler: KitchenErrorHandler = { error in
        let alert = UIAlertController(title: "Oops, something's wrong.",
            message: "\(error.localizedDescription)",
            preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        DispatchQueue.main.async {
            Kitchen.navigationController.present(alert, animated: true, completion: nil)
        }
    }

    fileprivate var window: UIWindow

    fileprivate var appController: TVApplicationController!

    fileprivate var actionIDHandler: KitchenActionIDHandler?
    fileprivate var playActionIDHandler: KitchenActionIDHandler?
    fileprivate var cookbook: Cookbook!

    open static var mainBundlePath: String!

    override init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        super.init()
    }

}


// MARK: - Public API
public enum KitchenError: Error {
    case tvmlDecodeError, tvmlurlNetworkError(Error?)
    case invalidTVMLURL
}

extension Kitchen {

    fileprivate static var _rootViewController: UIViewController = {
        let vc = UIViewController()
        vc.view.alpha = 0.0
        return vc
    }()

    // MARK: verify

    /// Verify xmlString syntax.
    /// This function actually calls `DOMParser#parseFromString` to verify syntax.
    /// - parameter xmlString:
    /// - throws: KitchenError.TVMLDecodeError
    public static func verify(_ xmlString: String) throws {
        if !isValidXMLString(xmlString) {
            throw KitchenError.tvmlDecodeError
        }
    }

    // MARK: serve
    public static func serve(xmlString: String, type: PresentationType = .default) {
        openTVMLTemplateFromXMLString(xmlString, type: type)
    }

    public static func serve(xmlFile: String, type: PresentationType = .default) {
        do {
            try openTVMLTemplateFromXMLFile(xmlFile, type: type)
        } catch let error as NSError {
            sharedKitchen.kitchenErrorHandler?(error)
        }
    }

    static func _kitchenWindowWillBecomeVisible(_ redirectWindow: UIWindow) {
        window.alpha = 0.0
        UIView.animate(
            withDuration: 0.3,
            animations: {
                window.alpha = 1.0
            },
            completion: {
                _ in
                redirectWindow.alpha = 0.0
            }
        )
    }

    static func _willRedirectToWindow(_ redirectWindow: UIWindow) {
        redirectWindow.alpha = 0.0
        UIView.animate(
            withDuration: 0.3,
            animations: {
                redirectWindow.alpha = 1.0
            },
            completion: {
                _ in
                window.alpha = 0.0
            }
        )
    }

    /// Serve TVML with xmlString
    /// Calls `redirectWindow.makeKeyAndVisible()` when the TVML is dismissing.
    /// - parameter urlString:
    /// - parameter type:
    /// - parameter redirectWindow: UIWindow.
    ///     Expected to be the parent window of Native Views(not Kitchen.window)
    /// - parameter animatedWindowTransition: If true, ignores Redirect callbacks.
    /// - parameter kitchenWindowWillBecomeVisible: Redirect Callback
    /// - parameter willRedirectToWindow: Redirect Callback
    public static func serve(xmlString: String,
       type: PresentationType = .default, redirectWindow: UIWindow,
       animatedWindowTransition: Bool = false,
       kitchenWindowWillBecomeVisible: (() -> ())? = nil,
       willRedirectToWindow: (() -> ())? = nil)
    {
        Kitchen._navigationControllerDelegateWillShowCount = 0
        let vc = _rootViewController
        Kitchen.navigationController.setViewControllers([vc], animated: true)
        Kitchen.navigationController.delegate = sharedKitchen
        Kitchen.willRedirectToWindow = willRedirectToWindow
        Kitchen.redirectWindow = redirectWindow
        Kitchen.animatedWindowTransition = animatedWindowTransition
        if animatedWindowTransition {
            _kitchenWindowWillBecomeVisible(redirectWindow)
        } else {
            kitchenWindowWillBecomeVisible?()
        }
        Kitchen.serve(xmlString: xmlString, type: type)
        Kitchen.window.makeKeyAndVisible()
    }

    /// Serve TVML with urlString
    /// Calls `redirectWindow.makeKeyAndVisible()` when the TVML is dismissing.
    ///
    /// Redirects to redirectWindow on error by default.
    /// You can overwrite that behavior by setting resultHandler parameter.
    ///
    /// - parameter urlString:
    /// - parameter type:
    /// - parameter redirectWindow: UIWindow.
    ///     Expected to be the parent window of Native Views(not Kitchen.window)
    /// - parameter animatedWindowTransition: If true, ignores Redirect callbacks.
    /// - parameter kitchenWindowWillBecomeVisible: Redirect Callback
    /// - parameter willRedirectToWindow: Redirect Callback
    /// - parameter resultHandler: Result Handler
    public static func serve(urlString: String,
       type: PresentationType = .default, redirectWindow: UIWindow,
       animatedWindowTransition: Bool = false,
       kitchenWindowWillBecomeVisible: (() -> ())? = nil,
       willRedirectToWindow: (() -> ())? = nil,
       resultHandler: ((Result<String, KitchenError>) -> String?)? = nil)
    {
        Kitchen._navigationControllerDelegateWillShowCount = 0
        let vc = _rootViewController
        Kitchen.navigationController.setViewControllers([vc], animated: true)
        Kitchen.navigationController.delegate = sharedKitchen
        Kitchen.willRedirectToWindow = willRedirectToWindow
        Kitchen.redirectWindow = redirectWindow
        Kitchen.animatedWindowTransition = animatedWindowTransition


        func transitionToKitchen() {
            DispatchQueue.main.async {
                if animatedWindowTransition {
                    _kitchenWindowWillBecomeVisible(redirectWindow)
                } else {
                    kitchenWindowWillBecomeVisible?()
                }
                Kitchen.window.makeKeyAndVisible()
            }
        }
        func redirectBack() {
            DispatchQueue.main.async {
                redirectWindow.makeKeyAndVisible()
            }
        }
        if let resultHandler = resultHandler {
            Kitchen.serve(urlString: urlString, type: type, resultHandler: resultHandler)
        } else {
            Kitchen.serve(urlString: urlString, type: type) {
                result in
                switch result {
                case .success(let xmlString):
                    do {
                        try Kitchen.verify(xmlString)
                        transitionToKitchen()
                        return xmlString
                    } catch {
                        redirectBack()
                        return nil
                    }
                case .failure:
                    redirectBack()
                    return nil
                }
            }
        }
    }

    public static func serve
        (urlString: String, type: PresentationType = .default,
         resultHandler: ((Result<String, KitchenError>) -> String?)? = nil) {
        Kitchen.appController.evaluate(inJavaScriptContext: {
            context in
            let js = "showLoadingIndicatorForType(\(type.rawValue))"
            context.evaluateScript(js)
        }, completion: nil)
        sharedKitchen.sendRequest(urlString) {
            result in
            if let resultHandler = resultHandler {
                if let xmlString = resultHandler(result) {
                    openTVMLTemplateFromXMLString(xmlString, type: type)
                }
            } else {
                switch result {
                case .success(let xmlString):
                    openTVMLTemplateFromXMLString(xmlString, type: type)
                case .failure(let error):
                    if case KitchenError.tvmlurlNetworkError(let e) = error {
                        if let e = e {
                            sharedKitchen.kitchenErrorHandler?(e)
                        }
                    }
                }
            }
        }
    }

    public static func serve<R: RecipeType>(recipe: R) {
        if let recipe = recipe as? SearchRecipe {
            sharedKitchen.cookbook.searchRecipe = recipe
        }
        if let recipe = recipe as? KitchenTabBar {
            sharedKitchen.cookbook.tabChangedHandler = recipe.tabChanged
        }
        openTVMLTemplateFromXMLString(recipe.xmlString, type: recipe.presentationType)
    }

    // MARK: reloadTab
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
            case .success(let xmlString):
                _reloadTab(atIndex: index, xmlString: xmlString)
            case .failure(let error):
                if case KitchenError.tvmlurlNetworkError(let e) = error {
                    if let e = e {
                        sharedKitchen.kitchenErrorHandler?(e)
                    }
                }
            }
        }
    }

    public static func reloadTab(atIndex index: Int, xmlString: String) {
        _reloadTab(atIndex: index, xmlString: xmlString)
    }

    // MARK: dismissModal
    public static func dismissModal() {
        dismissTVMLModal()
    }

    // MARK: bundle
    public static func bundle() -> Bundle {
        return Bundle(for: self)
    }
}


// MARK: Network Request

extension Kitchen {
    internal func sendRequest(_ urlString: String, responseHandler: @escaping (Result<String, KitchenError>) -> ()) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            responseHandler(.failure(
                KitchenError.invalidTVMLURL
            ))
            return
        }

        /// Create Request
        let req = NSMutableURLRequest(url: url)

        /// Custom Headers
        for (k, v) in cookbook.httpHeaders {
            req.setValue(v, forHTTPHeaderField: k)
        }

        /// Session Handler
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: req as URLRequest, completionHandler: {
            [unowned self] data, res, error in
            if let error = error {
                responseHandler(.failure(KitchenError.tvmlurlNetworkError(error)))
            }

            /// Call user-defined responseObjectHander if no errors.
            if let res = res as? HTTPURLResponse,
                let resume = self.cookbook.responseObjectHandler?(res)
                , resume == false
            {
                return
            }

            if let data = data,
                let xml = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String
            {
                responseHandler(Result.success(xml))
            } else {
                responseHandler(Result.failure(
                    KitchenError.tvmlurlNetworkError(nil)
                ))
            }
        }) 
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
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController, animated: Bool)
    {
        // Workaround: This delegate is called on presenting, too..
        //     We want to handle this only on dismissing.
        guard Kitchen._navigationControllerDelegateWillShowCount == 1 else {
            Kitchen._navigationControllerDelegateWillShowCount = 1
            return
        }
        if Kitchen.navigationController.viewControllers.count == 0 ||
            viewController == Kitchen.navigationController.viewControllers[0] {
            if let redirectWindow = Kitchen.redirectWindow {
                if Kitchen.animatedWindowTransition {
                    Kitchen._willRedirectToWindow(redirectWindow)
                } else {
                    Kitchen.willRedirectToWindow?()
                }
                Kitchen.willRedirectToWindow = nil
                redirectWindow.makeKeyAndVisible()
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
    @discardableResult
    public static func prepare(_ cookbook: Cookbook) -> Bool {
        sharedKitchen.cookbook = cookbook
        sharedKitchen.window = UIWindow(frame: UIScreen.main.bounds)
        sharedKitchen.evaluateAppJavaScriptInContext = cookbook.evaluateAppJavaScriptInContext

        /// Create the TVApplicationControllerContext
        let appControllerContext = TVApplicationControllerContext()

        let javaScriptURL = Bundle(for: self).url(forResource: "kitchen", withExtension: "js")!
        appControllerContext.javaScriptApplicationURL = javaScriptURL
        appControllerContext.launchOptions[UIApplicationLaunchOptionsKey.url.rawValue] = javaScriptURL

        /// Cutting `kitchen.js` off
        let TVBaseURL = javaScriptURL.deletingLastPathComponent()

        /// Define framework bundle URL
        appControllerContext.launchOptions["BASEURL"] = TVBaseURL.absoluteString
        let info = Bundle(for: self).infoDictionary!
        let bundleid = info[kCFBundleIdentifierKey as String]!
        appControllerContext.launchOptions[UIApplicationLaunchOptionsKey.sourceApplication.rawValue] = bundleid

        /// Define mainBundle URL
        mainBundlePath = Bundle.main.bundleURL.absoluteString
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

    public func appController(_ appController: TVApplicationController,
        didFinishLaunching options: [String: Any]?)
    {
    }

    public func appController(_ appController: TVApplicationController,
        didFail error: Error)
    {
        self.kitchenErrorHandler?(error as NSError)
    }

    public func appController(_ appController: TVApplicationController,
        didStop options: [String: Any]?)
    {
    }

    public func appController(_ appController: TVApplicationController,
        evaluateAppJavaScriptIn jsContext: JSContext)
    {
        if let playActionIDHandler = playActionIDHandler {
            let playActionIDHandler: @convention(block) (String) -> Void = { actionID in
                playActionIDHandler(actionID)
            }
            jsContext.setObject(unsafeBitCast(playActionIDHandler, to: AnyObject.self),
                forKeyedSubscript: "playActionIDHandler" as (NSCopying & NSObjectProtocol)!)
        }

        if let actionIDHandler = actionIDHandler {
            let actionIDHandler: @convention(block) (String) -> Void = { actionID in
                actionIDHandler(actionID)
            }
            jsContext.setObject(unsafeBitCast(actionIDHandler, to: AnyObject.self),
                forKeyedSubscript: "actionIDHandler" as (NSCopying & NSObjectProtocol)!)
        }

        // Add loadTemplateFromURL
        let loadTemplateFromURL: @convention(block) (String, String) -> Void =
        { (url, presentationType) -> () in
            self.sendRequest(url) {[unowned self] result in
                switch result {
                case .success(let xmlString):
                    openTVMLTemplateFromXMLString(
                        xmlString,
                        type: PresentationType(string: presentationType) 
                    )
                case .failure(let error):
                    if case KitchenError.tvmlurlNetworkError(let e) = error {
                        if let e = e {
                            self.cookbook.onError?(e)
                        }
                    }
                }
            }
        }
        jsContext.setObject(unsafeBitCast(loadTemplateFromURL, to: AnyObject.self),
            forKeyedSubscript: "loadTemplateFromURL" as (NSCopying & NSObjectProtocol)!)

        let filterSearchTextBlock: @convention(block) (String, JSValue) -> () =
        {[unowned self] (text, callback) in
            self.cookbook.searchRecipe?.filterSearchText(text) { string in
                if callback.isObject {
                    callback.call(withArguments: [string])
                }
            }
        }
        jsContext.setObject(unsafeBitCast(filterSearchTextBlock, to: AnyObject.self),
            forKeyedSubscript: "filterSearchText" as (NSCopying & NSObjectProtocol)!)

        let loadingTemplate: @convention(block) (Void) -> String =
        {
            return LoadingRecipe().xmlString
        }
        jsContext.setObject(unsafeBitCast(loadingTemplate, to: AnyObject.self),
            forKeyedSubscript: "loadingTemplate" as (NSCopying & NSObjectProtocol)!)


        // Add the tab bar handler
        let tabBarHandler: @convention(block) (Int) -> Void = {
            index in
            self.cookbook.tabChangedHandler?(index)
        }
        jsContext.setObject(unsafeBitCast(tabBarHandler, to: AnyObject.self),
            forKeyedSubscript: "tabBarHandler" as (NSCopying & NSObjectProtocol)!)

        // Verify Error
        let verifyXMLStringComplete: @convention(block) (Bool) -> () = {
            success in
            verifyMediator.error = !success
        }
        jsContext.setObject(unsafeBitCast(verifyXMLStringComplete, to: AnyObject.self),
            forKeyedSubscript: "verifyXMLStringComplete" as (NSCopying & NSObjectProtocol)!)

        // Done
        self.evaluateAppJavaScriptInContext?(appController, jsContext)
    }
}
