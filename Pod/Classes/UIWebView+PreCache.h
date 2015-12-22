//
//  UIWebView+PreCache.h
//
//  Created by Alex.S on 30/08/2015.
//  Copyright (c) 2015 Oleksandr Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIWebViewPreCacheReloadResultBlock)(BOOL reloadFlag);
typedef void (^UIWebViewPreCacheReloadRequiredBlock)(UIWebView *webView, UIWebViewPreCacheReloadResultBlock resultBlock);

@interface UIWebView (PreCache)

/**
 *  Start loading request using pre cache from app bundle.
 *  This method calls loadRequestUsingCache:withReloadRequiredBlock: with #2 argument nil.
 *
 *  @param url To load.
 */
- (void)loadUrlUsingCache:(NSURL *)url;

/**
 *  Same as loadRequestUsingCache: but with reload required block. This block is called in case, if presented cache version is not up to date, and page should be reload. In this case this block is called with web view, current object, and block, shich shuold be called as result of decision - YES if should reload, NO - if not.
 *
 *  @param url To load.
 *  @param block   controls reload case. In case of nil, page won't be reloaded
 */
- (void)loadUrlUsingCache:(NSURL *)url withReloadRequiredBlock:(UIWebViewPreCacheReloadRequiredBlock)block;

/**
 *  This method should be used to stop all precache loading and updating, which could happen in background, when this web view is about to deallocate.
 */
- (void)stopPrecacheLoading;

@end

