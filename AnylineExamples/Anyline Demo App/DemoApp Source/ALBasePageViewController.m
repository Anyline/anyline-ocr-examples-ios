//
//  ALOnboardingViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 17/08/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALBasePageViewController.h"

#import "ALGridCollectionViewController.h"
#import "ALProductExampleManager.h"

#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"

@interface ALBasePageViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@end

@implementation ALBasePageViewController

- (void)setupHeader {
    CGFloat navigationBarHeight = self.hideNavigationBar ? 0 : self.navigationController.navigationBar.frame.size.height;
    CGRect pageViewFrame = [[UIScreen mainScreen] bounds];
    pageViewFrame = CGRectMake(pageViewFrame.origin.x, pageViewFrame.origin.y + navigationBarHeight, pageViewFrame.size.width, pageViewFrame.size.height - navigationBarHeight);
    self.view.frame = pageViewFrame;
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat topPadding = window.safeAreaInsets.top;
    CGFloat leftPadding = window.safeAreaInsets.left;
        
//    CGRect headerFrame = CGRectMake(leftPadding, self.view.frame.origin.y + self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.width*0.35);
    CGRect headerFrame = CGRectMake(leftPadding, self.view.frame.origin.y + topPadding, self.view.frame.size.width, self.view.frame.size.width*0.25);

    [self.view layoutIfNeeded];
    
    self.header = [[UIView alloc] initWithFrame:headerFrame];
    self.header.backgroundColor = [UIColor whiteColor];
    
    self.anylineWhite = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AnylineLogo"]];
    [self.anylineWhite setContentMode:UIViewContentModeScaleAspectFit];
    [self.header addSubview:self.anylineWhite];
    self.anylineWhite.translatesAutoresizingMaskIntoConstraints = NO;
    [self.anylineWhite.widthAnchor constraintEqualToAnchor:self.header.widthAnchor multiplier:99.0/375.0].active = YES;
    [self.anylineWhite.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor].active = YES;
    [self.anylineWhite.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor constant:-10].active = YES;
    
    self.tabView = [[UISegmentedControl alloc] initWithItems:@[]];

    [self.header addSubview:self.tabView];
    self.tabView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tabView.bottomAnchor constraintEqualToAnchor:self.header.bottomAnchor constant:2].active = YES;
    [self.tabView.leftAnchor constraintEqualToAnchor:self.header.leftAnchor].active = YES;
    [self.tabView.rightAnchor constraintEqualToAnchor:self.header.rightAnchor].active = YES;
    
    [self.tabView addTarget:self action:@selector(jumpToPage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.header];
}

- (void)setupTabbar {
    [self.tabView removeAllSegments];
    for (UIViewController *page in self.pages.reverseObjectEnumerator) {
        [self.tabView insertSegmentWithTitle:[self titleOfExampleManager:page] atIndex:0 animated:NO];
    }
    [self highlightTabAtIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupHeader];
    
    [self.view bringSubviewToFront:self.tabView];
    
    self.dataSource = self;
    self.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updatePageControlLocation];
}


- (void)updatePageControlLocation {
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UIPageControl class]]) {
            //remove pageControl
            [view removeFromSuperview];
        }
    }
}
#pragma mark - UIViewController methods
- (BOOL)hidesBottomBarWhenPushed {
    return NO;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (nil == viewController) {
        return _pages[0];
    }
    NSInteger idx = [_pages indexOfObject:viewController];
    NSParameterAssert(idx != NSNotFound);
    if (idx >= [_pages count] - 1) {
        return nil;
    }
    
    return _pages[idx + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (nil == viewController) {
        return _pages[0];
    }
    NSInteger idx = [_pages indexOfObject:viewController];
    NSParameterAssert(idx != NSNotFound);
    if (idx <= 0) {
        return nil;
    }

    return _pages[idx - 1];
}

- (NSString *)titleOfExampleManager:(UIViewController *)viewController {
    id<ALExampleManagerController> vc = (id<ALExampleManagerController>)viewController;
    return vc.exampleManager.title;
}


- (NSString *)titleOfExampleManagerOnIndex:(NSInteger)idx {
    return [self titleOfExampleManager:[_pages objectAtIndex:idx]];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed) {
        NSInteger idx = [self.pages indexOfObject:self.viewControllers[0]];
        NSParameterAssert(idx != NSNotFound);
        if (self.currIndex != idx) {
            self.currIndex = idx;
            
            self.title = [self titleOfExampleManagerOnIndex:self.currIndex];
            [self highlightTabAtIndex:self.currIndex];
        }

    }
}

#pragma mark - Utility Methods

- (void)highlightTabAtIndex:(NSInteger)index {
    self.tabView.selectedSegmentIndex = index;
}

- (CALayer *)addBorder:(UIRectEdge)edge color:(UIColor *)color thickness:(CGFloat)thickness frame:(CGRect)frame padding:(CGFloat)padding {
    CALayer *border = [CALayer layer];
    
    switch (edge) {
        case UIRectEdgeTop:
            border.frame = CGRectMake(0+padding, 0 - (padding/4), CGRectGetWidth(frame)-(padding*2), thickness);
            break;
        case UIRectEdgeBottom:
            border.frame = CGRectMake(0+padding, CGRectGetHeight(frame) - thickness + (padding/4), CGRectGetWidth(frame)-(padding*2), thickness);
            break;
        case UIRectEdgeLeft:
            border.frame = CGRectMake(0-padding, 0, thickness, CGRectGetHeight(frame)-(padding*2));
            break;
        case UIRectEdgeRight:
            border.frame = CGRectMake(CGRectGetWidth(frame) - thickness + padding, 0, thickness, CGRectGetHeight(frame)-(padding*2));
            break;
        default:
            break;
    }
    
    border.backgroundColor = color.CGColor;
    return border;
}



- (void)jumpToPage:(UISegmentedControl *)sender {
    NSInteger tag = sender.selectedSegmentIndex;
    if (tag >= 0 && tag < [_pages count] && tag != self.currIndex) {
        [self gotoPage:tag];
        self.title = [self titleOfExampleManagerOnIndex:tag];
    }
}

- (void)gotoPage:(NSInteger)index {
    UIViewController *viewController = _pages[index];
    
    UIPageViewControllerNavigationDirection direction;
    if(_currIndex <= index){
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    else
    {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    if(_currIndex < index)
    {
        for (int i = 0; i <= index; i++)
        {
            if (i == index) {
                [self setViewControllers:@[viewController]
                                                  direction:direction
                                                   animated:YES
                                                 completion:nil];
            }
        }
    }
    else
    {
        for (int i = (int)_currIndex; i >= index; i--)
        {
            if (i == index) {
                [self setViewControllers:@[viewController]
                                                  direction:direction
                                                   animated:YES
                                                 completion:nil];
            }

        }
    }
    _currIndex = index;
}

@end
