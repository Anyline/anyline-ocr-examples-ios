//
//  ALMeterReadingView.m
//  eScan
//
//  Created by Luka Mirosevic on 26/03/2015.
//  Copyright (c) 2015 Daniel Albertini. All rights reserved.
//

#import "ALMeterReadingView.h"

#import <Anyline/Anyline.h>
#import "ALUtils.h"
#import "UIView+ALExamplesAdditions.h"

#import "ALMeterReading.h"

static NSTimeInterval const kModeChangeAnimationDuration =      0.2;

static CGFloat const kBackgroundTrackAlpha =                    0.3;
static CGFloat const kHorizontalDigitSpacing =                  4.60;
static CGSize const kDigitSize =                                (CGSize){26, 36};
static CGFloat const kEditModeTrackHeight =                     180;
static CGFloat const kEditModeVerticalDigitSpacing =            -4;

#define kFont                                                   [UIFont fontWithName:@"HelveticaNeue-Medium" size:16 ]
#define kTextColor                                              [UIColor whiteColor]
#define kDigitBackgroundBoxImage                                [UIImage imageNamed:@"digit_box_grey"]
#define kDigitBackgroundBoxImageRed                             [UIImage imageNamed:@"digit_box_red"]
#define kBackgroundTrackImage                                   [UIImage imageNamed:@"meter_track_bg"]

typedef void (^ViewConfigurator)(UILabel *digitLabel, NSInteger value);
typedef void(^ValueDidChangeBlock)(NSInteger newValue);


@interface ALDigitCell : UITableViewCell

@property (nonatomic, strong) UILabel *digitLabel;

@end

@implementation ALDigitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
        
        self.digitLabel = [UILabel new];
        [self.contentView addSubview:self.digitLabel];
        self.digitLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.digitLabel.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[digitLabel]|" options:0 metrics:nil
                                                                                            views:@{@"digitLabel" : self.digitLabel}]];// full width within cell
        [self.digitLabel.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[digitLabel]|" options:0 metrics:nil
                                                                                            views:@{@"digitLabel" : self.digitLabel}]];// full height within cell
        
    }
    return self;
}

@end


@interface ALInfinitePagingTilingScrollView : UIView <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat                           jumpDistance;
@property (copy, nonatomic) ViewConfigurator                    viewConfigurator;
@property (assign, nonatomic) CGFloat                           verticalSpacing;
@property (nonatomic, strong) UITableView                       *digitsTableView;
@property (nonatomic) NSInteger                                 currentValue;

@property (copy, nonatomic) ValueDidChangeBlock                 valueDidChangeBlock;

@end

@implementation ALInfinitePagingTilingScrollView

#pragma mark - ALInfinitePagingTilingScrollView: API

- (instancetype)initWithFrame:(CGRect)frame contentHeight:(CGFloat)contentHeight jumpDistance:(CGFloat)jumpDistance verticalSpacing:(CGFloat)verticalSpacing viewConfigurator:(ViewConfigurator)viewConfigurator valueDidChangeBlock:(ValueDidChangeBlock)block {
    if (self = [super initWithFrame:frame]) {
        
        self.jumpDistance = jumpDistance;
        self.viewConfigurator = viewConfigurator;
        self.verticalSpacing = verticalSpacing;
        self.valueDidChangeBlock = block;
        
        // setup appearance
        self.backgroundColor = [UIColor clearColor];
        
        // setup table view
        self.digitsTableView = [UITableView new];
        [self addSubview:self.digitsTableView];
        self.digitsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[digitsTableView]|" options:0 metrics:nil
                                                                                views:@{@"digitsTableView" : self.digitsTableView}]];// full width
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[digitsTableView]|" options:0 metrics:nil
                                                                       views:@{@"digitsTableView" : self.digitsTableView}]];// full height
        
        self.digitsTableView.contentInset = UIEdgeInsetsZero;
        self.digitsTableView.backgroundColor = [UIColor clearColor];
        self.digitsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.digitsTableView.showsVerticalScrollIndicator = NO;
        self.digitsTableView.showsHorizontalScrollIndicator = NO;
        self.digitsTableView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        // set delegate, dataSourece
        [self.digitsTableView setDelegate:self];
        [self.digitsTableView setDataSource:self];
        
        // setup cell reuse
        [self.digitsTableView registerClass:[ALDigitCell class] forCellReuseIdentifier:NSStringFromClass([ALDigitCell class])];
    }
    
    return self;
}

- (void)scrollToValue:(NSInteger)value animated:(BOOL)animated {
    self.currentValue = value;
    NSInteger targetRow = value + [self middleRow];
    [self.digitsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:targetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
}

#pragma mark - Overrides

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self scrollToValue:self.currentValue animated:NO];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // use a huge number just to make sure the user will never scroll from the middle to one of the edges
    // when the tableView stops decelerating reset to a point near the middle again
    return 10000;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDigitSize.height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ALDigitCell *cell = (ALDigitCell *) [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ALDigitCell.class)];
    
    // let viewConfigurator do the styling
    if (self.viewConfigurator) self.viewConfigurator(cell.digitLabel, indexPath.row % 10);
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Private: Determining the current value

- (NSInteger)currentlyDisplayedValue {
    // the cells in the ALInfinitePagingTilingScrollView have a value of row % 10
    // so the value of the middle/focused cell is simply it's indexPath.row component modulo 10  
    NSIndexPath *middleRowPath = [self.digitsTableView indexPathForRowAtPoint:CGPointMake(self.bounds.size.width/2.0, self.digitsTableView.contentOffset.y + self.bounds.size.height/2.0)];
    return middleRowPath.row % 10;
}

/**
 *  Returns the row with the value 0 closest to the middle of number of rows
 */
- (NSInteger)middleRow {
    NSInteger numberOfRows = [self.digitsTableView numberOfRowsInSection:0];
    return (numberOfRows / 2 - ((numberOfRows/2) % 10));
}

/**
 *  Shifts the table view back to the approximate middle
 */
- (void)scrollBackToMiddle {
    [self scrollToValue:[self currentlyDisplayedValue] animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSIndexPath *middleRowPath = [self.digitsTableView indexPathForRowAtPoint:CGPointMake(self.bounds.size.width/2.0, self.digitsTableView.contentOffset.y + self.bounds.size.height/2.0)];
    
    // adjust the target offset
    CGFloat cellHeight = (kDigitSize.height);
    CGFloat padding = self.bounds.size.height - cellHeight;
    *targetContentOffset = CGPointMake(targetContentOffset->x, middleRowPath.row * cellHeight - padding * 0.5);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollBackToMiddle];
    [self _triggerValueChangedBlock];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollBackToMiddle];
        [self _triggerValueChangedBlock];
    }
}

- (void)_triggerValueChangedBlock {
    self.currentValue = [self currentlyDisplayedValue];
    if (self.valueDidChangeBlock) self.valueDidChangeBlock([self currentlyDisplayedValue]);
}
                           
@end




@interface ALMeterReadingView ()

@property (strong, nonatomic, readwrite) ALMeterReading         *originalMeterReading;

@property (strong, nonatomic) NSMutableArray                    *scrollViews;
@property (strong, nonatomic) NSMutableArray                    *trackBackgroundViews;

@end

@implementation ALMeterReadingView

#pragma mark - CA

- (void)setMeterReading:(ALMeterReading *)meterReading {
    _meterReading = meterReading;
    [self _redrawSubviews];
}

#pragma mark - Overrides

- (CGSize)intrinsicContentSize {
    CGFloat width = (self.meterReading.significantDigitsCount * kDigitSize.width) + (self.meterReading.significantDigitsCount > 1 ? (self.meterReading.significantDigitsCount - 1) * kHorizontalDigitSpacing : 0);
    CGFloat height = self.editingMode ? kEditModeTrackHeight : kDigitSize.height;
    
    return CGSizeMake(width, height);
}

#pragma mark - Public

- (instancetype)initWithMeterReading:(ALMeterReading *)meterReading {
    if (self = [super init]) {
        self.originalMeterReading = meterReading;
        _meterReading = [meterReading copy];
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        self.editingMode = YES;
        
        [self _redrawSubviews];
    }
    
    return self;
}

- (void)setEditingMode:(BOOL)editingMode {
    [self setEditingMode:editingMode animated:NO];
}

- (void)setEditingMode:(BOOL)editingMode animated:(BOOL)animated {
    _editingMode = editingMode;
    
    VoidBlock animatableChanges = ^{
        // lock the user interaction when not in editing mode
        self.userInteractionEnabled = editingMode;
        
        // hide the background track when not in editing mode
        for (UIView *trackBackgroundView in self.trackBackgroundViews) {
            trackBackgroundView.hidden = !editingMode;
        }
        
        // recalculate our size, this will then animate nicely if we trigger the autolayout pass in an animation block
        [self invalidateIntrinsicContentSize];
    };
    
    if (animated) {
        [UIView animateWithDuration:kModeChangeAnimationDuration animations:^{
            animatableChanges();
            [self.superview layoutIfNeeded];
        }];
    }
    else {
        animatableChanges();
    }
}

#pragma mark - Private

- (void)_displayValueForCurrentMeterReadingAnimated:(BOOL)animated {
    for (NSInteger i = 0; i < self.meterReading.significantDigitsCount + self.meterReading.insignificantDigitsCount; i++) {
        ALInfinitePagingTilingScrollView *scrollView = self.scrollViews[i];
        
        NSInteger value = 0;
        if (i < self.meterReading.significantDigitsCount) {
            value = [[self.meterReading.readingString substringWithRange:NSMakeRange(i, 1)] integerValue];
        } else {
            value = [[self.meterReading.readingString substringWithRange:NSMakeRange(i+1, 1)] integerValue];
        }
        
        [scrollView scrollToValue:value animated:animated];
    }
}

- (void)_redrawSubviews {
    // destroy all the views we have already
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self removeAllSubviews];
    self.scrollViews = [NSMutableArray new];
    self.trackBackgroundViews = [NSMutableArray new];
    
    CGFloat commaOffset = 0;
    // draw all of the tracks, one by one
    for (NSInteger i = 0; i < self.meterReading.significantDigitsCount + self.meterReading.insignificantDigitsCount; i++) {
        
        if (i == self.meterReading.significantDigitsCount) {
            commaOffset = 10;
            
            UILabel *comma = TranslateAutoresizing([[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 35)]);
            comma.text = [NSNumberFormatter new].decimalSeparator;
            comma.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:36];
            comma.textColor = [UIColor colorWithWhite:0.15 alpha:1];
//            comma.textAlignment = NSTextAlignmentCenter;
            
            [self addSubview:comma];
            
            CGFloat leftOffset = i * (kHorizontalDigitSpacing + kDigitSize.width) - 2;
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftOffset-[comma(==trackWidth)]"
                                                                         options:0
                                                                         metrics:@{@"leftOffset": @(leftOffset), @"trackWidth": @(10)}
                                                                           views:NSDictionaryOfVariableBindings(comma)]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[comma(==trackHeight)]"
                                                                         options:0
                                                                         metrics:@{@"trackHeight": @(kEditModeTrackHeight)}
                                                                           views:NSDictionaryOfVariableBindings(comma)]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:comma attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.f]];
        }
        
        UIView *trackContainerView = TranslateAutoresizing([UIView new]);
        trackContainerView.accessibilityLabel = @"trackContainerView";
        [self addSubview:trackContainerView];
        // autolayout
        CGFloat leftOffset = i * (kHorizontalDigitSpacing + kDigitSize.width) + commaOffset;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftOffset-[trackContainerView(==trackWidth)]"
                                                                     options:0
                                                                     metrics:@{@"leftOffset": @(leftOffset), @"trackWidth": @(kDigitSize.width)}
                                                                       views:NSDictionaryOfVariableBindings(trackContainerView)]];// fixed left, fixed width
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[trackContainerView(==trackHeight)]"
                                                                     options:0
                                                                     metrics:@{@"trackHeight": @(kEditModeTrackHeight)}
                                                                       views:NSDictionaryOfVariableBindings(trackContainerView)]];// fixed height
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:trackContainerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.f]];
        
//        // if it's the last one, then pin it to the end horizontally
        if (i == self.meterReading.significantDigitsCount + self.meterReading.insignificantDigitsCount - 1) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[trackContainerView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(trackContainerView)]];// pin to right
        }
    
        
        // add the background track image if we have one
        UIImageView *backgroundTrackImageView = TranslateAutoresizing([[UIImageView alloc] initWithImage:kBackgroundTrackImage]);
        [self.trackBackgroundViews addObject:backgroundTrackImageView];
        backgroundTrackImageView.alpha = kBackgroundTrackAlpha;
        [trackContainerView addSubview:backgroundTrackImageView];
        // autolayout
        [trackContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundTrackImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundTrackImageView)]];// full width
        [trackContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundTrackImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundTrackImageView)]];// full height
        
        // add the digit backgroud box
        UIImageView *digitBackgroundBoxImageView = TranslateAutoresizing([[UIImageView alloc] initWithImage:kDigitBackgroundBoxImage]);
        
        if (i >= self.meterReading.significantDigitsCount) {
            digitBackgroundBoxImageView = TranslateAutoresizing([[UIImageView alloc] initWithImage:kDigitBackgroundBoxImageRed]);
        }
        
        [trackContainerView addSubview:digitBackgroundBoxImageView];
        // autolayout
        [trackContainerView addConstraint:[NSLayoutConstraint constraintWithItem:digitBackgroundBoxImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:trackContainerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];// centered horizontally
        [trackContainerView addConstraint:[NSLayoutConstraint constraintWithItem:digitBackgroundBoxImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:trackContainerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];// centered vertically

        // create a scrollView container view, we need this for applying our alpha mask to (otherwise the alpha mask would scroll with the scrollView contents, which is not what we want
        UIView *scrollViewContainerView = TranslateAutoresizing([UIView new]);
        [trackContainerView addSubview:scrollViewContainerView];
        // autolayout
        [trackContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollViewContainerView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollViewContainerView)]];// full width
        [trackContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollViewContainerView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollViewContainerView)]];// full height
        
        // add an alpha mask to the scrollViewContainerView
        UIImage *maskImage = [UIImage imageNamed:@"track_digits_alpha_mask"];
        CALayer *maskLayer = [CALayer layer];
        [scrollViewContainerView layoutIfNeeded];// we need to force an autolayout pass here so that we can get the bounds on the next line
        maskLayer.frame = scrollViewContainerView.bounds;
        maskLayer.contents = (id)maskImage.CGImage;
        scrollViewContainerView.layer.mask = maskLayer;
        
        // add the scrollView
        CGFloat fullCycleDistance = 10 * (kEditModeVerticalDigitSpacing + kDigitSize.height);
        ALInfinitePagingTilingScrollView *scrollView = TranslateAutoresizing([[ALInfinitePagingTilingScrollView alloc] initWithFrame:CGRectZero contentHeight:100000*fullCycleDistance jumpDistance:fullCycleDistance verticalSpacing:kEditModeVerticalDigitSpacing viewConfigurator:^(UILabel *digitLabel, NSInteger value) {
            
            digitLabel.font = kFont;
            digitLabel.textColor = kTextColor;
            digitLabel.text = [NSString stringWithFormat:@"%ld", (long)value];
            digitLabel.textAlignment = NSTextAlignmentCenter;
            
        } valueDidChangeBlock:^(NSInteger newValue) {
            
            if (i < self.meterReading.significantDigitsCount) {
                self.meterReading.result = [self.meterReading.result stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:[@(newValue) stringValue]];
            } else {
                self.meterReading.result = [self.meterReading.result stringByReplacingCharactersInRange:NSMakeRange(i + 1, 1) withString:[@(newValue) stringValue]];
            }
            
            
        }]);
        [self.scrollViews addObject:scrollView];
        [scrollViewContainerView addSubview:scrollView];
        // autolayout
        [scrollViewContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];// full width
        [scrollViewContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];// full height
    }
    
    [self _displayValueForCurrentMeterReadingAnimated:NO];
}

@end
