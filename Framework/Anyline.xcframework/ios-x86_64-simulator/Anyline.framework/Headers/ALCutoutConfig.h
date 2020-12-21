//
//  ALCutoutConfig.h
//  Anyline
//
//  Created by Daniel Albertini on 05.04.18.
//  Copyright © 2018 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALViewConstants.h"

@interface ALCutoutConfig : NSObject

@property (nonatomic, assign) CGFloat widthPercent;
@property (nonatomic, assign) CGFloat maxPercentWidth;
@property (nonatomic, assign) CGFloat maxPercentHeight;
@property (nonatomic, assign) ALCutoutAlignment alignment;
@property (nonatomic, assign) BOOL usesAnimatedRect;

@property (nonatomic, assign) CGPoint offset;
@property (nullable, nonatomic, copy) UIBezierPath *path;

@property (nonatomic, assign) CGSize cropPadding;
@property (nonatomic, assign) CGPoint cropOffset;

@property (nullable, nonatomic, strong) UIColor *backgroundColor;
@property (nullable, nonatomic, strong) UIColor *strokeColor;
@property (nullable, nonatomic, strong) UIColor *feedbackStrokeColor;

@property (nullable, nonatomic, strong) UIImage *overlayImage;

@property (nonatomic, assign) NSInteger strokeWidth;
@property (nonatomic, assign) NSInteger cornerRadius;

@property (nonatomic, assign) ALCutoutAnimation animation;

- (void)setCutoutPathForWidth:(CGFloat)width height:(CGFloat)height;

- (void)updateCutoutWidth:(CGFloat)width;

+ (_Nonnull instancetype)defaultCutoutConfig;

- (instancetype _Nullable)initWithDictionary:(NSDictionary * _Nonnull)configDict;

- (instancetype _Nullable)initWithWidthPercent:(CGFloat)widthPercent
                               maxPercentWidth:(CGFloat)maxPercentWidth
                              maxPercentHeight:(CGFloat)maxPercentHeight
                                     alignment:(ALCutoutAlignment)alignment
                                        offset:(CGPoint)offset
                                          path:(UIBezierPath * _Nonnull)path
                                   cropPadding:(CGSize)cropPadding
                                    cropOffset:(CGPoint)cropOffset
                               backgroundColor:(UIColor * _Nonnull)backgroundColor
                                   strokeColor:(UIColor * _Nonnull)strokeColor
                           feedbackStrokeColor:(UIColor * _Nonnull)feedbackStrokeColor
                                  overlayImage:(UIImage * _Nullable)overlayImage
                                   strokeWidth:(NSInteger)strokeWidth
                                  cornerRadius:(NSInteger)cornerRadius
                                     animation:(ALCutoutAnimation)animation;

@end
