//
//  ALOnboardingWelcomeViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 19/08/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALOnboardingWelcomeViewController.h"

#import "UIFont+ALExamplesAdditions.h"

@interface ALOnboardingWelcomeViewController ()

@end

@implementation ALOnboardingWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *welcome = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome"]];
    welcome.center = CGPointMake(self.view.center.x, 200);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] nativeBounds].size.height == 960) {
        welcome.frame = CGRectMake(0, 0, 140, 140);
        welcome.center = CGPointMake(self.view.center.x, 100);
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] nativeBounds].size.height == 1136) {
        welcome.frame = CGRectMake(0, 0, 220, 220);
        welcome.center = CGPointMake(self.view.center.x, 150);
    }
    

    
    [self.view addSubview:welcome];
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, welcome.frame.origin.y + welcome.frame.size.height + 30, 300, 40)];
        label.text = @"WELCOME TO ANYLINE!";
        label.font = [UIFont AL_proximaBoldWithSize:21];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.center = CGPointMake(self.view.center.x, label.center.y);
        [self.view addSubview:label];
    }
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, welcome.frame.origin.y + welcome.frame.size.height + 70, 300, 120)];
        label.text = @"Anyline is the leading mobile text recognition SDK for your mobile device. You can embed Anyline in your own mobile app and digitize and scan all kind of texts, codes and numbers. This app shows a few things that already work and gives ideas about what you can adjust!";
        label.numberOfLines = 0;
        label.font = [UIFont AL_proximaRegularWithSize:17];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.center = CGPointMake(self.view.center.x, label.center.y);
        [self.view addSubview:label];
    }
}

@end
