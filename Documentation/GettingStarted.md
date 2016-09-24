# Getting Started

## Showing a Template from main bundle

1. Put your Sample.xml to your app's main bundle.

2. Prepare your Kitchen in AppDelegate's `didFinishLaunchingWithOptions:`.
    ```
    let cookbook = Cookbook(launchOptions: launchOptions)
    Kitchen.prepare(cookbook)
    ```

3. Launch the template from anywhere.
    ```
    Kitchen.serve(xmlFile: "Sample.xml")
    ```

## Showing a Template from client-server

<ol start="4">
<li><p>Got TVML server ? Just pass the URL String and you're good to go.</p>
    <pre><code>Kitchen.serve(urlString: "https://raw.githubusercontent.com/toshi0383/TVMLKitchen/master/SampleRecipe/Catalog.xml")</code></pre>

</li></ol>

## Open Other TVML from TVML

Set URL to `template` attributes of focusable element. Kitchen will send asynchronous request and present TVML. You can specify preferred `presentationType` too. Note that if `actionID` present, these attributes are ignored.

```
<lockup
    template="https://raw.githubusercontent.com/toshi0383/TVMLKitchen/master/SampleRecipe/Oneup.xml"
    presentationType="Modal"
>
```

## Presentation Styles

There are currently three presentation styles that can be used when serving views: Default, Modal and Tab. The default style acts as a "Push" and will change the current view. Modal will overlay the new view atop the existing view and is commonly used for alerts. Tab is only to be used when defining the first view in a tabcontroller.

````swift
Kitchen.serve(xmlFile: "Sample.xml")
Kitchen.serve(xmlFile: "Sample.xml", type: .Default)
Kitchen.serve(xmlFile: "Sample.xml", type: .Modal)
Kitchen.serve(xmlFile: "Sample.xml", type: .Tab)
````
