#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ALExtras)

- (NSInteger)percentToIntOrElse:(NSInteger)defaultValue;

// "hex" string to color struct, pass in "outer alpha" float (0-1) and multiply it with 255
// then apply the alpha*255 to the 'A' component, then get the string value again.

- (NSString *)cleanedUpHexString;

- (NSString *)cleanedUpImageResolution;

/// Converts a string in the format of "<A>[B][C]" (found on valijson schema validation messages)
/// to the more familiar "/B/C" format.
- (NSString *)valijsonErrContextToPath;

- (NSError *)valijsonError;

@end

NS_ASSUME_NONNULL_END
