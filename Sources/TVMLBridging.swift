//
//  TVMLBridging.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/11/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

// MARK: - Verify
class VerifyMediator {
    var _error = false
    var __verifyComplete = false
    var error: Bool {
        set(newValue) {
            _mediatorLock.lock()
            defer {_mediatorLock.unlock()}
            _error = newValue
            _verifyComplete = true
        }
        get {
            _mediatorLock.lock()
            defer {_mediatorLock.unlock()}
            return _error
        }
    }
    fileprivate var _verifyComplete: Bool {
        set(newValue) {
            _mediatorLock.lock()
            defer {_mediatorLock.unlock()}
            __verifyComplete = newValue
        }
        get {
            _mediatorLock.lock()
            defer {_mediatorLock.unlock()}
            return __verifyComplete
        }
    }
    func waitForVerifyComplete() {
        while !_verifyComplete {
            if _verifyComplete {
                break
            }
        }
    }
}
var verifyMediator = VerifyMediator()
private let _verifyLock = NSRecursiveLock()
private let _mediatorLock = NSRecursiveLock()

internal func isValidXMLString(_ xmlString: String) -> Bool {
    _verifyLock.lock()
    defer {_verifyLock.unlock()}
    verifyMediator = VerifyMediator()
    let js = "verifyXMLString(`\(xmlString)`);"
    evaluateInTVMLContext(js)
    // - Note: `evaluateInTVMLContext(_:)` escapes from current scrope.
    //     It has completion callback, but we cannot use it here
    //     because it's not marked as rethrows.
    verifyMediator.waitForVerifyComplete()
    return !verifyMediator.error
}

// MARK: - Open TMVL Templates
internal func openTVMLTemplateFromXMLString(_ xmlString: String, type: PresentationType = .default) {
    let js = "openTemplateFromXMLString(`\(xmlString)`, \(type.rawValue));"
    evaluateInTVMLContext(js)
}

internal func xmlStringFromMainBundle(_ xmlFile: String) throws -> String {
    let mainBundle = Bundle.main
    let path = mainBundle.path(forResource: xmlFile, ofType: nil)!
    let xmlString = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
    let mainBundlePath = mainBundle.bundleURL.absoluteString
    let replaced = xmlString
        .replacingOccurrences(of: "((MAIN_BUNDLE_URL))", with: mainBundlePath)
    return replaced
}

internal func openTVMLTemplateFromXMLFile(_ xmlFile: String,
    type: PresentationType = .default) throws
{
    let xmlString = try xmlStringFromMainBundle(xmlFile)
    openTVMLTemplateFromXMLString(xmlString, type: type)
}

// MARK: - Reload Tab
internal func _reloadTab(atIndex index: Int, xmlString: String) {
    let js = "reloadTab(\(index), `\(xmlString)`);"
    evaluateInTVMLContext(js)
}

// MARK: - dismissTVMLModal
internal func dismissTVMLModal() {
    let js = "dismissModal()"
    evaluateInTVMLContext(js)
}

// MARK: - Utilities
private func evaluateInTVMLContext(_ js: String, completion: ((Void)->Void)? = nil) {
    Kitchen.appController.evaluate(inJavaScriptContext: {context in
        context.evaluateScript(js)
    }, completion: {_ in completion?()})
}
