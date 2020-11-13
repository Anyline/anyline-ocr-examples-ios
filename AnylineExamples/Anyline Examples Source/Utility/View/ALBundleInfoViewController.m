//
//  ALBundleInfoViewController.m
//  AnylineExamples
//
//  Created by David Dengg on 01.06.16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALBundleInfoViewController.h"

#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"

#import "NSUserDefaults+ALExamplesAdditions.h"
#import "UIViewController+ALExamplesAdditions.h"

#import <Anyline/Anyline.h>

@interface ALBundleInfoViewController () <UITextFieldDelegate,MFMailComposeViewControllerDelegate>
@end

@implementation ALBundleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Anyline", @"title");
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    CGFloat offset = 100;
    CGFloat padding = 30;
    CGFloat labelWidthPadding = 10;
    
    CGFloat categoryHeightPadding = 10;
    CGFloat categoryLabelHeight = 45;
    
    CGFloat labelWidth = self.view.frame.size.width - padding;
    
    UIColor *titleLabelBackgroundColor = RGBA(23.0f,31.0f,42.0f,1.0f);
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:scrollView];
    
    CGFloat topPadding = 0;
    CGFloat bottomPadding = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        topPadding = window.safeAreaInsets.top;
        bottomPadding = window.safeAreaInsets.bottom;
    }
    
    {
        UIButton * logo = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [logo setImage:[UIImage imageNamed:@"anyline_white_large"] forState:UIControlStateNormal];
        logo.frame = CGRectMake(self.view.center.x, offset, 80,80);
        logo.center = CGPointMake(self.view.center.x, offset);
        [scrollView addSubview:logo];
        offset += logo.frame.size.height/2;
    }
    
    offset += 20;
    
    {
        UIButton *whatIs = [UIButton buttonWithType:UIButtonTypeCustom];
        whatIs.frame = CGRectMake(0, offset, labelWidth, 40);
        [whatIs setTitle:@"What is Anyline?" forState:UIControlStateNormal];
        whatIs.titleLabel.font = [UIFont AL_proximaBoldWithSize:20];
        [whatIs setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        whatIs.titleLabel.textAlignment = NSTextAlignmentCenter;
        whatIs.center = CGPointMake(self.view.center.x, whatIs.center.y);
        [scrollView addSubview:whatIs];
        offset += whatIs.frame.size.height - 10;
    }
    
    offset += labelWidthPadding;
    
    {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, offset, labelWidth, 40)];
        label.text = @"Anyline® is the leading mobile text recognition SDK for your mobile device. You can embed Anyline in your own mobile app and digitize and scan all kind of texts, codes and numbers. This app shows a few things that already work and gives ideas about what you can adjust!";
        label.numberOfLines = 0;
        label.font = [UIFont AL_proximaRegularWithSize:15];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.center = CGPointMake(self.view.center.x, label.center.y);
        [scrollView addSubview:label];
    }
    
    //used to split scrollView in 2 "Pages"
    CGFloat currContentHeight = scrollView.bounds.size.height;
    
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 200, 44);
        
        button.titleLabel.font = [UIFont AL_proximaSemiboldWithSize:18];
        [button addTarget:self action:@selector(contactUsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Contact us" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 22;
        button.layer.borderColor = [[UIColor whiteColor] CGColor];
        button.layer.borderWidth = 1.0;
        button.center = CGPointMake(self.view.center.x, (currContentHeight - button.frame.size.height*2)-25 - bottomPadding);
        [scrollView addSubview:button];
    }
    
    //set Offset to split scrollView in 2 "pages"
    offset = currContentHeight + categoryHeightPadding;
    
    {
        UIView *reportingTitleView = [[UIView alloc] init];
        reportingTitleView.frame = CGRectMake(0, offset, scrollView.frame.size.width, categoryLabelHeight);
        reportingTitleView.backgroundColor = titleLabelBackgroundColor;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, reportingTitleView.frame.size.height)];
        label.text = @"Data Privacy Consent";
        label.numberOfLines = 0;
        label.font = [UIFont AL_proximaRegularWithSize:17];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.center = CGPointMake(0 + label.frame.size.width/2 + labelWidthPadding, reportingTitleView.frame.size.height/2);
        [reportingTitleView addSubview:label];
        
        [scrollView addSubview:reportingTitleView];
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0+labelWidthPadding, offset+reportingTitleView.frame.size.height+5, scrollView.frame.size.width - labelWidthPadding, 30)];
        descriptionLabel.text = @"The reporting of results in the Community Edition, including the photo of a scanned item, helps us improve our product and the customer experience.";
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.font = [UIFont AL_proximaRegularWithSize:14];
        descriptionLabel.textColor = [UIColor whiteColor];
        [descriptionLabel sizeToFit];
        
        [scrollView addSubview:descriptionLabel];
        offset += (reportingTitleView.frame.size.height+descriptionLabel.frame.size.height+5);
    }
    
    offset += categoryHeightPadding;
    
    {
        UIView *appVersionView = [[UIView alloc] init];
        appVersionView.frame = CGRectMake(0, offset, scrollView.frame.size.width, categoryLabelHeight);
        appVersionView.backgroundColor = titleLabelBackgroundColor;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, appVersionView.frame.size.height)];
        
        label.text = [NSString stringWithFormat:@"App: %@ (%@), %@", [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"], [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleExecutable"]]; //CFBundleName
        label.numberOfLines = 0;
        label.font = [UIFont AL_proximaRegularWithSize:17];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.center = CGPointMake(0 + label.frame.size.width/2 + labelWidthPadding, appVersionView.frame.size.height/2);
        
        [appVersionView addSubview:label];
        [scrollView addSubview:appVersionView];
    }
    
    offset += (categoryLabelHeight+1.5);
    
    
    {
        UIView *sdkVersionView = [[UIView alloc] init];
        sdkVersionView.frame = CGRectMake(0, offset, scrollView.frame.size.width, categoryLabelHeight);
        sdkVersionView.backgroundColor = titleLabelBackgroundColor;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, sdkVersionView.frame.size.height)];
        label.text = [NSString stringWithFormat:@"SDK: %@ (%@)", [ALCoreController versionNumber], [ALCoreController buildNumber]];
        label.numberOfLines = 0;
        label.font = [UIFont AL_proximaRegularWithSize:17];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.center = CGPointMake(0 + label.frame.size.width/2 + labelWidthPadding, sdkVersionView.frame.size.height/2);
        
        [sdkVersionView addSubview:label];
        [scrollView addSubview:sdkVersionView];
    }
    
    offset += categoryLabelHeight;
    int smoothScrollingHeight = (int)currContentHeight - ((int)offset % (int)currContentHeight);
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, offset + smoothScrollingHeight);
}

#pragma mark - IBActions

- (IBAction)contactUsPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://anyline.com/request/contact/"]  options:@{} completionHandler:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
