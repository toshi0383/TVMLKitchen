# TVMLKitchen😋🍴
TVMLKitchen provides Native UI using TVMLKit **without additional client-server**.  
With TVMLKitchen, you can load and show your TVML Templates much easier than you think.  
Views are pushed to the navigationController, so user can pop to previous viewcontroller with 'Menu' button of the **AppleTV Remote**.  
Templates are loaded from your app's Main Bundle.

Without the need of configuring UIKit for complex UI, TVMLKit is a good choice for displaying data in simple UI.  
TVMLKitchen makes the process even much easier, especially when you don't want to deal with the client-server.

# Installation

## Carthage
Put this to your Cartfile,
```
github "toshi0383/TVMLKitchen"
```

follow the instruction in [carthage's Getting Started section](https://github.com/Carthage/Carthage#getting-started).

## CocoaPods
Coming soon...? Contribution or any advice is welcomed and would be appreciated.

# Getting Started

## Showing the Alert Template

First, put your Alert.xml.js to your app's main bundle.

Next, in your AppDelegate's `didFinishLaunchingWithOptions:`, prepare your Kitchen.
```
Kitchen.prepare(launchOptions)
```

Launch your Alert template anywhere and anytime.

```
Kitchen.serve(jsFile:"Alert.xml.js")
```

Kitchen automatically looks for the jsFile in your main bundle, and pushes it to navigationController.

## Advanced setup

- [x] Inject native code into TVML(javascript) context
- [x] Add error handlers

```
Kitchen.prepare(launchOptions, evaluateAppJavaScriptInContext:
{appController, jsContext in
    /// set Exception handler
    /// called on JS error
    jsContext.exceptionHandler = {context, value in
        LOG(context)
        LOG(value)
        assertionFailure("You got JS error. Check your javascript code.")
    }

    /// SeeAlso: http://nshipster.com/javascriptcore/
    /// Inject native code block named 'debug'.
    let consoleLog: @convention(block) String -> Void = { message in
        print(message)
    }
    jsContext.setObject(unsafeBitCast(consoleLog, AnyObject.self),
        forKeyedSubscript: "debug")

}, onLaunchError: { error in
    let title = "Error Launching Application"
    let message = error.localizedDescription
    let alertController = UIAlertController(title: title, message: message, preferredStyle:.Alert )

    Kitchen.navigationController.presentViewController(alertController, animated: true) { }

})
```

## Using Kitchen Recipes for a little bit more dynamizm. (beta)

```
let banner = "Movie"
let thumbnailUrl = NSBundle.mainBundle().URLForResource("img",
    withExtension: "jpg")!.absoluteString
let content = ("Star Wars", thumbnailUrl)
let section1 = Section(title: "Section 1", args: (0...100).map{_ in content})
let catalog = Recipe.Catalog(banner: banner, sections: (0...10).map{_ in section1})
Kitchen.serve(recipe: catalog)
```

**Note**: This feature is still in beta. APIs are subject to change.

## Available Kitchen Recipes

- [x] Catalog
- [ ] Catalog with select action handler
- [ ] Alert with button handler
- [ ] Rating with handler
- [ ] Compilation with select action handler
- [ ] Product with select action handler
- [ ] Product Bundle with select action handler
- [ ] Stack with select action handler
- [ ] Stack Room with select action handler
- [ ] Stack Separator with select action handler

and more...

## Note
TVMLKit cannot detect the scroll event, which means we have no chance to know if a user has scrolled to the end.  
This is why Kitchen cannot load additional data after the template is loaded onto the navigationController.  
We don't know when to inject additional data. Well, even if we could know the timing, I don't know how to reload the collectionView or tableView on the template after it's loaded.  
So for now, if you need 100% dynamic behavior, I suppose you should go ahead and use UIKit.

# References
For implementation details, my slide is available.  
[TVML + Native = Hybrid](https://speakerdeck.com/toshi0383/tvml-plus-native-equals-hybrid)

# Contribution
Any contribution is welcomed🎉

