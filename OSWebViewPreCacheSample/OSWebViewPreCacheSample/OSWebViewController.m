//
//  ViewController.m
//  OSWebViewPreCacheSample
//
//  Created by Alex.S on 01/09/2015.
//  Copyright (c) 2015 StartApp. All rights reserved.
//

#import "OSWebViewController.h"
#import "UIWebView+PreCache.h"
#import "UIAlertController+Blocks.h"

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
        if (self.reloadEnabled)
        {
            [self.webView loadUrlUsingCache:self.urlToLoad withReloadRequiredBlock:^(UIWebView *webView, UIWebViewPreCacheReloadResultBlock resultBlock) {
                [UIAlertController showAlertInViewController:self
                                                   withTitle:NSLocalizedString(@"New version", nil)
                                                     message:NSLocalizedString(@"There is a new version of this page available, do you want to reload it?", nil)
                                           cancelButtonTitle:NSLocalizedString(@"No", nil)
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@[NSLocalizedString(@"Yes", nil)]
                                                    tapBlock:
                 ^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    resultBlock(action.style != UIAlertActionStyleCancel);
                }];
            }];
        }
        else
        {
            [self.webView loadUrlUsingCache:self.urlToLoad];
        }
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
