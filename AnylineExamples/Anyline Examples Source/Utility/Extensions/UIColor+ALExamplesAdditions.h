//
//  UIColor+ALExamplesAdditions.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 30/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBA(r, g, b, a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface UIColor (ALExamplesAdditions)

+ (UIColor *)AL_examplesBlue;
+ (UIColor *)AL_White;
+ (UIColor *)AL_Black;
+ (UIColor *)AL_errorLabelRed;
+ (UIColor *)AL_devTestModeColor;
+ (UIColor *)AL_Gray;
+ (UIColor *)AL_SectionGridBG;
+ (UIColor *)AL_SectionLabel;
+ (UIColor *)AL_NonSelectedToolBarItem;
+ (UIColor *)AL_BackgroundColor;
+ (UIColor *)AL_LabelWhiteBlack;
+ (UIColor *)AL_LabelBlackWhite;
+ (UIColor *)AL_NavigationBG;
+ (UIColor *)AL_SegmentControl;
+ (UIColor *)AL_SegmentControlUnselected;
+ (UIColor *)AL_Separator;
+ (UIColor *)AL_BackButton;
+ (UIColor *)AL_NoResultLabel;


+ (UIColor *)AL_colorWithHexString:(NSString *)hexString;

@end
