#!/bin/sh

if [ CI_PRODUCT_PLATFORM = 'iOS' ]
then
	# Install CocoaPods using Homebrew.
	brew install cocoapods
			
	# Install dependencies you manage with CocoaPods.
	pod install
fi