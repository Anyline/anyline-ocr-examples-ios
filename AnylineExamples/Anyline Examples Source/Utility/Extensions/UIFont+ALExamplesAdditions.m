//
//  UIFont+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 30/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "UIFont+ALExamplesAdditions.h"

@implementation UIFont (ALExamplesAdditions)


//todo: change this to accept a UIFontTextStyle as the parameter instead of an absolute size, and use UIFontMetrics -scaledFontForFont: so we can support Dynamic Type
+ (UIFont *)AL_proximaBoldWithSize:(CGFloat)size {
    NSString *fontName = @"ProximaNova-Bold";
    return ([UIFont isFontAvailable:fontName size:size]) ? [UIFont fontWithName:fontName size:size] : [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

+ (UIFont *)AL_proximaSemiboldWithSize:(CGFloat)size {
    NSString *fontName = @"ProximaNova-Semibold";
    return ([UIFont isFontAvailable:fontName size:size]) ? [UIFont fontWithName:fontName size:size] : [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
}

+ (UIFont *)AL_proximaRegularWithSize:(CGFloat)size {
    NSString *fontName = @"ProximaNova-Regular";
    return ([UIFont isFontAvailable:fontName size:size]) ? [UIFont fontWithName:fontName size:size] : [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
}

+ (UIFont *)AL_proximaLightWithSize:(CGFloat)size {
    NSString *fontName = @"ProximaNova-Light";
    return ([UIFont isFontAvailable:fontName size:size]) ? [UIFont fontWithName:fontName size:size] : [UIFont systemFontOfSize:size weight:UIFontWeightLight];
}

+ (BOOL)isFontAvailable:(NSString *)fontName size:(CGFloat)size {
    return ([UIFont fontWithName:fontName size:size]);
}

@end
