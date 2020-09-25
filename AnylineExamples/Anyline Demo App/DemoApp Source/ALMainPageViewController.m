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

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupPages];
}

- (void)setupPages {
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(frame.origin.x, self.header.frame.origin.y + self.header.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height - self.header.frame.size.height);
    /*
     * set up three pages, each with a different background color
     */
    ALGridCollectionViewController *products = (ALGridCollectionViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"gridViewController"];
    products.collectionView.frame = frame;
    products.exampleManager = [[ALProductExampleManager alloc] init];
    products.managedObjectContext = self.managedObjectContext;

    self.pages = @[products];
    
    self.onboardingDidShow = false;
    self.currIndex = 0;
    self.title = [self titleOfExampleManagerOnIndex:self.currIndex];
    
    // set the initially visible page's view controller... if you don't do this
    // you won't see anything.
    [self setViewControllers:@[self.pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    //Add action to Header view, to open BundleInfoViewController
    [self.header setUserInteractionEnabled:YES];
    [self.header addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInfo:)]];

}

#pragma mark - Action methods
- (void)showInfo:(id)sender {
    ALBundleInfoViewController *infoVC = [[ALBundleInfoViewController alloc] init];
    infoVC.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:infoVC animated:YES];
}


@end
