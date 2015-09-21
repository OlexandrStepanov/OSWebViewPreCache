//
//  UIWebView+PreCache.m
//
//  Created by Alex.S on 30/08/2015.
//  Copyright (c) 2015 Oleksandr Stepanov. All rights reserved.
//

#import "UIWebView+PreCache.h"
#import "OSWebViewPreCacher.h"


@implementation UIWebView (PreCache)

- (void)loadUrlUsingCache:(NSURL *)url
{
    [self loadUrlUsingCache:url withReloadRequiredBlock:NULL];
}

- (void)loadUrlUsingCache:(NSURL *)url withReloadRequiredBlock:(UIWebViewPreCacheReloadRequiredBlock)block
{
    OSWebViewPreCacher *cacher = [[OSWebViewPreCacher alloc] initWithWebView:self];
    cacher.pageReloadRequired = block;
    [cacher startProcessingWithURL:url];
}

- (void)stopPrecacheLoading {
    [OSWebViewPreCacher stopAllLoadingForWebView:self];
}

@end
