//
//  NSMutableAttributedString+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Aldrich Co on 06.07.21.
//

#import "NSAttributedString+ALExamplesAdditions.h"

@implementation NSMutableAttributedString (ALExamplesAdditions)

- (void)setFontFaceWithFont:(UIFont *)font color:(UIColor *)color {
    
    // reference: https://izziswift.com/nsattributedstring-change-the-font-overall-but-keep-all-other-attributes/
    [self beginEditing];
    
    [self enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, self.length) options:0
                  usingBlock:^(id _Nullable value, NSRange range, BOOL *_Nonnull stop) {
        UIFont *oldFont = (UIFont *)value;
        UIFontDescriptor *newFontDescriptor = [[oldFont.fontDescriptor fontDescriptorWithFamily:font.familyName] fontDescriptorWithSymbolicTraits:oldFont.fontDescriptor.symbolicTraits];
        UIFont *newFont = [UIFont fontWithDescriptor:newFontDescriptor size:font.pointSize];
        if (newFont) {
            [self removeAttribute:NSFontAttributeName range:range];
            [self addAttribute:NSFontAttributeName value:newFont range:range];
        }
        if (color) {
            [self removeAttribute:NSForegroundColorAttributeName range:range];
            [self addAttribute:NSForegroundColorAttributeName value:newFont range:range];
        }
    }];
    
    [self endEditing];
}

@end
