## 0.9.1
##### New Feature
* Multiple UIWindow Support for Kitchen.serve(urlString:)  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#100](https://github.com/toshi0383/TVMLKitchen/pull/100)

## 0.9.0
##### New Feature
* Multiple UIWindow Support  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#98](https://github.com/toshi0383/TVMLKitchen/pull/98)

## 0.8.1
##### Bugfix
* Reloaded documents now respond with actions.  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#93](https://github.com/toshi0383/TVMLKitchen/pull/93)

## 0.8.0
##### New Feature
* Tab Reloading  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#90](https://github.com/toshi0383/TVMLKitchen/pull/90)

##### Breaking
* Remove deprecated APIs  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#91](https://github.com/toshi0383/TVMLKitchen/pull/91)

## 0.7.2
##### New Feature
* Make LoadingRecipe public  
  [Lukas Kuster](https://github.com/lukaskuster)
  [#88](https://github.com/toshi0383/TVMLKitchen/pull/88)

## 0.7.1
##### New Feature
* Replace ((MAIN_BUNDLE_URL)) with main bundle path on Kitchen.serve(xmlFile:)  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#83](https://github.com/toshi0383/TVMLKitchen/pull/83)

## 0.7.0
##### Breaking
* Add PresentationTypes with Loading Indicators  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#67](https://github.com/toshi0383/TVMLKitchen/issues/67)
  [#76](https://github.com/toshi0383/TVMLKitchen/issues/76)  
  Note: Loading indicator will not be shown unless presentationType is set to `DefaultWithLoadingIndicator`.

##### Enhancements
* Presenting the tabBar from an Action  
  [Anthony](https://github.com/anthonycastelli)
  [#68](https://github.com/toshi0383/TVMLKitchen/pull/68)

* Handle TabItem's handler() when presented via serve(recipe:) method.  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#72](https://github.com/toshi0383/TVMLKitchen/issues/72)

## 0.6.2
##### Enhancements
* Add support for Swift 2.2  
  [Anthony](https://github.com/anthonycastelli)
  [#64](https://github.com/toshi0383/TVMLKitchen/pull/64)

## 0.6.1
##### Bugfix
* Fix CocoaPods Podspec  
  [Stephen Radford](https://github.com/steve228uk)
  [#63](https://github.com/toshi0383/TVMLKitchen/pull/63)

## 0.6.0: Sommelier
##### New Feature
* SearchRecipe  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#56](https://github.com/toshi0383/TVMLKitchen/issues/56)

## 0.5.0: HTTP Kitchen
##### Breaking
* Remove Kitchen.serve(jsFile:) API  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#46](https://github.com/toshi0383/TVMLKitchen/issues/46)

##### New Feature
* Custom HTTP Header  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#44](https://github.com/toshi0383/TVMLKitchen/pull/44)

##### Enhancements
* Cookbook Configuration Object  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#42](https://github.com/toshi0383/TVMLKitchen/pull/42)

##### Bugfix
* Dismiss modal before new presentation  
  [Stephen Radford](https://github.com/steve228uk)
  [#43](https://github.com/toshi0383/TVMLKitchen/pull/43)

* Fix AlertRecipe  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#52](https://github.com/toshi0383/TVMLKitchen/pull/52)

## 0.4.1: Easter Egg
##### Enhancements
* @exported import TVMLKit  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#39](https://github.com/toshi0383/TVMLKitchen/pull/39)

## 0.4.0: Chef Stephen Radford
##### New Feature

* Add Tab Bar Support  
  [Stephen Radford](https://github.com/steve228uk)
  [#31](https://github.com/toshi0383/TVMLKitchen/pull/31)

* Add Modal Support  
  [Stephen Radford](https://github.com/steve228uk)
  [#26](https://github.com/toshi0383/TVMLKitchen/pull/26)

* Add Alert Recipes  
  [Stephen Radford](https://github.com/steve228uk)
  [#31](https://github.com/toshi0383/TVMLKitchen/pull/31)

##### Enhancements

* Add Cocoapods Podspec  
  [Stephen Radford](https://github.com/steve228uk)
  [#29](https://github.com/toshi0383/TVMLKitchen/pull/29)

## 0.3.0: Player
##### New Feature
* Introduce playActionIDHandler  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#23](https://github.com/toshi0383/TVMLKitchen/issues/23)

##### Enhancements
* Remove debug function injection  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#3](https://github.com/toshi0383/TVMLKitchen/issues/3)

## 0.2.2: Zuppa di SwiftLint
##### Bugfix
* Fix unwanted SwiftLint Error on `carthage update`  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#16](https://github.com/toshi0383/TVMLKitchen/pull/16)

## 0.2.1: SwiftLint Burger
##### Bugfix
* Fix SwiftLint Error on `carthage update`  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#12](https://github.com/toshi0383/TVMLKitchen/issues/12)

## 0.2.0: URL Kitchen
##### Enhancements
* Open template from URL String  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#8](https://github.com/toshi0383/TVMLKitchen/pull/8)

##### Bugfix
* actionID had been overwritten everytime `Kitchen.serve()` with actionIDHandler.  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#9](https://github.com/toshi0383/TVMLKitchen/issues/9)

## 0.1.2: Hot chili pepper
##### Breaking Change
* Improve error handling  
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [#4](https://github.com/toshi0383/TVMLKitchen/issues/4)

##### Bug Fixes
* Fixed kitchen.js runtime error  
  [Toshihiro Suzuki](https://github.com/toshi0383)

## 0.1.1: Recipe
* DefaultTheme and BlackTheme
* Customizable Recipe Theme Interface  
  [Toshihiro Suzuki](https://github.com/toshi0383)

## 0.1.0: Bonapetit
First Version
