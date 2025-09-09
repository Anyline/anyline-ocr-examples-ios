#import <Foundation/Foundation.h>
#import "ALExportedScanResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALExportedScanResultImageContainer (Extras)

/**
 * Creates an ALExportedScanResultImageContainer from a JSON dictionary
 * @param jsonConfig The JSON configuration dictionary
 * @return ALExportedScanResultImageContainer object or nil if conversion fails
 */
+ (ALExportedScanResultImageContainer *)fromJSONDictionary:(NSDictionary *)jsonConfig;

/**
 * Converts the ALExportedScanResultImageContainer to a JSON dictionary
 * @return NSDictionary representation of the image container
 */
- (NSDictionary *)toJSONDictionary;

@end

@interface ALExportedScanResultImageContainerEncoded (Extras)

/**
 * Converts the ALExportedScanResultImageContainerEncoded to a JSON dictionary
 * @return NSDictionary representation of the encoded image container
 */
- (NSDictionary *)toJSONDictionary;

@end

@interface ALExportedScanResultImageContainerSaved (Extras)

/**
 * Converts the ALExportedScanResultImageContainerSaved to a JSON dictionary
 * @return NSDictionary representation of the saved image container
 */
- (NSDictionary *)toJSONDictionary;

@end

@interface ALExportedScanResultImages (Extras)

/**
 * Converts the ALExportedScanResultImages to a JSON dictionary
 * @return NSDictionary representation of the images
 */
- (NSDictionary *)toJSONDictionary;

@end

NS_ASSUME_NONNULL_END 
