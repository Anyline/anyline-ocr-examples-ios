//
//  NSAttributedString+ALExamplesAdditions.h
//  AnylineExamples
//
//  Created by Angela Brett on 13.10.20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSAttributedString (ALExamplesAdditions)

//change text colour depending on light/dark mode (does not affect background colour of text; this should usually be clear to see the system background colour behind it)
- (NSAttributedString *)withSystemColors;

- (NSAttributedString *)withFont:(UIFont *)font;
@end
