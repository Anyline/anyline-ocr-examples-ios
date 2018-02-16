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

//TODO: add this only in store
//#import "ALIndustriesExampleManager.h"

#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"

@interface ALMainPageViewController ()

@end

@implementation ALMainPageViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupPages];
}

- (void)setupPages {
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
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
}

@end
