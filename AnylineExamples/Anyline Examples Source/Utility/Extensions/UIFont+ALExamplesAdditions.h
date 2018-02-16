//
//  UIFont+ALExamplesAdditions.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 30/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (ALExamplesAdditions)

+ (UIFont *)AL_proximaBoldWithSize:(CGFloat)size;

+ (UIFont *)AL_proximaSemiboldWithSize:(CGFloat)size;

+ (UIFont *)AL_proximaRegularWithSize:(CGFloat)size;

+ (UIFont *)AL_proximaLightWithSize:(CGFloat)size;

+ (BOOL)isFontAvailable:(NSString *)fontName size:(CGFloat)size;

@end
