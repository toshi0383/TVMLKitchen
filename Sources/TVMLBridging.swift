//
//  TVMLBridging.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/11/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

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

internal func _reloadTab(atIndex index: Int, xmlString: String) {
    let js = "reloadTab(\(index), `\(xmlString)`);"
    evaluateInTVMLContext(js)
}

internal func dismissTVMLModal() {
    let js = "dismissModal()"
    evaluateInTVMLContext(js)
}

private func evaluateInTVMLContext(js: String, completion: (Void->Void)? = nil) {
    Kitchen.appController.evaluateInJavaScriptContext({context in
        context.evaluateScript(js)
    }, completion: {_ in completion?()})
}
