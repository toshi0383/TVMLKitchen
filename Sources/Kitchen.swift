//
//  Kitchen.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/28/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

@_exported import TVMLKit

public typealias JavaScriptEvaluationHandler = (TVApplicationController, JSContext) -> Void
public typealias KitchenErrorHandler = (NSError) -> Void
public typealias KitchenActionIDHandler = ((String) -> Void)
public typealias KitchenTabItemHandler = ((Int) -> Void)

let kitchenErrorDomain = "jp.toshi0383.TVMLKitchen.error"

public class Kitchen: NSObject {
    /// singleton instance
    private static let sharedKitchen = Kitchen()

    private var evaluateAppJavaScriptInContext: JavaScriptEvaluationHandler?

    private var kitchenErrorHandler: KitchenErrorHandler? {
        didSet {
            Kitchen.appController.evaluate(inJavaScriptContext: {jsContext in
                let errorHandler: @convention(block) (String) -> Void =
                { [unowned self] (message: String) in
                    let error = NSError(domain: kitchenErrorDomain,
                        code: 1, userInfo: [NSLocalizedDescriptionKey:message])
                    self.kitchenErrorHandler?(error)
                }
                jsContext.setObject(unsafeBitCast(errorHandler, to: AnyObject.self),
                    forKeyedSubscript: "kitchenErrorHandler")
            }, completion: nil)
        }
    }

    private static let defaultErrorHandler: KitchenErrorHandler = { error in
        let alert = UIAlertController(title: "Oops, something's wrong.",
            message: "\(error.localizedDescription)",
            preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        main {
            Kitchen.navigationController.present(alert, animated: true, completion: nil)
        }
    }

    private var window: UIWindow

    private var appController: TVApplicationController!

    private var actionIDHandler: KitchenActionIDHandler?
    private var playActionIDHandler: KitchenActionIDHandler?
    private var cookbook: Cookbook!

    public static var mainBundlePath: String!

    override init() {
        window = UIWindow(frame: UIScreen.main().bounds)
        super.init()
    }

}


// MARK: Public API (serve)
extension Kitchen {

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

    public static func serve(urlString: String, type: PresentationType = .default) {
        Kitchen.appController.evaluate(inJavaScriptContext: {
            context in
            let js = "showLoadingIndicatorForType(\(type.rawValue))"
            context.evaluateScript(js)
        }, completion: nil)
        sharedKitchen.sendRequest(urlString) { result in
            switch result {
            case .success(let xmlString):
                openTVMLTemplateFromXMLString(xmlString, type: type)
            case .failure(let error):
                sharedKitchen.kitchenErrorHandler?(error)
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

    public static func bundle() -> Bundle {
        return Bundle(for: self)
    }
}


// MARK: Network Request

internal enum Result<T, E> {
    case success(T)
    case failure(E)
}

extension Kitchen {
    internal func sendRequest(_ urlString: String, responseHandler: (Result<String, NSError>) -> ()) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            responseHandler(.failure(
                NSError(domain: kitchenErrorDomain, code: 0, userInfo: nil)
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
        let session = URLSession(configuration: URLSessionConfiguration.default())

        let request: URLRequest = req as URLRequest
        let task = session.dataTask(with: request) {
            [unowned self] data, res, error in
            if let error = error {
                responseHandler(.failure(error))
            }

            /// Call user-defined responseObjectHander if no errors.
            if let res = res as? HTTPURLResponse,
                let resume = self.cookbook.responseObjectHandler?(res)
                where resume == false
            {
                return
            }

            if let data = data,
                let xml = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String
            {
                responseHandler(Result.success(xml))
            } else {
                responseHandler(Result.failure(
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
    public static func prepare(_ cookbook: Cookbook) -> Bool {
        sharedKitchen.cookbook = cookbook
        sharedKitchen.window = UIWindow(frame: UIScreen.main().bounds)
        sharedKitchen.evaluateAppJavaScriptInContext = cookbook.evaluateAppJavaScriptInContext

        /// Create the TVApplicationControllerContext
        let appControllerContext = TVApplicationControllerContext()

        let javaScriptURL = Bundle(for: self).urlForResource("kitchen", withExtension: "js")!
        appControllerContext.javaScriptApplicationURL = javaScriptURL
        appControllerContext.launchOptions[UIApplicationLaunchOptionsURLKey] = javaScriptURL

        /// Cutting `kitchen.js` off
        let TVBaseURL = try! javaScriptURL.deletingLastPathComponent()

        /// Define framework bundle URL
        appControllerContext.launchOptions["BASEURL"] = TVBaseURL.absoluteString
        let info = Bundle(for: self).infoDictionary!
        let bundleid = info[String(kCFBundleIdentifierKey)]!
        appControllerContext.launchOptions[UIApplicationLaunchOptionsSourceApplicationKey] = bundleid

        /// Define mainBundle URL
        mainBundlePath = Bundle.main().bundleURL.absoluteString
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
        didFinishLaunching options: [String: AnyObject]?)
    {
    }

    public func appController(_ appController: TVApplicationController,
        didFail error: NSError)
    {
        self.kitchenErrorHandler?(error)
    }

    public func appController(_ appController: TVApplicationController,
        didStop options: [String: AnyObject]?)
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
                forKeyedSubscript: "playActionIDHandler")
        }

        if let actionIDHandler = actionIDHandler {
            let actionIDHandler: @convention(block) (String) -> Void = { actionID in
                actionIDHandler(actionID)
            }
            jsContext.setObject(unsafeBitCast(actionIDHandler, to: AnyObject.self),
                forKeyedSubscript: "actionIDHandler")
        }

        // Add loadTemplateFromURL
        let loadTemplateFromURL: @convention(block) (String, String) -> Void =
        { (url, presentationType) -> () in
            self.sendRequest(url) {[unowned self] result in
                switch result {
                case .success(let xmlString):
                    openTVMLTemplateFromXMLString(
                        xmlString,
                        type: PresentationType(string: presentationType) ?? .default
                    )
                case .failure(let error):
                    self.cookbook.onError?(error)
                }
            }
        }
        jsContext.setObject(unsafeBitCast(loadTemplateFromURL, to: AnyObject.self),
            forKeyedSubscript: "loadTemplateFromURL")

        let filterSearchTextBlock: @convention(block) (String, JSValue) -> () =
        {[unowned self] (text, callback) in
            self.cookbook.searchRecipe?.filterSearchText(text) { string in
                if callback.isObject {
                    callback.call(withArguments: [string])
                }
            }
        }
        jsContext.setObject(unsafeBitCast(filterSearchTextBlock, to: AnyObject.self),
            forKeyedSubscript: "filterSearchText")

        let loadingTemplate: @convention(block) (Void) -> String =
        {
            return LoadingRecipe().xmlString
        }
        jsContext.setObject(unsafeBitCast(loadingTemplate, to: AnyObject.self),
            forKeyedSubscript: "loadingTemplate")


        // Add the tab bar handler
        let tabBarHandler: @convention(block) (Int) -> Void = {
            index in
            self.cookbook.tabChangedHandler?(index)
        }
        jsContext.setObject(unsafeBitCast(tabBarHandler, to: AnyObject.self),
            forKeyedSubscript: "tabBarHandler")

        self.evaluateAppJavaScriptInContext?(appController, jsContext)
    }
}
