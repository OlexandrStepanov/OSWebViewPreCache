# OSWebViewPreCache

99% of business projects require to have "Terms and Conditions" and "Privacy policy" pages. Moreover, in most cases it is legal obligation to have these pages accessible even when device is offline, without internet connection.
`OSWebViewPreCache` is easy-to-go solution for offline caching of web pages.

## Features

* Create and update the cache of the web page when it's loaded while device is online. Cache in this case is stored in the Documents folder under the 'WebCache' directory.
* Load a web page from cache when device is online. Cache is loaded from the Documents folder or from the application bundle if cache wasn't created yet (if page wasn't load when device online even once).
* Support of pre-cache for web pages, to make them accessible even if they were not loaded once. To make this happen, read instructions bellow.

## Requirements

* iOS 8.0+
* ARC
* XCode 6+
 
### Dependencies

* Reachibility

## Installation

`OSWebViewPreCache` supports multiple methods for installing in a project.

### CocoaPods
To integrate `OSWebViewPreCache` into your Xcode project using CocoaPods, specify it in your Podfile:

```
 pod 'OSWebViewPreCache'
``` 

Then, run the following command:

``` 
$ pod install
``` 

### Classic
Add `OSWebViewPreCache` folder to your 3rd parties directory in the project.

## Usage

Import UIWebView category to your web view controller

``` objective-c
#import "UIWebView+PreCache.h"
```

In order to load web page from cache use one of next UIWebView category methods:

``` objective-c
- (void)loadUrlUsingCache:(NSURL *)url;
- (void)loadUrlUsingCache:(NSURL *)url withReloadRequiredBlock:(UIWebViewPreCacheReloadRequiredBlock)block;
```

Refer to `OSWebViewPreCacheSample` project to get usage example.

### Pre-cache

To make your web pages accessible when device offline even without loading it once, follow next steps:

 * Run the app either on device either on simulator
 * Open web pages which are required to pre-cache in the app to create cache of them under the Documents folder
 * Access the application Documents folder to copy 'WebCache' directory, for device and simulator approaches are different
    * On device set 'UIFileSharingEnabled' key to YES in the Info.plist, and access Documents from the iTunes
    * On Simulator the one can navigate to the Documents folder via Finder. Use next folder as start point:     ~/Library/Developer/CoreSimulator/Devices/

 * Add the 'WebCache' folder to your project as reference (note, that it should have blue icon in XCode then)

## License

`OSWebViewPreCache` is available under the Apache v2.0 license.
Refer to LICENSE file for details.

Copyright © 2015 Oleksandr Stepanov.
