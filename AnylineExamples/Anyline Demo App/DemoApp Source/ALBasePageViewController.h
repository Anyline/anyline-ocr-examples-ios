//
//  ALBasePageViewController.h
//  AnylineExamples
//
//  Created by Philipp Müller on 18/11/17.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALBasePageViewController : UIPageViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray<UIViewController *> *pages;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIImageView *anylineWhite;
@property (nonatomic) NSInteger currIndex;
@property (nonatomic) BOOL onboardingDidShow;
@property (nonatomic) BOOL hideNavigationBar;

- (void)highlightTabAtIndex:(NSInteger)index;
- (NSString *)titleOfExampleManagerOnIndex:(NSInteger)idx;
- (void)setupTabbar;

@end
