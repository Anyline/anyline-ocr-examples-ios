//
//  ALVisualFeedbackConfig.h
//  Anyline
//
//  Created by Daniel Albertini on 05.04.18.
//  Copyright © 2018 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALViewConstants.h"

@interface ALVisualFeedbackConfig : NSObject

@property (nonatomic, assign) ALUIFeedbackStyle feedbackStyle;
@property (nonatomic, assign) ALUIVisualFeedbackAnimation visualFeedbackAnimation;

@property (nullable, nonatomic, strong) UIColor *visualFeedbackStrokeColor;
@property (nullable, nonatomic, strong) UIColor *visualFeedbackFillColor;

@property (nonatomic, assign) NSInteger visualFeedbackStrokeWidth;
@property (nonatomic, assign) NSInteger visualFeedbackCornerRadius;
@property (nonatomic, assign) NSInteger visualFeedbackAnimationDuration;
@property (nonatomic, assign) NSInteger visualFeedbackRedrawTimeout;

- (instancetype _Nullable)initWithDictionary:(NSDictionary * _Nonnull)configDict;

@end
