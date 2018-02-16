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
    CGRect pageViewFrame = [[UIScreen mainScreen] applicationFrame];
    pageViewFrame = CGRectMake(pageViewFrame.origin.x, pageViewFrame.origin.y + self.navigationController.navigationBar.frame.size.height, pageViewFrame.size.width, pageViewFrame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.view.frame = pageViewFrame;
    
    CGRect headerFrame = [[UIScreen mainScreen] applicationFrame];
    headerFrame = CGRectMake(headerFrame.origin.x, headerFrame.origin.y + self.navigationController.navigationBar.frame.size.height, headerFrame.size.width, headerFrame.size.width*0.25);
    
    self.header = [[UIView alloc] initWithFrame:headerFrame];
    self.header.backgroundColor = [UIColor whiteColor];
    
    self.anylineWhite = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AnylineLogo"]];
    [self.header addSubview:self.anylineWhite];
    self.anylineWhite.center = CGPointMake(self.header.center.x, headerFrame.size.height/2 - 10);
    
    CGRect frame = CGRectMake(0, headerFrame.size.height - 22, headerFrame.size.width, 18);
    self.tabView = [[UIView alloc] initWithFrame:frame];
    
    [self.header addSubview:self.tabView];
    [self.view addSubview:self.header];
}

- (void)setupTabbar {
    //Create Tabbar for each page
    for (int i = 0; i < [self.pages count]; i++) {
        CGFloat tabWidth = self.tabView.frame.size.width/[self.pages count];
        UILabel *tab = [[UILabel alloc] initWithFrame:CGRectMake(tabWidth*i, 0, tabWidth, self.tabView.frame.size.height)];
        tab.font = [UIFont AL_proximaSemiboldWithSize:18];
        tab.textAlignment = NSTextAlignmentCenter;
        tab.text = [self titleOfExampleManagerOnIndex:i];
        [tab setUserInteractionEnabled:YES];
        [tab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToPage:)]];
        tab.tag = i;
        
        tab.adjustsFontSizeToFitWidth = YES;
        
        [self.tabView addSubview:tab];
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
    return YES;
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

- (NSString *)titleOfExampleManagerOnIndex:(NSInteger)idx {
    ALGridCollectionViewController *vc = (ALGridCollectionViewController *)[_pages objectAtIndex:idx];
    return vc.exampleManager.title;
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
    for (int i = 0; i < [self.pages count]; i++) {
        UILabel *tab = [self.tabView.subviews objectAtIndex:i];
        if (i == index) {
            tab.textColor = [UIColor AL_examplesBlue];
            [tab.layer addSublayer:[self addBorder:UIRectEdgeBottom color:[UIColor AL_examplesBlueWithAlpha:0.9] thickness:2.5f frame:tab.frame padding:10.0f]];
            
        } else if ([[tab.layer sublayers] count] > 0){
            tab.textColor = [UIColor blackColor];
            //remove all sublayers
            for (CALayer *subLayer in [tab.layer sublayers]) {
                [subLayer removeFromSuperlayer];
            }
        }
    }
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



- (void)jumpToPage:(UITapGestureRecognizer *) sender {
    NSInteger tag = ((UILabel *) sender.view).tag;
    if (tag >= 0 && tag < [_pages count] && tag != self.currIndex) {
        [self gotoPage:tag];
        [self highlightTabAtIndex:tag];
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
