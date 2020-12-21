//
//  UIColor+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 30/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "UIColor+ALExamplesAdditions.h"

@implementation UIColor (ALExamplesAdditions)

+ (UIColor *)AL_examplesBlue {
    return RGBA(0, 153, 255, 1);
}

+ (UIColor *)AL_examplesBlueWithAlpha:(CGFloat)alpha {
    return RGBA(0, 153, 255, alpha);
}

+ (UIColor *)AL_errorLabelRed {
    return RGBA(217, 43, 10, 1);
}

+ (UIColor *)AL_devTestModeColor {
    return RGBA(194, 117, 255, 1);
}

+ (UIColor *)AL_gray {
    return RGBA(245, 245, 245, 1);
}

@end
