//
//  ALBaseViewController.m
//  AnylineExamples
//
//  Created by David Dengg on 15.02.16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALBaseViewController.h"
#import "Reachability.h"
#import "ALPrivacyViewController.h"
#import "UIViewController+ALExamplesAdditions.h"
#import "ALDeviceInformationHelper.h"
#import <WebKit/WebKit.h>
#import <MessageUI/MessageUI.h>
#import "UIColor+ALExamplesAdditions.h"

NSString * const kForgetMeLinkString = @"hello@anyline.com";

@interface ALBaseViewController ()  <WKNavigationDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *progessView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ALBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor AL_BackButton]];
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
    NSString *urlEscaped = [url stringByAddingPercentEncodingWithAllowedCharacters:
                            [NSCharacterSet URLPathAllowedCharacterSet]];
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

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    if (NSEqualRanges([[textView.attributedText string] rangeOfString:kForgetMeLinkString], characterRange)) {
        [self forgetMyDataPressed];
        //don't also follow the mailto: url to open a blank email
        return NO;
    }
    
    if ([URL.absoluteString localizedCaseInsensitiveContainsString:@"privacy-policy"]) {
        ALPrivacyViewController *privacyViewController = [[ALPrivacyViewController alloc] init];
        [privacyViewController setFileName:@"Anyline App Privacy Policy"];
        [self.navigationController pushViewController:privacyViewController animated:NO];
        return NO;
    }
    
    return YES;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom methods

- (void)forgetMyDataPressed {
    if (![MFMailComposeViewController canSendMail]) {
        [self showAlertWithTitle:@"Mail Settings"
                                    message:@"Please set up an email account in the Settings App"];
        return;
    }
    MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = self;
    
    // Configure the fields of the interface.
    [composeVC setToRecipients:@[@"hello@anyline.com"]];
    [composeVC setSubject:@"Forget my Data"];
    
    
    NSString *mailTextStart = @"Hello,</br></br>===========================</br>Do not delete this text:";
    NSString *mailTextEnd = @"===========================</br></br>Thank you";
    
    NSString *messageBody = [NSString stringWithFormat:@"%@</br><b>%@</b></br>%@", mailTextStart, [ALDeviceInformationHelper getUUID], mailTextEnd];
    [composeVC setMessageBody:messageBody isHTML:YES];
    
    // Present the view controller modally.
    [self presentViewController:composeVC animated:YES completion:nil];
}


@end
