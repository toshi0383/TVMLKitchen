# TVMLKitchen😋🍴  [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![CocoaPods](https://img.shields.io/cocoapods/v/TVMLKitchen.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/p/TVMLKitchen.svg)]() [![Build Status](https://www.bitrise.io/app/de994b854e5c425f.svg?token=GZp-KU8RDjmewA2Hdj27fQ)](https://www.bitrise.io/app/de994b854e5c425f)

TVMLKitchen helps to manage your TVML **with or without additional client-server**.

# Requirements
- Swift3.0
- tvOS 9.0+

Use 0.9.6 for Swift2.2.  
Swift2.3 is not supported. Feel free to send PR.

# What's TVML?
Please refer to [Apple's Documentation](https://developer.apple.com/library/tvos/documentation/LanguagesUtilities/Conceptual/ATV_Template_Guide/).
It's a markup language which can be used only on tvOS.
TVML makes it easy to build awesome apps for tvOS.

# Why ?

TVML is easy, but TVJS is not really.
With TVMLKitchen, loading a TVML view is in this short.

```
Kitchen.serve(xmlFile: "Catalog.xml")
```

You don't have to write any JavaScript code at all!

Kitchen automatically looks for the xmlFile in your Main Bundle, parse it, then finally pushes it to navigationController.
Please refer to the [Documentation](./Documentation) for more information.

# Available Features
- [x] Load TVML from URL.
- [x] Load TVML from raw XML String.
- [x] XML syntax validation API
- [x] TVML *Recipe* Support
- [x] Multi UIWindow Support *Beta*

# Examples
- TVJS Base Hybrid App  (Demo: [SampleRecipe](./SampleRecipe))
- UIKit Base Hybrid App (Demo: [NativeBaseSample](./NativeBaseSample))

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
