//
//  ALBaseViewController.m
//  AnylineExamples
//
//  Created by David Dengg on 15.02.16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALBaseViewController.h"
#import "Reachability.h"
#import <WebKit/WebKit.h>

@interface ALBaseViewController ()  <WKNavigationDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *progessView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ALBaseViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)stopLoading {
    [self.progessView stopAnimating];
    [self.progessView removeFromSuperview];
}

- (void)startLoading {
    if( self.progessView == nil) {
        self.progessView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
        [self.progessView setColor:[UIColor darkGrayColor]];
        [self.view addSubview:self.progessView];
    }
    [self.progessView startAnimating];
}

- (void)displayLabelWithString:(NSString *)sorryString {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(self.view.bounds, 30, 30)];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = sorryString;
    [self.view addSubview:label];
}

- (BOOL)checkConnectionAndWarnUser {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self displayLabelWithString:[NSString stringWithFormat:@"The device seems to be offline. Please check your internet connection. \n \n Scan Result: %@",self.result]];
        return NO;
    }
    return YES;
}

- (void)startWebSearchWithURL:(NSString *)inUrl {
    
    if(![self checkConnectionAndWarnUser]) {
        return;
    }    

    [self startLoading];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    
    NSString *url = [NSString stringWithString:inUrl];
    NSString *urlEscaped = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *nsUrl  = [NSURL URLWithString:urlEscaped];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30];
    
    self.webView.alpha = 0;
    self.webView.navigationDelegate=self;
    [self.webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self stopLoading];
    [UIView animateWithDuration:0.5 animations:^{
        self.webView.alpha = 1;
    }];
}


@end
