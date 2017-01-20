# Kitchen Recipes
Though TVML is static xmls, we can generate TVML dynamically by defining **Recipe**.

## Available Recipes

- [x] Alert with button handler
- [x] Descriptive Alert with button handler
- [x] Search
- [x] TabBar
- [x] ~~Catalog~~ => Deprecated
- [x] ~~Catalog with select action handler~~ => Deprecated

You can create your own Recipe by conforming to `RecipeType` protocol.

## AlertRecipe
```
let alert = AlertRecipe(
    title: Sample.title,
    description: Sample.description)
)
Kitchen.serve(recipe: alert)
```

## Tab Controller

Should you wish to use tabs within your application you can use `KitchenTabBar` recipe. First, create a `TabItem` struct with a title and a `handler` method. The `handler` method will be called every time the tab becomes active.

**Note:** The `PresentationType` for initial view should always be set to `.Tab`.

````swift
struct MoviesTab: TabItem {

    let title = "Movies"

    func handler() {
        Kitchen.serve(xmlFile: "Sample.xml", type: .Tab)
    }

}
````

Present tabbar using `serve(recipe:)` method.

````swift
let tabbar = KitchenTabBar(items:[
    MoviesTab(),
    MusicsTab()
])
Kitchen.serve(recipe: tabbar)
````

Reload tab using `reloadTab(atIndex:_:)` method.

```swift
// reload with xmlFile
Kitchen.reloadTab(atIndex: 0, xmlFile: "Oneup.xml")

// reload with xmlString
Kitchen.reloadTab(atIndex: 0, urlString: Sample.tvmlUrl)

// reload with Recipe
let search = MySearchRecipe()
Kitchen.reloadTab(atIndex: 0, recipe: search)
```

## SearchRecipe
SearchRecipe supports dynamic view manipulation.

#### Configuring SearchRecipe
Subclass `SearchRecipe` and override `filterSearchText` method.
SeeAlso: [SampleRecipe/MySearchRecipe.swift](https://github.com/toshi0383/TVMLKitchen/blob/master/SampleRecipe/MySearchRecipe.swift), [SearchResult.xml](https://github.com/toshi0383/TVMLKitchen/blob/master/Sources/Templates/SearchResult.xml)

#### SearchRecipe as TabItem
Use `PresentationType.TabSearch`. This will create keyboard observer in addition to `.Tab` behavior.
```
struct SearchTab: TabItem {
    let title = "Search"
    func handler() {
        let search = MySearchRecipe(type: .TabSearch)
        Kitchen.serve(recipe: search)
    }
}
```

