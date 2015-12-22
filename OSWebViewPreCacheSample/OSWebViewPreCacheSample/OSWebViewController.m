//
//  ViewController.m
//  OSWebViewPreCacheSample
//
//  Created by Alex.S on 01/09/2015.
//  Copyright (c) 2015 StartApp. All rights reserved.
//

#import "OSWebViewController.h"
#import "UIWebView+PreCache.h"

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
                
                UIAlertController *alert =
                [UIAlertController alertControllerWithTitle:NSLocalizedString(@"New version", nil)
                                                    message:NSLocalizedString(@"There is a new version of this page available, do you want to reload it?", nil)
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"No", nil)
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     resultBlock(NO);
                                                                     [self dismissViewControllerAnimated:YES completion:NULL];
                                                                 }];
                UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil)
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      resultBlock(YES);
                                                                      [self dismissViewControllerAnimated:YES completion:NULL];
                                                                  }];
                
                [alert addAction:noAction];
                [alert addAction:yesAction];
                
                [self presentViewController:alert animated:YES completion:NULL];
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
