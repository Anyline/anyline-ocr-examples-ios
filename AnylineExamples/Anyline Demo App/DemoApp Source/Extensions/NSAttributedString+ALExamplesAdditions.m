//
//  NSAttributedString+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Angela Brett on 13.10.20.
//

#import "NSAttributedString+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"
#import "NSMutableAttributedString+ALExamplesAdditions.h"

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

// Note: applying a font to the string by simplying using `addAttributes:range:` will also strip all existing
// formatting (e.g. boldface) from it. To preserve existing style attributes while changing the font, use the
// NSMutableAttributedString extension `setFontFaceWithFont:color:` (a custom method) instead.
- (NSAttributedString *)withFont:(UIFont *)font {
    NSMutableAttributedString *mutableAttrStr = [self mutableCopy];
    [mutableAttrStr setFontFaceWithFont:font color:nil];
    return mutableAttrStr;
}

@end
