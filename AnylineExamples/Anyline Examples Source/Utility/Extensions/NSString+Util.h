//
//  NSString+Util.h
//  ExampleApi
//
//  Created by David Dengg on 14.02.16.
//  Copyright © 2016 9yards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (UtilityExtension)

- (nonnull NSString *)removeCharactersInSet:(nonnull NSCharacterSet *)charSet;
- (CGFloat)fontSizeForString:(nonnull NSString *)string
                   withWidth:(CGFloat)width
                        font:(nonnull UIFont *)font
                     maxSize:(CGFloat)maxSize
                     minSize:(CGFloat)minSize;
    
- (nonnull NSString *)stringByCleaningWhitespace;

- (nonnull NSString *)trimmed;


@end
