//
//  NSString+Util.m
//  ExampleApi
//
//  Created by David Dengg on 14.02.16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (UtilityExtension)

- (NSString *)removeCharactersInSet:(NSCharacterSet *)charSet {
    NSString *string = (NSString *)self;
    while ([string componentsSeparatedByCharactersInSet:charSet].count > 1) {
        string = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
    }
    return string;
}

- (CGFloat)fontSizeForString:(NSString *)string
                   withWidth:(CGFloat)width
                        font:(UIFont*)font
                     maxSize:(CGFloat)maxSize
                     minSize:(CGFloat)minSize {
    
    CGFloat fontSize = maxSize;
    for(int i = maxSize; i > minSize; i = i - 2)
    {
        font = [font fontWithSize:i];
        CGSize constraintSize = CGSizeMake(0, 0);
        
        CGRect labelSize = [string boundingRectWithSize:constraintSize options:0 attributes:@{NSFontAttributeName : font} context:NULL];
        
        if(labelSize.size.width <= width) {
            fontSize = i;
            break;
        }
    }
    
    return fontSize;
}

@end
