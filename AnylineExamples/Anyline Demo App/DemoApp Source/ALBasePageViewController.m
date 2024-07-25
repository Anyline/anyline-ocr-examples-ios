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
#import "AnylineExamples-Swift.h"

@interface ALBasePageViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) NSLayoutConstraint *segmentedControlHeightAnchor;

@end


@implementation ALBasePageViewController

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    }
    return _pageViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHeader];
    [self setupNavbarButtons];
    [self setupPageView];
    [self addConstraints];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updatePageControlLocation];
}

- (BOOL)hidesBottomBarWhenPushed {
    return NO;
}

- (void)setupHeader {
    
    self.view.backgroundColor = [UIColor AL_BackgroundColor];
    
    self.header = [[UIView alloc] init];
    [self.view addSubview:self.header];
    self.header.translatesAutoresizingMaskIntoConstraints = NO;
    self.header.backgroundColor = [UIColor AL_BackgroundColor];
    
    self.anylineLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AnylineLogo"]];
    [self.anylineLogoImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.header addSubview:self.anylineLogoImageView];
    self.anylineLogoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setupSegmentControl];
    [self.header addSubview:self.segmentedControl];
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.segmentedControl addTarget:self action:@selector(jumpToPage:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupNavbarButtons {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor AL_BackButton]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor AL_BackButton]];
}

- (void)addConstraints {
    
    // header height is precomputed based on screen size, we will let logo image autoadjust
    CGFloat logoHeight = 76.0f;
    CGFloat logoHeightToWidthRatio = 99.0f/375.0;
    CGFloat segmentedControlHeight = [self shouldShowSegmentedControl] ? 30 : 0;
    CGFloat logoToSegmentedMargin = -10.0f; // actually pull the two closer together
    CGFloat segmentedLeftMargin = 15;
    
    // Header
    self.headerTopToViewTopAnchor = [self.header.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor];
    self.headerTopToViewTopAnchor.active = YES;
    
    [self.header.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.header.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    
    // Logo
    [self.anylineLogoImageView.topAnchor constraintEqualToAnchor:self.header.topAnchor constant:0].active = YES;
    [self.anylineLogoImageView.heightAnchor constraintEqualToConstant:logoHeight].active = YES;
    [self.anylineLogoImageView.widthAnchor constraintEqualToAnchor:self.header.widthAnchor multiplier:logoHeightToWidthRatio].active = YES;
    [self.anylineLogoImageView.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor].active = YES;

    // Segmented control (not shown on 'bundle' version of the app)
    [self.segmentedControl.topAnchor constraintEqualToAnchor:self.anylineLogoImageView.bottomAnchor constant:logoToSegmentedMargin].active = YES;
    [self.segmentedControl.leftAnchor constraintEqualToAnchor:self.header.leftAnchor constant:segmentedLeftMargin].active = YES;
    [self.segmentedControl.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor].active = YES;
    [self.segmentedControl.bottomAnchor constraintEqualToAnchor:self.header.bottomAnchor].active = YES;
    
    self.segmentedControlHeightAnchor = [self.segmentedControl.heightAnchor constraintEqualToConstant:segmentedControlHeight];
    self.segmentedControlHeightAnchor.active = YES;
    
    UIView *pageView = self.pageViewController.view;
    pageView.translatesAutoresizingMaskIntoConstraints = NO;
    [pageView.topAnchor constraintEqualToAnchor:self.header.bottomAnchor].active = YES;
    [pageView.leftAnchor constraintEqualToAnchor:self.header.leftAnchor].active = YES;
    [pageView.rightAnchor constraintEqualToAnchor:self.header.rightAnchor].active = YES;
    [pageView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

- (CGRect)headerFrame {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat topPadding = window.safeAreaInsets.top;
    CGFloat leftPadding = window.safeAreaInsets.left;
    
    // multiplied to screen width to partially determine header height
    // (logo image + segmented control)
    CGFloat heightToWidthRatio = 0.25f;
    
    CGFloat headerHeight = self.view.frame.size.width * heightToWidthRatio;
    
    return CGRectMake(leftPadding,
                      self.view.frame.origin.y + topPadding,
                      self.view.frame.size.width,
                      headerHeight);
}

// the store app has it set to YES
- (BOOL)shouldShowSegmentedControl {
    return NO;
}

- (void)setupSegmentControl {
#if __has_include("AppDelegate_store.h")
    self.segmentedControl = [[ALSegmentedControl alloc] initWithItems:@[]];
#else
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[]];
#endif
    if (@available(iOS 13, *)) {
        [self.segmentedControl setSelectedSegmentTintColor:[UIColor AL_White]];
    } else {
        [self customizeSegmentedControlWithColor:[UIColor AL_White]];
    }
    [self.segmentedControl setBackgroundColor:[UIColor AL_SegmentControlUnselected]];
    [self.segmentedControl setTitleTextAttributes:@{ NSForegroundColorAttributeName : UIColor.AL_SegmentControl} forState:UIControlStateNormal];
    [self.segmentedControl setTitleTextAttributes:@{ NSForegroundColorAttributeName : UIColor.AL_Black} forState:UIControlStateSelected];
    
    self.segmentedControl.hidden = ![self shouldShowSegmentedControl];
}

- (void)customizeSegmentedControlWithColor:(UIColor *)color {
    UIImage *tintColorImage = [self imageWithColor: color];
    [self.segmentedControl setBackgroundImage:tintColorImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentedControl setBackgroundImage:tintColorImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self.segmentedControl setBackgroundImage:tintColorImage forState:UIControlStateSelected|UIControlStateSelected barMetrics:UIBarMetricsDefault];
}

- (void)prepareSegmentedControl {
    [self.segmentedControl removeAllSegments];
    for (UIViewController *page in self.pages.reverseObjectEnumerator) {
        [self.segmentedControl insertSegmentWithTitle:[self titleOfExampleManager:page]
                                              atIndex:0 animated:NO];
    }
    [self highlightSegmentedControlAtIndex:0];
    
    self.segmentedControl.hidden = NO;
    self.segmentedControlHeightAnchor.constant = 30;
}

- (void)setupPageView {
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view addSubview:self.pageViewController.view];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
}

- (void)updatePageControlLocation {
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UIPageControl class]]) {
            //remove pageControl
            [view removeFromSuperview];
        }
    }
}

#pragma mark - UIPageViewController

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
    return viewController.title; // "Scanners" or "Industries" (APP-169)
}

- (NSString *)titleOfExampleManagerOnIndex:(NSInteger)idx {
    return [self titleOfExampleManager:[_pages objectAtIndex:idx]];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed) {
        NSInteger idx = [self.pages indexOfObject:pageViewController.viewControllers[0]];
        NSParameterAssert(idx != NSNotFound);
        if (self.currIndex != idx) {
            self.currIndex = idx;
            
            self.title = [self titleOfExampleManagerOnIndex:self.currIndex];
            [self highlightSegmentedControlAtIndex:self.currIndex];
        }

    }
}

- (void)jumpToPage:(UISegmentedControl *)sender {
    NSInteger tag = sender.selectedSegmentIndex;
    if (tag >= 0 && tag < [_pages count]) {
        BOOL different = tag != self.currIndex;
        if (different) {
            [self gotoPage:tag];
            self.title = [self titleOfExampleManagerOnIndex:tag];
        }

#if __has_include("AppDelegate_store.h")
        if ([_pages[tag] conformsToProtocol:@protocol(ALPageViewController)]) {
            [((id<ALPageViewController>)_pages[tag]) selectedMeWithAgain:!different];
        }
#endif
    }
    [[[sender subviews] objectAtIndex:[sender selectedSegmentIndex]] setTintColor:[UIColor AL_White]];
}

- (void)gotoPage:(NSInteger)index {
    UIViewController *viewController = _pages[index];
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionReverse;
    if (_currIndex <= index) {
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    [self.pageViewController setViewControllers:@[viewController]
                                      direction:direction
                                       animated:YES
                                     completion:nil];
    _currIndex = index;
}

#pragma mark - Utility Methods

- (void)highlightSegmentedControlAtIndex:(NSInteger)index {
    self.segmentedControl.selectedSegmentIndex = index;
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

// TODO: should turn this into an extension method for UIColor (and remove the duplicates)
- (UIImage *)imageWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, self.segmentedControl.bounds.size.width, self.segmentedControl.bounds.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
