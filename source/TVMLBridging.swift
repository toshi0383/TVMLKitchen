//
//  TVMLBridging.swift
//  dTV
//
//  Created by toshi0383 on 12/11/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

import UIKit

internal func openTVMLTemplateFromXMLFile(xmlFileName: String) {
    let js = "openTemplateFromXMLFile('\(xmlFileName)');"
    evaluateInTVMLContext(js)
}

internal func openTVMLTemplateFromRawXMLString(xmlString: String) {
    let js = "openTemplateFromRawXMLString(`\(xmlString)`);"
    evaluateInTVMLContext(js)
}

internal func openTVMLTemplateFromJSFile(jsfile: String) {
    let js = "openTemplateFromJSFile('\(jsfile)');"
    evaluateInTVMLContext(js)
}

private func evaluateInTVMLContext(js: String, completion: (Void->Void)? = nil) {
    Kitchen.appController.evaluateInJavaScriptContext({context in
        context.evaluateScript(js)
    }, completion: {_ in completion?()})
}
