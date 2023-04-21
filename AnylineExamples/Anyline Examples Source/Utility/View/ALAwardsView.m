//
//  ALAwardsView.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 19/07/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALAwardsView.h"

#import "UIFont+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"

@interface ALAwardsView ()

@property (nonatomic, strong) UILabel *scannedTimes;

@property (nonatomic, strong) UIImageView *badge;

@property (nonatomic, strong) ALTouchBlock touchBlock;

@end

@implementation ALAwardsView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.center = self.center;
    if (@available(iOS 13.0, *)) {
        backgroundView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        backgroundView.backgroundColor = [UIColor whiteColor];
    }
    backgroundView.alpha = 0.9;
    backgroundView.layer.cornerRadius = 20;
    
    [self addSubview:backgroundView];
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundView.widthAnchor constraintEqualToConstant:300].active = YES;
    [backgroundView.heightAnchor constraintEqualToConstant:200].active = YES;
    
    UILabel *congrats = [[UILabel alloc] initWithFrame:CGRectZero];
    congrats.text = @"Congratulations!";
    congrats.textAlignment = NSTextAlignmentCenter;
    congrats.font = [UIFont AL_proximaBoldWithSize:21];
    congrats.textColor = [UIColor AL_examplesBlue];
    [self addSubview:congrats];

    
    congrats.translatesAutoresizingMaskIntoConstraints = NO;
    [congrats.leadingAnchor constraintEqualToAnchor:backgroundView.leadingAnchor].active = YES;
    [congrats.topAnchor constraintEqualToAnchor:backgroundView.topAnchor constant:10].active = YES;
    [congrats.widthAnchor constraintEqualToAnchor:backgroundView.widthAnchor].active = YES;
    [congrats.heightAnchor constraintEqualToConstant:30].active = YES;
    
    self.badge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1scan"]];
    
    [self addSubview:self.badge];
    
    self.badge.translatesAutoresizingMaskIntoConstraints = NO;
    [self.badge.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.badge.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    self.scannedTimes = [[UILabel alloc] initWithFrame:CGRectZero];
    self.scannedTimes.text = @"You already scanned 10 times!";
    self.scannedTimes.textAlignment = NSTextAlignmentCenter;
    self.scannedTimes.font = [UIFont AL_proximaRegularWithSize:16];
    if (@available(iOS 13.0, *)) {
        self.scannedTimes.textColor = [UIColor labelColor];
    } else {
        self.scannedTimes.textColor = [UIColor blackColor];
    }
    self.scannedTimes.numberOfLines = 2;
    [self addSubview:self.scannedTimes];

    
    self.scannedTimes.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scannedTimes.leadingAnchor constraintEqualToAnchor:backgroundView.leadingAnchor].active = YES;
    [self.scannedTimes.topAnchor constraintEqualToAnchor:backgroundView.topAnchor constant:200 - 30].active = YES;
    [self.scannedTimes.widthAnchor constraintEqualToAnchor:backgroundView.widthAnchor].active = YES;
    [self.scannedTimes.heightAnchor constraintEqualToConstant:20].active = YES;
}

- (void)setAwardType:(ALAwardType)awardType {
    _awardType = awardType;

    switch (awardType) {
        case ALAwardType1:
            self.scannedTimes.text = @"Congratulations! You did your first scan!";
            break;
        case ALAwardType10:
            self.scannedTimes.text = @"Hurray! You scanned 10 times already!";
            break;
        case ALAwardType30:
            self.scannedTimes.text = @"Whoop whoop! 30 scans? Look at you!";
            break;
        case ALAwardType50:
            self.scannedTimes.text = @"Half of 100 scans? You're on a roll!";
            break;
        case ALAwardType80:
            self.scannedTimes.text = @"20 more scans and we are done!";
            break;
        case ALAwardType100:
        default:
            self.scannedTimes.text = @"We ran out of trophies, good job!";
            break;
    }

    self.badge.image = [UIImage imageNamed:[NSString stringWithFormat:@"%liscan",(unsigned long)awardType]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchBlock();
}

- (void)setTouchDownBlock:(ALTouchBlock)compblock {
    _touchBlock = compblock;
}

@end
