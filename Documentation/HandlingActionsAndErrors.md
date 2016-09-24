# Handling Action and Errors

## Add error handlers
```
cookbook.onError = { error in
    let title = "Error Launching Application"
    let message = error.localizedDescription
    let alertController = UIAlertController(title: title, message: message, preferredStyle:.Alert )

    Kitchen.navigationController.presentViewController(alertController, animated: true) { }
}
```

## Handling Actions
You can set `actionID` and `playActionID` attributes in your focusable elements. (e.g. `lockup` or `button` SeeAlso: https://forums.developer.apple.com/thread/17704 ) Kitchen receives Select or Play events, then fires `actionIDHandler` or `playActionHandler` if exists.

```
<lockup actionID="showDescription" playActionID="playContent">
```

```
cookbook.actionIDHandler = { actionID in
    print(actionID)
}
cookbook.playActionIDHandler = {actionID in
    print(actionID)
}
```

