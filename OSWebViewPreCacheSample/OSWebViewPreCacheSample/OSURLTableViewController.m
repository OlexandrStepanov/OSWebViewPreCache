//
//  OSURLTableViewController.m
//  OSWebViewPreCacheSample
//
//  Created by Alex.S on 21/09/2015.
//  Copyright © 2015 StartApp. All rights reserved.
//

#import "OSURLTableViewController.h"
#import "OSWebViewController.h"

@interface OSURLTableViewController ()

@end

@implementation OSURLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OSWebViewController *webScreen = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"static"])
    {
        webScreen.urlToLoad = [NSURL URLWithString:@"http://www.apple.com/legal/internet-services/terms/site.html"];
    }
    else if ([segue.identifier isEqualToString:@"dynamic"])
    {
        webScreen.urlToLoad = [NSURL URLWithString:@"http://time.is/UTC"];
    }
}

@end
