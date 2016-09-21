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
    private var _verifyComplete: Bool {
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

internal func verifyXMLString(xmlString: String, @noescape onError:() throws -> ()) rethrows {
    _verifyLock.lock()
    defer {_verifyLock.unlock()}
    verifyMediator = VerifyMediator()
    let js = "verifyXMLString(`\(xmlString)`);"
    evaluateInTVMLContext(js)
    // - Note: `evaluateInTVMLContext(_:)` escapes from current scrope.
    //     It has completion callback, but we cannot use it here
    //     because it's not marked as rethrows.
    verifyMediator.waitForVerifyComplete()
    if verifyMediator.error {
        try onError()
    }
}

// MARK: - Open TMVL Templates
internal func openTVMLTemplateFromXMLString(xmlString: String, type: PresentationType = .Default) {
    let js = "openTemplateFromXMLString(`\(xmlString)`, \(type.rawValue));"
    evaluateInTVMLContext(js)
}

internal func xmlStringFromMainBundle(xmlFile: String) throws -> String {
    let mainBundle = NSBundle.mainBundle()
    let path = mainBundle.pathForResource(xmlFile, ofType: nil)!
    let xmlString = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
    let mainBundlePath = mainBundle.bundleURL.absoluteString
    let replaced = xmlString
        .stringByReplacingOccurrencesOfString("((MAIN_BUNDLE_URL))", withString: mainBundlePath)
    return replaced
}

internal func openTVMLTemplateFromXMLFile(xmlFile: String,
    type: PresentationType = .Default) throws
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
private func evaluateInTVMLContext(js: String, completion: (Void->Void)? = nil) {
    Kitchen.appController.evaluateInJavaScriptContext({context in
        context.evaluateScript(js)
    }, completion: {_ in completion?()})
}
