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

@property (nonatomic, assign) CGFloat cutoutWidthPercent;
@property (nonatomic, assign) CGFloat cutoutMaxPercentWidth;
@property (nonatomic, assign) CGFloat cutoutMaxPercentHeight;
@property (nonatomic, assign) ALCutoutAlignment cutoutAlignment;

@property (nonatomic, assign) CGPoint cutoutOffset;
@property (nullable, nonatomic, copy) UIBezierPath *cutoutPath;

@property (nonatomic, assign) CGSize cutoutCropPadding;
@property (nonatomic, assign) CGPoint cutoutCropOffset;

@property (nullable, nonatomic, strong) UIColor *cutoutBackgroundColor;
@property (nullable, nonatomic, strong) UIColor *strokeColor;
@property (nullable, nonatomic, strong) UIColor *feedbackStrokeColor;

@property (nullable, nonatomic, strong) UIImage *overlayImage;

@property (nonatomic, assign) NSInteger strokeWidth;
@property (nonatomic, assign) NSInteger cornerRadius;

@property (nullable, nonatomic, strong) UIColor *backgroundColorWithoutAlpha;
@property (nonatomic, assign) CGFloat backgroundAlpha;

- (void)setCutoutPathForWidth:(CGFloat)width height:(CGFloat)height;

- (void)updateCutoutWidth:(CGFloat)width;

- (instancetype _Nullable)initWithDictionary:(NSDictionary * _Nonnull)configDict;

@end
