//
//  ViewController.m
//  OSWebViewPreCacheSample
//
//  Created by Alex.S on 01/09/2015.
//  Copyright (c) 2015 StartApp. All rights reserved.
//

#import "OSWebViewController.h"
#import "UIWebView+PreCache.h"
#import "OSURLCache.h"

@interface OSWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingWheel;

@end

@implementation OSWebViewController

- (void)dealloc
{
    [self.webView stopPrecacheLoading];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.urlToLoad)
    {
        [self.loadingWheel startAnimating];
        [self.webView loadUrlUsingCache:self.urlToLoad];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingWheel stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.loadingWheel stopAnimating];
}

@end
