//
//  TVMLBridging.swift
//  TVMLKitchen
//
//  Created by toshi0383 on 12/11/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

internal func openTVMLTemplateFromXMLString(_ xmlString: String, type: PresentationType = .default) {
    let js = "openTemplateFromXMLString(`\(xmlString)`, \(type.rawValue));"
    evaluateInTVMLContext(js)
}

internal func xmlStringFromMainBundle(_ xmlFile: String) throws -> String {
    let mainBundle = Bundle.main()
    let path = mainBundle.pathForResource(xmlFile, ofType: nil)!
    let xmlString = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
    let mainBundlePath = mainBundle.bundleURL.absoluteString
    let replaced = xmlString
        .replacingOccurrences(of: "((MAIN_BUNDLE_URL))", with: mainBundlePath!)
    return replaced
}

internal func openTVMLTemplateFromXMLFile(_ xmlFile: String,
    type: PresentationType = .default) throws
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

private func evaluateInTVMLContext(_ js: String, completion: ((Void)->Void)? = nil) {
    Kitchen.appController.evaluate(inJavaScriptContext: {context in
        context.evaluateScript(js)
    }, completion: {_ in completion?()})
}
