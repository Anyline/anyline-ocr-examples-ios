//
//  ALPrivacyViewController.m
//  AnylineExamples
//
//  Created by AmirAnsari on 07.05.19.
//

#import "ALPrivacyViewController.h"
#import "ALCheckbox.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import <MessageUI/MessageUI.h>
#import "ALDeviceInformationHelper.h"
#import <WebKit/WebKit.h>

typedef void (^CompletionBlock)(void);

NSString * const ALDataPrivacyFileLink = @"https://anyline.com/wp-content/uploads/2019/04/PrivacyPolicy_April19.pdf";

@interface ALPrivacyViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) ALCheckbox *cbox;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) IBOutlet UIButton *confirmButton;
@property (nonatomic, copy) CompletionBlock completionBlock;

@property (nonatomic) NSRange forgetMeRange;

@end

@implementation ALPrivacyViewController

- (instancetype)initWithCompletion:(void (^)(void))handler {
    self = [super init];
    
    if (self) {
        _completionBlock = handler;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Data Privacy Consent";
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 13.0, *)) {
        //in light mode this is a slightly lighter colour than lightGrayColor, but it still looks okay
        self.view.backgroundColor = [UIColor secondarySystemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    self.navigationItem.hidesBackButton = NO;
    
    CGFloat top = 0;
    CGFloat leftPadding = 0;
    CGFloat bottomPadding = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        top = window.safeAreaInsets.top;
        leftPadding = window.safeAreaInsets.left;
        bottomPadding = window.safeAreaInsets.bottom;
    } else {
        top = UIApplication.sharedApplication.statusBarFrame.size.height;
    }
    CGFloat topPadding = top + self.navigationController.navigationBar.frame.size.height +10;
    CGFloat textHeight = self.view.bounds.size.height - topPadding - bottomPadding;
    
    BOOL wasAccepted = [NSUserDefaults AL_dataPolicyAccepted];
    
    if (!wasAccepted) {
        self.navigationItem.hidesBackButton = YES;
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            // disable the interactivePopGestureRecognizer
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-bottomPadding-50, ((self.view.bounds.size.width)-60), 40)];
        self.confirmButton.center = CGPointMake(self.view.center.x, self.confirmButton.center.y);
        self.confirmButton.titleLabel.font = [UIFont AL_proximaRegularWithSize:18];
        [self.confirmButton setTitle:@"Continue" forState:UIControlStateNormal];
        [self.confirmButton setEnabled:wasAccepted];
        self.confirmButton.backgroundColor = [self buttonColorForEnabled:wasAccepted];
        [self.confirmButton addTarget:self action:@selector(onContinue:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.confirmButton];
        
//        self.cbox = [[ALCheckbox alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height - 90 , self.view.frame.size.width/2+10, 20)];
        
        self.cbox = [[ALCheckbox alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, self.confirmButton.frame.origin.y - 30 , self.view.frame.size.width/2+10, 20)];
        
        
        self.cbox.text = @"I accept the Data Privacy Policy";
        self.cbox.showTextLabel = YES;
        self.cbox.labelFont = [UIFont AL_proximaRegularWithSize:12];
        self.cbox.center = CGPointMake(self.view.center.x, self.cbox.center.y);
        self.cbox.isChecked = wasAccepted;
        
        if (@available(iOS 13.0, *)) {
            self.cbox.labelTextColor = [UIColor labelColor];
        } else {
            self.cbox.labelTextColor = [UIColor blackColor];
        }
        
        [self.cbox addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.cbox];
        
        //updated textHeight
        
        textHeight = self.cbox.frame.origin.y - 10 - topPadding;
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 10,
                                                                         self.view.frame.origin.y + topPadding,
                                                                         self.view.frame.size.width - 20,
                                                                         textHeight - 10)];
        webView.autoresizesSubviews = YES;
        webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        
        // specify the URL of the pdf located remotely on a server
        NSURL *url = [NSURL URLWithString:ALDataPrivacyFileLink];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        
        // load it
        [webView loadRequest:urlRequest];
        
        [self.view addSubview:webView];
        [self.view bringSubviewToFront:self.cbox];
        
        //TODO: add hard copy fallback; (no internet/file not found)
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.completionBlock) {
        self.completionBlock();
    }
}

- (void)checkAction:(id)sender {
    if (self.cbox.isChecked == true) {
        [self.confirmButton setEnabled:(true)];
        self.confirmButton.backgroundColor = [self buttonColorForEnabled:true];
        
    }
    else {
        [self.confirmButton setEnabled:(false)];
        self.confirmButton.backgroundColor = [self buttonColorForEnabled:false];
    }
}

- (UIColor *)buttonColorForEnabled:(BOOL)enabled {
    return (enabled) ? [UIColor AL_examplesBlue] : [UIColor grayColor];
}

- (void)onContinue:(id)sender {
    BOOL wasAccepted = [NSUserDefaults AL_dataPolicyAccepted];
    
    if (!wasAccepted) {
        [NSUserDefaults AL_setDataPolicyAccepted:YES];
    }
    
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:wasAccepted];
    } else {
        [self dismissViewControllerAnimated:wasAccepted completion:nil];
    }
    
}

@end
