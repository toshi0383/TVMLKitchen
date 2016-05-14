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

internal func openTVMLTemplateFromXMLFile(xmlFile: String,
    type: PresentationType = .Default) throws
{
    let mainBundle = NSBundle.mainBundle()
    let path = mainBundle.pathForResource(xmlFile, ofType: nil)!
    let xmlString = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
    let mainBundlePath = mainBundle.bundleURL.absoluteString
    let replaced = xmlString
        .stringByReplacingOccurrencesOfString("((MAIN_BUNDLE_URL))", withString: mainBundlePath)
    openTVMLTemplateFromXMLString(replaced, type: type)
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
