# TVMLKitchen😋🍴  [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Build Status](https://www.bitrise.io/app/de994b854e5c425f.svg?token=GZp-KU8RDjmewA2Hdj27fQ)](https://www.bitrise.io/app/de994b854e5c425f)

[TVML](https://developer.apple.com/library/tvos/documentation/LanguagesUtilities/Conceptual/ATV_Template_Guide/) is a good choice, when you prefer simplicity over dynamic UIKit implementation. TVMLKitchen helps to manage your TVML **without additional client-server**.  You put the TVML templates to your Main Bundle, then you're ready to go.

Loading a TVML view is in this short.

```
Kitchen.serve(jsFile:"Catalog.xml.js")
```

The view is pushed to the navigationController. User can pop to previous viewcontroller with AppleTV(Remote)'s **'Menu' button**.

# Getting Started

## Showing the Alert Template

First, put your Alert.xml.js to your app's main bundle.

Next, prepare your Kitchen in AppDelegate's `didFinishLaunchingWithOptions:`.
```
Kitchen.prepare(launchOptions)
```

Launch the template from anywhere and anytime.

```
Kitchen.serve(jsFile:"Alert.xml.js")
```

Kitchen automatically looks for the jsFile in your Main Bundle, and pushes it to navigationController.

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

## Kitchen Recipes
Though TVML view cannot be modified programatically after presented(or is there a way?), we can at least generate TVML dynamically by defining **Recipe** for it.

```
let banner = "Movie"
let thumbnailUrl = NSBundle.mainBundle().URLForResource("img",
    withExtension: "jpg")!.absoluteString
let actionID = "/title?titleId=1234"
let content = ("Star Wars", thumbnailUrl, actionID)
let section1 = Section(title: "Section 1", args: (0...100).map{_ in content})
let catalog = Recipe.Catalog(banner: banner, sections: (0...10).map{_ in section1})
Kitchen.serve(recipe: catalog, actionIDHandler: {[unowned self] actionID in
    let identifier = actionID // Parse your action ID appropriately
    dispatch_async(dispatch_get_main_queue()) {
        self.openViewController(identifier)
    }
})
```

![Catalog Recipe looks like this](image/ss.png)

**Note**: This feature is still in beta. APIs are subject to change.

### Available Recipes

- [x] Catalog
- [x] Catalog with select action handler
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
We don't know when or how to inject additional data onto already presented TVML view.
For now, if you need 100% dynamic behavior, go ahead and use UIKit.

# Installation

## Carthage
Put this to your Cartfile,
```
github "toshi0383/TVMLKitchen"
```

Follow the instruction in [carthage's Getting Started section](https://github.com/Carthage/Carthage#getting-started).

# References
For implementation details, my slide is available.  
[TVML + Native = Hybrid](https://speakerdeck.com/toshi0383/tvml-plus-native-equals-hybrid)

# Contribution
Any contribution is welcomed🎉

