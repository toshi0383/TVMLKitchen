#!/bin/bash
set -o pipefail
xcodebuild "-project" "TVMLKitchen.xcodeproj" "-scheme" "TVMLKitchen" "clean" "test" "-destination" "platform=tvOS Simulator,name=Apple TV 1080p,OS=9.1" | xcpretty "--color"
st=$?
if [ $st -ne 0 ];then
	exit $st
fi
#xcodebuild "-project" "TVMLKitchen.xcodeproj" "-scheme" "SampleRecipeUITests" "test" "-destination" "platform=tvOS Simulator,name=Apple TV 1080p,OS=9.1" | xcpretty "--color"
