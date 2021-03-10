//
//  UIButton+ALExamplesExtensions.h
//  AnylineExamples
//
//  Created by Angela Brett on 09.10.20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ALExamplesExtensions)

+ (instancetype)roundedButton;
+ (CGFloat)roundedButtonHeight;
+ (CGFloat)socialButtonSize;
//the distance rounded buttons should be from the horizontal edges of the screen
+ (CGFloat)roundedButtonHorizontalMargin;

@end

NS_ASSUME_NONNULL_END
