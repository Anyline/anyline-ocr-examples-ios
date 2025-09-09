#import <Foundation/Foundation.h>
#import "ALExportedScanResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALExportedScanResultImageParameters (Extras)

/**
 * Creates an ALExportedScanResultImageParameters from a JSON dictionary
 * @param jsonConfig The JSON configuration dictionary
 * @return ALExportedScanResultImageParameters object or nil if conversion fails
 */
+ (ALExportedScanResultImageParameters *)fromJSONDictionary:(NSDictionary *)jsonConfig;

/**
 * Converts the ALExportedScanResultImageParameters to a JSON dictionary
 * @return NSDictionary representation of the image parameters
 */
- (NSDictionary *)toJSONDictionary;

/**
 * Gets the file extension based on the format
 * @return NSString representing the file extension (e.g., ".png", ".jpg")
 */
- (NSString *)getFileExtension;

@end

NS_ASSUME_NONNULL_END 
