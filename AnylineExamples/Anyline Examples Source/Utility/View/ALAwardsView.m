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
    UIView *white = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    
    white.center = self.center;
    white.backgroundColor = [UIColor whiteColor];
    white.alpha = 0.9;
    white.layer.cornerRadius = 20;
    
    [self addSubview:white];
    
    
    UILabel *congrats = [[UILabel alloc] initWithFrame:CGRectMake(white.frame.origin.x, white.frame.origin.y + 10, white.frame.size.width, 30)];
    congrats.text = @"Congratulation!";
    congrats.textAlignment = NSTextAlignmentCenter;
    congrats.font = [UIFont AL_proximaBoldWithSize:21];
    congrats.textColor = [UIColor AL_examplesBlue];
    [self addSubview:congrats];
    
    self.badge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1scan"]];
    self.badge.center = white.center;
    [self addSubview:self.badge];
    
    self.scannedTimes = [[UILabel alloc] initWithFrame:CGRectMake(white.frame.origin.x, white.frame.origin.y + white.frame.size.height - 30, white.frame.size.width, 20)];
    self.scannedTimes.text = @"You already scanned 10 times!";
    self.scannedTimes.textAlignment = NSTextAlignmentCenter;
    self.scannedTimes.font = [UIFont AL_proximaRegularWithSize:16];
    self.scannedTimes.textColor = [UIColor blackColor];
    self.scannedTimes.numberOfLines = 2;
    [self addSubview:self.scannedTimes];
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
