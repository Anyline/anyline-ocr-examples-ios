//
//  ALAwardsView.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 19/07/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ALAwardType) {
    ALAwardType1 = 1,
    ALAwardType10 = 10,
    ALAwardType30 = 30,
    ALAwardType50 = 50,
    ALAwardType80 = 80,
    ALAwardType100 = 100
};

typedef void(^ALTouchBlock)(void);

@interface ALAwardsView : UIView

@property (nonatomic, assign) ALAwardType awardType;

- (void)setTouchDownBlock:(ALTouchBlock)compblock;

@end
