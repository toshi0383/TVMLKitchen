//
//  Cookbook.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 3/21/16.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import Foundation

public typealias ResponseObjectHandler = NSHTTPURLResponse -> Bool

public class Cookbook {

    /// launchOptions
    internal var launchOptions: [NSObject: AnyObject]?
    /// inject functions or a exceptionHandler into JSContext
    public var evaluateAppJavaScriptInContext: JavaScriptEvaluationHandler?
    /// handles "select" event
    public var actionIDHandler: KitchenActionIDHandler?
    /// handles "play" event
    public var playActionIDHandler: KitchenActionIDHandler?
    /// handles "tabChanged" event
    public var tabChangedHandler: KitchenTabItemHandler?

    /// Subclass object of SearchRecipe.
    /// Required when presenting SearchRecipe somewhere.
    internal var searchRecipe: SearchRecipe? {
        didSet {
            if let recipe = searchRecipe where recipe.dynamicType == SearchRecipe.self {
                fatalError("searchRecipe must be subclassed.")
            }
        }
    }

    /// error handler that gets called when any errors occured
    /// in Kitchen(both JS and Swift context)
    public var onError: KitchenErrorHandler?
    public var httpHeaders: [String: String] = [:]
    public var responseObjectHandler: ResponseObjectHandler?

    /// - parameter launchOptions: launchOptions
    public init(launchOptions: [NSObject: AnyObject]?) {
        self.launchOptions = launchOptions
    }
}
