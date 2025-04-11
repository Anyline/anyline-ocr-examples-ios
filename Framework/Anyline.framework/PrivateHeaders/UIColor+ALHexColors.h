#import <UIKit/UIKit.h>

@interface UIColor (ALHexColors)

+ (UIColor *)AL_colorWithHexString:(NSString *)hexString;

+ (NSString *)AL_hexValuesFromUIColor:(UIColor *)color;

- (NSString *)webHexValue;

- (NSString *)webHexValueAlphaLast;

- (NSString *)webHexValueAlphaFirst;

- (CGFloat)getAlphaValue;

@end
