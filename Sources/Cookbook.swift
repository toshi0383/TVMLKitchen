//
//  Cookbook.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/21/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import Foundation

public typealias ResponseObjectHandler = (HTTPURLResponse) -> Bool

open class Cookbook {

    /// launchOptions
    internal var launchOptions: [AnyHashable: Any]?
    /// inject functions or a exceptionHandler into JSContext
    open var evaluateAppJavaScriptInContext: JavaScriptEvaluationHandler?
    /// handles "select" event
    open var actionIDHandler: KitchenActionIDHandler?
    /// handles "play" event
    open var playActionIDHandler: KitchenActionIDHandler?
    /// handles "tabChanged" event
    open var tabChangedHandler: KitchenTabItemHandler?

    /// Subclass object of SearchRecipe.
    /// Required when presenting SearchRecipe somewhere.
    internal var searchRecipe: SearchRecipe? {
        didSet {
            if let recipe = searchRecipe , type(of: recipe) == SearchRecipe.self {
                fatalError("searchRecipe must be subclassed.")
            }
        }
    }

    /// error handler that gets called when any errors occured
    /// in Kitchen(both JS and Swift context)
    open var onError: KitchenErrorHandler?
    open var httpHeaders: [String: String] = [:]
    open var responseObjectHandler: ResponseObjectHandler?

    /// - parameter launchOptions: launchOptions
    public init(launchOptions: [AnyHashable: Any]?) {
        self.launchOptions = launchOptions
    }
}
