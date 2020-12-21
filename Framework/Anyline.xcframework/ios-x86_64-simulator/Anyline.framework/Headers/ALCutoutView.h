//
//  ALCutoutView.h
//  AnylineExamples
//
//  Created by Matthias Gasser on 01/04/15.
//  Copyright (c) 2019 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ALViewConstants.h"

/**
 *  The ALCutoutView is used to draw the cutout on the phone screen specified in the ALUIConfiguration
 */
@interface ALCutoutView : UIView

@property (nonatomic, assign) CGFloat cutoutWidthPercent;
@property (nonatomic, assign) CGFloat cutoutMaxPercentWidth;
@property (nonatomic, assign) CGFloat cutoutMaxPercentHeight;

@property (nonatomic, assign) CGPoint cutoutOffset;

@property (nonatomic, assign) NSInteger cornerRadius;
@property (nonatomic, assign) NSInteger strokeWidth;

@property (nonatomic, assign) ALCutoutAlignment cutoutAlignment;

@property (nullable, nonatomic, copy) UIBezierPath *cutoutPath;

@property (nullable, nonatomic, strong) UIColor *cutoutBackgroundColor;
@property (nullable, nonatomic, strong) UIColor *strokeColor;
@property (nullable, nonatomic, strong) UIColor *feedbackStrokeColor;

@property (nullable, nonatomic, strong) UIImage *overlayImage;

- (_Nullable instancetype)initWithFrame:(CGRect)frame
                     cutoutWidthPercent:(CGFloat)cutoutWidthPercent
                  cutoutMaxPercentWidth:(CGFloat)cutoutMaxPercentWidth
                 cutoutMaxPercentHeight:(CGFloat)cutoutMaxPercentHeight
                           cutoutOffset:(CGPoint)cutoutOffset
                           cornerRadius:(NSInteger)cornerRadius
                            strokeWidth:(NSInteger)strokeWidth
                        cutoutAlignment:(ALCutoutAlignment)cutoutAlignment
                             cutoutPath:(UIBezierPath * _Nonnull)cutoutPath
                  cutoutBackgroundColor:(UIColor * _Nonnull)cutoutBackgroundColor
                            strokeColor:(UIColor * _Nonnull)strokeColor
                    feedbackStrokeColor:(UIColor * _Nonnull)feedbackStrokeColor
                           overlayImage:(UIImage * _Nonnull)overlayImage;

/**
 *  Returns the cutout location inside the view.
 *
 *  @return  CGRect representing the cutout inside the CutoutView.
 */
- (CGRect)cutoutRectScreen;

- (void)drawCutout:(BOOL)feedbackMode;

- (void)calculateAndDrawCutout;

@end
