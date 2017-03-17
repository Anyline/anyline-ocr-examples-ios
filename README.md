
     _____         _ _         
    |  _  |___ _ _| |_|___ ___ 
    |     |   | | | | |   | -_|
    |__|__|_|_|_  |_|_|_|_|___|
              |___|            


# Anyline Examples App 

[Anyline](https://www.anyline.io) is mobile OCR SDK, which can be configured by yourself to scan all kinds of numbers, characters, text and codes. 

The Example App provides you with many working preconfigured modules, which show the bandwith of what the SDK can scan. 


## Quick Start Guide

### 0. Clone or Download

* If you'd like to clone the repository you will have to use git-lfs. Use the following commands to install git-lfs.

`
brew install git-lfs

git lfs install
`

* If you prefer downloading a package, use the provided `zip` package on the [releases page](https://github.com/Anyline/anyline-ocr-examples-ios/releases). Be aware that the github download zip button does not work for projects with git-lfs.

### 1. With Cocoapods

Simply add pod ‘Anyline’, ’~> 3.10’ to your Podfile and run pod install or pod update. (Please make sure you are on the latest version of CocoaPods)

You’re all done and can jump to point 3.1.

Or via local copy of the Anyline.framework & AnylineResources.bundle #####

Simply drag & drop Anyline.framework & AnylineResources.bundle into your project tree. 
!¢[Add Framework](/images/AddFramework.jpg)

In the import screen select Copy items if needed and Create groups and add the files to your target.
![Copy Framework](/images/CopyFramework.jpg)

### 2. Linking Frameworks

After the framework and bundle got imported go to your project inspector. In the Build Phases tab, add the following libraries:

* libc++.tbd
* libz.tbd
* AssetsLibrary.framework

After adding the libraries, it should look like this (notice the AnylineResources bundle, if its not in Copy Bundle Resources add it): 
![Link Frameworks](/images/LinkFrameworks.png)

### 3. Linker Flags

> This changed from -ObjC to -all_load in Anyline SDK Version 3.6.

In your project inspector switch to the Build Settings tab and search for Other Linker Flags. Select Other - Other Linker Flags and add -all_load. This flag causes the linker to load every object file in the library that defines an Objective-C class or category.
![Linker Flags](/images/LinkerFlags.jpg)

#### 3.1 Bitcode

Bitcode needs to be disabled. Just search for “Bit” and set Enable Bitcode to No.
![Build Bitcode iOS](/images/iOS_build_bitcode.png)

[Apple Documentation on Bitcode](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html)

### 4. Init an AnylineModuleView in your ViewController or Storyboard

There are more modules specific options - take a look at the description of the desired module in the Anyline Documentation to get more detailed information. 

### 5. Enjoy scanning and have fun! :movie_camera:


> Anyline is also available as Cocoapod: `pod 'Anyline', '~> 3.6'`


## Sample Codes & Documentation 

Have look at some of our code examples: [Sample Code](https://www.anyline.io/demos-sample-code)

Detailed information about how to configure and implement Anyline: [Documentation](https://documentation.anyline.io)


## License 

To claim a free developer / trial license, go to: [Anyline SDK Register Form](http://anyline.io/sdk-register?utm_source=githubios&utm_medium=readme&utm_campaign=examplesapp
)
The software underlies the MIT License. As Anyline is a paid software for Commerical Projects, the License Agreement of Anyline GmbH apply, when used commercially. Please have a look at [Anyline License Agreement](https://anylinewebsiteresource.blob.core.windows.net/wordpressmedia/2015/12/ULA-AnylineSDK-August2015.pdf)


# KITT <3

![KITT] (images/visualFeedback/kitt/contour_point.gif)


