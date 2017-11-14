//
//  ALVisualFeedbackOverlay.h
//  Anyline
//
//  Created by David Dengg on 13.01.16.
//  Copyright © 2016 9Yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALSquare.h"
#import "ALPolygon.h"
#import "ALUIConfiguration.h"

@interface ALVisualFeedbackOverlay : UIView

@property (nullable, nonatomic, copy) ALPolygon *polygon;
@property (nullable, nonatomic, copy) ALSquare *square;
@property (nullable, nonatomic, copy) NSArray *contours;

@property (nonatomic, assign) NSInteger visualFeedbackCornerRadius;
@property (nonatomic, assign) NSInteger cornerRadius;
@property (nonatomic, assign) NSInteger visualFeedbackRedrawTimeout;
@property (nonatomic, assign) ALUIFeedbackStyle feedbackStyle;
@property (nonatomic, assign) ALUIVisualFeedbackAnimation visualFeedbackAnimation;
@property (nullable, nonatomic, strong) UIColor *visualFeedbackStrokeColor;
@property (nullable, nonatomic, strong) UIColor *visualFeedbackFillColor;
@property (nonatomic, assign) NSInteger visualFeedbackAnimationDuration;
@property (nullable, nonatomic, copy) UIBezierPath *cutoutPath;
@property (nonatomic, assign) NSInteger visualFeedbackStrokeWidth;

- (_Nullable instancetype)initWithFrame:(CGRect)frame
             visualFeedbackCornerRadius:(NSInteger)visualFeedbackCornerRadius
                           cornerRadius:(NSInteger)cornerRadius
            visualFeedbackRedrawTimeout:(NSInteger)visualFeedbackRedrawTimeout
                          feedbackStyle:(ALUIFeedbackStyle)feedbackStyle
                visualFeedbackAnimation:(ALUIVisualFeedbackAnimation)visualFeedbackAnimation
              visualFeedbackStrokeColor:(UIColor * _Nonnull)visualFeedbackStrokeColor
                visualFeedbackFillColor:(UIColor * _Nonnull)visualFeedbackFillColor
        visualFeedbackAnimationDuration:(NSInteger)visualFeedbackAnimationDuration
                             cutoutPath:(UIBezierPath * _Nonnull)cutoutPath
              visualFeedbackStrokeWidth:(NSInteger)visualFeedbackStrokeWidth;

- (void)cancelFeedback;

@end
