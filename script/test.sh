#!/bin/bash
xcodebuild "-project" "TVMLKitchen.xcodeproj" "-scheme" "TVMLKitchen" "clean" "test" "-destination" "platform=tvOS Simulator,name=Apple TV 1080p,OS=latest" | xcpretty "--color"
xcodebuild "-project" "TVMLKitchen.xcodeproj" "-scheme" "SampleRecipeUITests" "test" "-destination" "platform=tvOS Simulator,name=Apple TV 1080p,OS=latest" | xcpretty "--color"
