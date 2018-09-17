//
//  ALScanFeedbackConfig.h
//  Anyline
//
//  Created by Daniel Albertini on 05.04.18.
//  Copyright © 2018 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALViewConstants.h"

@interface ALScanFeedbackConfig : NSObject

@property (nonatomic, assign) ALUIFeedbackStyle style;
@property (nonatomic, assign) ALUIVisualFeedbackAnimation animation;

@property (nullable, nonatomic, strong) UIColor *strokeColor;
@property (nullable, nonatomic, strong) UIColor *fillColor;

@property (nonatomic, assign) NSInteger strokeWidth;
@property (nonatomic, assign) NSInteger cornerRadius;
@property (nonatomic, assign) NSInteger animationDuration;
@property (nonatomic, assign) NSInteger redrawTimeout;

@property (nonatomic, assign) BOOL beepOnResult;
@property (nonatomic, assign) BOOL vibrateOnResult;
@property (nonatomic, assign) BOOL blinkAnimationOnResult;

- (instancetype _Nullable)initWithDictionary:(NSDictionary * _Nonnull)configDict;
- (instancetype _Nullable)initWithStyle:(ALUIFeedbackStyle)style
                              animation:(ALUIVisualFeedbackAnimation)animation
                            strokeColor:(UIColor * _Nonnull)strokeColor
                              fillColor:(UIColor * _Nonnull)fillColor
                            strokeWidth:(NSInteger)strokeWidth
                           cornerRadius:(NSInteger)cornerRadius
                      animationDuration:(NSInteger)animationDuration
                          redrawTimeout:(NSInteger)redrawTimeout
                           beepOnResult:(BOOL)beepOnResult
                        vibrateOnResult:(BOOL)vibrateOnResult
                 blinkAnimationOnResult:(BOOL)blinkAnimationOnResult;

+ (_Nonnull instancetype)defaultScanFeedbackConfig;

@end
