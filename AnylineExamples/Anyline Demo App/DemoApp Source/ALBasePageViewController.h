//
//  ALBasePageViewController.h
//  AnylineExamples
//
//  Created by Philipp Müller on 18/11/17.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALExample;

@interface ALBasePageViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray<UIViewController *> *pages;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIImageView *anylineLogoImageView;
@property (nonatomic) NSInteger currIndex;
@property (nonatomic) BOOL onboardingDidShow;

@property (nonatomic, readonly) BOOL shouldShowSegmentedControl;

// if there's a banner, it's below it. and this should be deactivated.
@property (nonatomic, strong) NSLayoutConstraint *headerTopToViewTopAnchor;

@property (nonatomic, strong) UIPageViewController *pageViewController;

- (void)highlightSegmentedControlAtIndex:(NSInteger)index;
- (NSString *)titleOfExampleManagerOnIndex:(NSInteger)idx;
- (void)prepareSegmentedControl;

- (CGRect)headerFrame;



@end
