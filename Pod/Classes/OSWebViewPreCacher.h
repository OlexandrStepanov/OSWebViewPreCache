//
//  UIWebViewPreCacher.h
//
//  Created by Alex.S on 30/08/2015.
//  Copyright (c) 2015 Oleksandr Stepanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIWebView+PreCache.h"

@interface OSWebViewPreCacher : NSObject <UIWebViewDelegate>

+ (void)stopAllLoadingForWebView:(UIWebView*)webView;


@property (nonatomic, readonly) UIWebView* webView;
@property (nonatomic, copy) UIWebViewPreCacheReloadRequiredBlock pageReloadRequired;

- (id)initWithWebView:(UIWebView*)webView;
- (void)startProcessingWithURL:(NSURL*)requestURL;

@end
