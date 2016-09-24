## Inject native code into TVML(javascript) context
```
cookbook.evaluateAppJavaScriptInContext = {appController, jsContext in
    /// set Exception handler
    /// called on JS error
    jsContext.exceptionHandler = {context, value in
        debugPrint(context)
        debugPrint(value)
        assertionFailure("You got JS error. Check your javascript code.")
    }

    /// - SeeAlso: http://nshipster.com/javascriptcore/
    /// Inject native code block named 'debug'.
    let consoleLog: @convention(block) String -> Void = { message in
        print(message)
    }
    jsContext.setObject(unsafeBitCast(consoleLog, AnyObject.self),
        forKeyedSubscript: "debug")
}
```

TBD...
