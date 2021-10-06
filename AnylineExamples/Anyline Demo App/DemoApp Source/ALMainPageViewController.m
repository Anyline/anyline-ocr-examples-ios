//
//  ALOnboardingViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 17/08/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALMainPageViewController.h"

#import "ALGridCollectionViewController.h"
#import "ALProductExampleManager.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"

#import "ALBundleInfoViewController.h"

@interface ALMainPageViewController ()

@end


@implementation ALMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPages];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
}

- (void)setupPages {
    
    ALGridCollectionViewController *products = (ALGridCollectionViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"gridViewController"];
    products.exampleManager = [[ALProductExampleManager alloc] init];
    products.managedObjectContext = self.managedObjectContext;

    self.onboardingDidShow = false;
    self.currIndex = 0;
    self.title = [self titleOfExampleManagerOnIndex:self.currIndex];
    
    self.pages = @[products];
    
    [self.pageViewController setViewControllers:@[self.pages[0]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:NULL];
    
    // Add action to Header view, to open BundleInfoViewController
    [self.header setUserInteractionEnabled:YES];
    [self.header addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(showInfo:)]];
}

#pragma mark - Action methods

- (void)showInfo:(id)sender {
    ALBundleInfoViewController *infoVC = [[ALBundleInfoViewController alloc] init];
    infoVC.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
