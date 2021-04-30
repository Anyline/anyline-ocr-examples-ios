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

#import "AnylineExamples-Swift.h"
#import "NSAttributedString+ALExamplesAdditions.h"
#import "UIButton+ALExamplesExtensions.h"

typedef void (^CompletionBlock)(void);

NSString * const ALDataPrivacyFileLink = @"https://anyline.com/privacy-policy-en/";
NSString * const kBaseFileName = @"DataProcessingConsent";

@interface ALPrivacyViewController () <MFMailComposeViewControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UILabel * privacyLabel;
@property (nonatomic, strong) ALCheckbox *cbox;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, copy) CompletionBlock completionBlock;

@property (nonatomic, strong) UIView *controlElementsView;
@property (nonatomic, strong) UITextView *privacyPolicyTextView;
@property (nonatomic, assign) BOOL isBaseFile;

@end

@implementation ALPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor AL_BackButton]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor AL_BackButton]];
    
    self.privacyLabel = [[UILabel alloc] init];
    if (!self.fileName) {
        self.title = @"Privacy Policy & Data Processing";
        self.privacyLabel.text = @"Privacy Policy and\nData Processing Consent";
        self.isBaseFile = YES;
        self.fileName = kBaseFileName;
    } else {
        self.title = @"Privacy Policy";
        self.privacyLabel.text = @"Privacy Policy";
    }
    
    self.view.backgroundColor = [UIColor AL_BackgroundColor];
    
    BOOL wasAccepted = [NSUserDefaults AL_dataPolicyAccepted];
    
    self.navigationItem.hidesBackButton = !wasAccepted && self.isBaseFile;
    
    // disable the interactivePopGestureRecognizer
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
    
    self.privacyLabel.numberOfLines = 0;
    self.privacyLabel.font = [UIFont AL_proximaBoldWithSize:24];
    self.privacyLabel.textAlignment = NSTextAlignmentLeft;
    self.privacyLabel.textColor = [UIColor AL_examplesBlue];
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:self.privacyLabel.text attributes:@{NSFontAttributeName:self.privacyLabel.font}];
    NSRange range = [mutableAttString.mutableString rangeOfString:@"Data Processing Consent" options:NSCaseInsensitiveSearch];
    [mutableAttString addAttributes:@{NSForegroundColorAttributeName:[UIColor AL_LabelBlackWhite]} range:range];
    [self.privacyLabel setAttributedText:mutableAttString];
    
    [self.view addSubview:self.privacyLabel];
    [self.privacyLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.privacyPolicyTextView = [self textViewWithTextFromRTF:self.fileName sideMargin:5 onView:self.view];
    
    self.privacyPolicyTextView.attributedText = [self.privacyPolicyTextView.attributedText withFont:[UIFont AL_proximaRegularWithSize:16]];
    [self.privacyPolicyTextView setDelegate:self];
    [self.privacyPolicyTextView setEditable:NO];
    [self.privacyPolicyTextView setBackgroundColor:[UIColor AL_BackgroundColor]];
    [self.privacyPolicyTextView setContentOffset:CGPointMake(0, 0) animated:false];
    
    
    self.controlElementsView = [[UIView alloc] init];
    
    [self.view addSubview:self.controlElementsView];
    self.controlElementsView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self setupAcceptButton:wasAccepted];
    
    [self setupCheckbox:wasAccepted];
    
    self.privacyPolicyTextView.scrollEnabled = YES;
    
    [self setupConstraints];
    self.privacyPolicyTextView.contentSize = [self.privacyPolicyTextView sizeThatFits:self.privacyPolicyTextView.frame.size];
}

- (void)setupConstraints {
    
    NSMutableArray *constraints = @[[self.privacyLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
                                    [self.privacyLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15],
                                    [self.privacyLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]].mutableCopy;
    
    NSLayoutConstraint *bottomPrivacyConstraint = [self.privacyPolicyTextView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0];
    [bottomPrivacyConstraint setPriority:750];
    [constraints addObjectsFromArray:@[[self.privacyPolicyTextView.topAnchor constraintEqualToAnchor:self.privacyLabel.bottomAnchor constant:20],
                                       [self.privacyPolicyTextView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15],
                                       [self.privacyPolicyTextView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-15],
                                       bottomPrivacyConstraint]];
    
    if (![NSUserDefaults AL_dataPolicyAccepted] && self.isBaseFile) {
        [constraints addObjectsFromArray:@[[self.controlElementsView.topAnchor constraintEqualToAnchor:self.privacyPolicyTextView.bottomAnchor],
                                           [self.controlElementsView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                                           [self.controlElementsView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
                                           [self.controlElementsView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]]];
        
        
        [constraints addObjectsFromArray:@[[self.confirmButton.leftAnchor constraintEqualToAnchor:self.controlElementsView.leftAnchor constant:UIButton.roundedButtonHorizontalMargin],
                                           [self.confirmButton.rightAnchor constraintEqualToAnchor:self.controlElementsView.rightAnchor constant:-UIButton.roundedButtonHorizontalMargin],
                                           [self.confirmButton.heightAnchor constraintEqualToConstant:UIButton.roundedButtonHeight],
                                           [self.confirmButton.bottomAnchor constraintEqualToAnchor:self.controlElementsView.bottomAnchor constant:-20],
                                           [self.confirmButton.topAnchor constraintEqualToAnchor:self.cbox.bottomAnchor constant:10]]];
        
        
        [constraints addObjectsFromArray:@[[self.cbox.leftAnchor constraintEqualToAnchor:self.controlElementsView.leftAnchor constant:UIButton.roundedButtonHorizontalMargin],
                                           [self.cbox.rightAnchor constraintEqualToAnchor:self.controlElementsView.rightAnchor constant:-UIButton.roundedButtonHorizontalMargin],
                                           [self.cbox.heightAnchor constraintEqualToConstant:UIButton.roundedButtonHeight],
                                           [self.cbox.topAnchor constraintEqualToAnchor:self.controlElementsView.topAnchor constant:20]]];
    } else {
        [self.controlElementsView removeFromSuperview];
    }
    
    [self.view addConstraints:constraints];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.completionBlock) {
        self.completionBlock();
    }
}

- (UITextView *)textViewWithTextFromRTF:(NSString *)fileName sideMargin:(CGFloat)margin onView:(UIView *)view {
    UITextView * aboutTextView = [[UITextView alloc] init];
    
    NSURL *aboutTextURL = [NSBundle.mainBundle URLForResource:fileName withExtension:@"rtf"];
    if (aboutTextURL) {
        aboutTextView.delegate = self;
        aboutTextView.editable = false;
        aboutTextView.userInteractionEnabled = true;
        NSAttributedString *text = [[[NSAttributedString alloc] initWithURL:aboutTextURL options:@{NSDocumentTypeDocumentOption:NSRTFTextDocumentType} documentAttributes:nil error:nil] withSystemColors];
        
        aboutTextView.attributedText = text;
        
        [view addSubview:aboutTextView];
        [aboutTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return aboutTextView;
}

- (void)setupCheckbox:(BOOL)wasAccepted {
    self.cbox = [[ALCheckbox alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, self.confirmButton.frame.origin.y - 30 , self.view.frame.size.width/2+10, 20)];
    [self.controlElementsView addSubview:self.cbox];
    [self.cbox setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.cbox.text = @"I expressly consent";
    self.cbox.showTextLabel = YES;
    self.cbox.labelFont = [UIFont AL_proximaRegularWithSize:12];
    self.cbox.isChecked = wasAccepted;
    [self.cbox addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (@available(iOS 13.0, *)) {
        self.cbox.labelTextColor = [UIColor labelColor];
    } else {
        self.cbox.labelTextColor = [UIColor blackColor];
    }
}

- (void)setupAcceptButton:(BOOL)wasAccepted {
    self.confirmButton = [UIButton roundedButton];
    
    
    self.confirmButton.center = CGPointMake(self.view.center.x, self.confirmButton.center.y);
    [self.confirmButton setTitle:@"Continue" forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(onContinue:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton setEnabled:wasAccepted];
    self.confirmButton.backgroundColor = [self buttonColorForEnabled:wasAccepted];
    
    
    [self.controlElementsView addSubview:self.confirmButton];
    self.confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
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
        //Reenable swiping from the left to go back. After we call popViewControllerAnimated:, self.navigationController will be nil, so we have to do this beforehand
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationController popViewControllerAnimated:wasAccepted];
    } else {
        [self dismissViewControllerAnimated:wasAccepted completion:nil];
    }
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    if ([URL.absoluteString localizedCaseInsensitiveContainsString:@"privacy-policy"]) {
        ALPrivacyViewController *privacyViewController = [[ALPrivacyViewController alloc] init];
        [privacyViewController setFileName:@"Anyline App Privacy Policy"];
        [self.navigationController pushViewController:privacyViewController animated:NO];
        return false;
    } else {
        return true;
    }
}

@end
