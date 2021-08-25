//
//  NSAttributedString+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Angela Brett on 13.10.20.
//

#import "NSAttributedString+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"

@implementation NSAttributedString (ALExamplesAdditions)

- (NSAttributedString *)withSystemColors {
    if (@available(iOS 13.0, *)) {
        NSMutableAttributedString *string = [self mutableCopy];
        [string addAttributes:@{NSForegroundColorAttributeName:[UIColor AL_LabelBlackWhite]} range:NSMakeRange(0,string.length)];
        return string;
    } else {
        return self;
    }
}

- (NSAttributedString *)withFont:(UIFont *)font {
    NSMutableAttributedString *string = [self mutableCopy];
    [string addAttributes:@{NSFontAttributeName:font } range:NSMakeRange(0,string.length)];
    return string;
}

@end
