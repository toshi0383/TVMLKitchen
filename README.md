# TVMLKitchen😋🍴  [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![CocoaPods](https://img.shields.io/cocoapods/v/TVMLKitchen.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/p/TVMLKitchen.svg)]() [![Build Status](https://www.bitrise.io/app/de994b854e5c425f.svg?token=GZp-KU8RDjmewA2Hdj27fQ)](https://www.bitrise.io/app/de994b854e5c425f)

[TVML](https://developer.apple.com/library/tvos/documentation/LanguagesUtilities/Conceptual/ATV_Template_Guide/) is a good choice, when you prefer simplicity over dynamic UIKit implementation. TVMLKitchen helps to manage your TVML **with or without additional client-server**.  Put TVML templates in Main Bundle, then you're ready to go.

Loading a TVML view is in this short.

```
Kitchen.serve(xmlFile:"Catalog.xml")
```

Kitchen automatically looks for the xmlFile in your Main Bundle, parse it, then finally pushes it to navigationController.

# Requirements
- Swift2.2
- tvOS 9.0+

# Available Features
- [x] Load TVML from URL.
- [x] Load TVML from raw XML String.
- [x] XML syntax validation API
- [x] TVML *Recipe* Support
- [x] Multi UIWindow Support *Beta*

# Examples
- TVJS Base Hybrid App  (Demo: SampleRecipe)
- UIKit Base Hybrid App (Demo: NativeBaseSample)

# Installation

## Carthage
Put this to your Cartfile,
```
github "toshi0383/TVMLKitchen"
```

Follow the instruction in [carthage's Getting Started section](https://github.com/Carthage/Carthage#getting-started).

## Cocoapods
Add the following to your Podfile
```
pod 'TVMLKitchen'
```

# References
For implementation details, my slide is available.  
[TVML + Native = Hybrid](https://speakerdeck.com/toshi0383/tvml-plus-native-equals-hybrid)

# Contribution
Any contribution is welcomed🎉
