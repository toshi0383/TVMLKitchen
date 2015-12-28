//
//  TVMLBridging.swift
//  dTV
//
//  Created by toshi0383 on 12/11/15.
//  Copyright © 2015 toshi0383. All rights reserved.
//

import UIKit

/// Javascript file names enum
/// Each case corresponds to actual filename prefix
/// e.g. ${prefix}.xml.js
public protocol JSNameConvertible: CustomStringConvertible {
    var description: String { get }
}

public func openTVMLTemplateFromXMLFile(xmlFileName: String) {
    let js = "openTemplateFromXMLFile('\(xmlFileName)');"
    evaluateInTVMLContext(js)
}

public func openTVMLTemplateFromRawXMLString(xmlString: String) {
    let js = "openTemplateFromRawXMLString(`\(xmlString)`);"
    LOG()
    evaluateInTVMLContext(js)
}

public func openTVMLTemplateFromJSFile(jsfile: String) {
    let js = "openTemplateFromJSFile('\(jsfile)');"
    evaluateInTVMLContext(js)
}

private func evaluateInTVMLContext(js: String, completion: dispatch_block_t? = nil) {
    Kitchen.appController.evaluateInJavaScriptContext({context in
        context.evaluateScript(js)
    }, completion: {_ in completion?()})
}
