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
+ (UIColor *)AL_examplesBlueWithAlpha:(CGFloat)alpha;

@end
