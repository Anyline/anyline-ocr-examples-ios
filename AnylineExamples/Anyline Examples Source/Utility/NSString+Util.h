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

- (NSString *)removeCharactersInSet:(NSCharacterSet *)charSet;
- (CGFloat)fontSizeForString:(NSString *)string
                   withWidth:(CGFloat)width
                        font:(UIFont *)font
                     maxSize:(CGFloat)maxSize
                     minSize:(CGFloat)minSize;

@end
