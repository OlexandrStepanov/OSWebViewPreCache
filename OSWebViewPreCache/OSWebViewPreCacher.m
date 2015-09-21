//
//  UIWebViewPreCacher.m
//
//  Created by Alex.S on 30/08/2015.
//  Copyright (c) 2015 Oleksandr Stepanov. All rights reserved.
//

#import <AFNetworking.h>

#import "OSWebViewPreCacher.h"
#import "OSURLCache.h"


#define kReloadNumberOfTries 2
#define kReloadTimeInterval 1.0
#define kWebViewDidReallyFinishLoadInterval 1.0
#define kBackgroundWebViewStartLoadInterval 0.5

#define kWebViewTimeoutIntervalWithCache 10
#define kWebViewTimeoutIntervalWithoutCache 30



static NSMutableSet *_webViewPreCacherGlobalPool = nil;




@interface OSWebViewPreCacher ()

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, copy) NSURLRequest *webViewRequest;

@property (nonatomic, strong) UIWebView* backgroundWebView;

@property (nonatomic) int webViewLoadsCounter;
@property (nonatomic) int numberOfReloadTries;

@property (nonatomic, weak) id<UIWebViewDelegate> originalWebViewDelegate;

@property (nonatomic, strong) NSDate *startLoadingTime;

@end

@implementation OSWebViewPreCacher

- (void)dealloc
{
    NSLog(@"dealloc of OSWebViewPreCacher");
}

+ (void)initialize
{
    _webViewPreCacherGlobalPool = [NSMutableSet set];
}

+ (void)stopAllLoadingForWebView:(UIWebView*)webView
{
    //  First, search for object from pool with provided webView
    OSWebViewPreCacher* __block preCacher = nil;
    [_webViewPreCacherGlobalPool enumerateObjectsUsingBlock:^(OSWebViewPreCacher *obj, BOOL *stop) {
        if (obj.webView == webView) {
            preCacher = obj;
            *stop = YES;
        }
    }];
    
    //  Next - if found, stop all processes
    if (preCacher)
    {
        [preCacher.webView stopLoading];
        [preCacher.backgroundWebView stopLoading];
        preCacher.webView.delegate = preCacher.originalWebViewDelegate;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [preCacher purgeSelf];
    }
}

- (id)initWithWebView:(UIWebView*)webView
{
    if (self = [super init])
    {
        self.webView = webView;
    }
    
    return self;
}

- (void)startProcessingWithURL:(NSURL*)requestURL
{
    self.startLoadingTime = [NSDate date];
    self.webViewLoadsCounter = 0;
    
    self.originalWebViewDelegate = self.webView.delegate;
    self.webView.delegate = self;
    
    //  We enable the cache to load the cached version
    [[OSURLCache sharedInstance] enableCache];
    
    NSURLRequest *request;
    //  If we have precached data - load only from cache
    if ([[OSURLCache sharedInstance] hasPrecacheDataForURL:requestURL])
    {
        request = [NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:kWebViewTimeoutIntervalWithCache];
    }
    //  No precache - load request without using cache, because it should be created
    else
    {
        request = [NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebViewTimeoutIntervalWithoutCache];
    }
    self.webViewRequest = request;
    [self.webView loadRequest:self.webViewRequest];
    
    [_webViewPreCacherGlobalPool addObject:self];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (webView == self.webView) {
        if ([self.originalWebViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
            return [self.originalWebViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
        }
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.webViewLoadsCounter++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"Start with %@ webViewLoadsCounter = %d", (webView == self.webView ? @"webview" : @"background"), self.webViewLoadsCounter);
    
    if (webView == self.webView) {
        if ([self.originalWebViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
            [self.originalWebViewDelegate webViewDidStartLoad:webView];
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        if ([self.originalWebViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
            [self.originalWebViewDelegate webViewDidFinishLoad:webView];
        }
    }
    
    self.webViewLoadsCounter--;
    NSLog(@"Finish with %@ webViewLoadsCounter = %d", (webView == self.webView ? @"webview" : @"background"), self.webViewLoadsCounter);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(webViewReallyDidFinishLoad:) object:webView];
    [self performSelector:@selector(webViewReallyDidFinishLoad:) withObject:webView
               afterDelay:kWebViewDidReallyFinishLoadInterval];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(webViewReallyDidFinishLoad:) object:webView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //  In some cases, when device just moved to airplane mode for example, web view fails to load request
    //  In this case we have to try again after some delay.
    if (webView == self.webView &&
        [AFNetworkReachabilityManager sharedManager].isReachable &&
        self.numberOfReloadTries < kReloadNumberOfTries)
    {
        self.numberOfReloadTries++;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kReloadTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self startProcessingWithURL:self.webViewRequest.URL];
        });
        
        return;
    }
    
    
    //  In other case - loading failed
    NSLog(@"IAWebViewPreCacher: failed to load request with URL: %@;\n error: %@", self.webViewRequest.URL, error);
    
    [webView stopLoading];
    
    if (webView == self.webView)
    {
        if ([self.originalWebViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
            [self.originalWebViewDelegate webView:webView didFailLoadWithError:error];
        }
        self.webView.delegate = self.originalWebViewDelegate;
    }
    
    [self purgeSelf];
}

#pragma mark -

-(void)webViewReallyDidFinishLoad:(UIWebView*)webView {
    
    //  If really web view did finish loading
    if (self.webViewLoadsCounter <= 0)
    {
        NSLog(@"\n\n---\n\nwebViewReallyDidFinishLoad with %@", (webView == self.webView ? @"webview" : @"background"));
        
        //  In order to avoid cross loading of web views - stop loading at this point
        [webView stopLoading];
        self.webViewLoadsCounter = 0;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (webView == self.webView)
        {
            self.webView.delegate = self.originalWebViewDelegate;
            
            //  Create background web view, and start loading without using cache.
            //  But only if web view was loaded from cache
            if (self.webViewRequest.cachePolicy == NSURLRequestReturnCacheDataDontLoad)
            {
                id __weak weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kBackgroundWebViewStartLoadInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    OSWebViewPreCacher *strongSelf = weakSelf;
                    if (strongSelf)
                    {
                        NSURLRequest *request = [NSURLRequest requestWithURL:strongSelf.webViewRequest.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebViewTimeoutIntervalWithoutCache];
                        strongSelf.backgroundWebView = [[UIWebView alloc] initWithFrame:strongSelf.webView.bounds];
                        strongSelf.backgroundWebView.delegate = self;
                        [strongSelf.backgroundWebView loadRequest:request];
                    }
                });
            }
            else
            {
                [self purgeSelf];
            }
        }
        //  Background web view case
        else
        {
            self.backgroundWebView = nil;
            NSLog(@"FINISHED: cache was updated: %d", [[OSURLCache sharedInstance] cacheWasUpdated]);
            [self purgeSelf];
        }
    }
}

- (void)purgeSelf
{
    [[OSURLCache sharedInstance] disableCache];
    [_webViewPreCacherGlobalPool removeObject:self];
}


@end
