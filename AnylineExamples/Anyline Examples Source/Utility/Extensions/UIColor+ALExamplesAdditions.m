//
//  UIColor+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 30/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "UIColor+ALExamplesAdditions.h"

@implementation UIColor (ALExamplesAdditions)

+ (UIColor *)AL_White {
    return [UIColor colorNamed:@"AL_White"];
}

+ (UIColor *)AL_Black {
    return [UIColor colorNamed:@"AL_Black"];
}

+ (UIColor *)AL_SegmentControl {
    return [UIColor colorNamed:@"AL_SegmentControl"];
}

+ (UIColor *)AL_SegmentControlUnselected {
    return [UIColor colorNamed:@"AL_SegmentControlUnselected"];
}

+ (UIColor *)AL_examplesBlue {
    return [UIColor colorNamed:@"AL_examplesBlue"];
}

+ (UIColor *)AL_errorLabelRed {
    return [UIColor colorNamed:@"AL_errorLabelRed"];
}

+ (UIColor *)AL_devTestModeColor {
    return [UIColor colorNamed:@"AL_devTestModeColor"];
}

+ (UIColor *)AL_Gray {
    return [UIColor colorNamed:@"AL_gray"];
}

+ (UIColor *)AL_SectionGridBG {
    return [UIColor colorNamed:@"AL_SectionGridBG"];
}

+ (UIColor *)AL_SectionLabel {
    return [UIColor colorNamed:@"AL_SectionLabel"];
}

+ (UIColor *)AL_NonSelectedToolBarItem {
    return [UIColor colorNamed:@"AL_NonSelectedToolBarItem"];
}

+(UIColor *)AL_BackgroundColor {
    return [UIColor colorNamed:@"AL_BackgroundColor"];
}

+(UIColor *)AL_BackgroundSettingsHeaderColor {
    return [UIColor colorNamed:@"AL_BackgroundSettingsHeaderColor"];
}

+ (UIColor *)AL_LabelWhiteBlack {
    return [UIColor colorNamed:@"AL_LabelWhiteBlack"];
}

+ (UIColor *)AL_LabelBlackWhite {
    return [UIColor colorNamed:@"AL_LabelBlackWhite"];
}

+(UIColor *)AL_NavigationBG {
    return  [UIColor colorNamed:@"AL_NavigationBG"];
}

+ (UIColor *)AL_Separator {
    return  [UIColor colorNamed:@"AL_Separator"];
}

+ (UIColor *)AL_BackButton {
    return  [UIColor colorNamed:@"AL_BackButton"];
}

+ (UIColor *)AL_ExitRegistrationButton {
    return  [UIColor colorNamed:@"AL_ExitRegistrationButton"];
}

+ (UIColor *)AL_colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)AL_NoResultLabel {
    return  [UIColor colorNamed:@"AL_NoResultLabel"];
}

@end
