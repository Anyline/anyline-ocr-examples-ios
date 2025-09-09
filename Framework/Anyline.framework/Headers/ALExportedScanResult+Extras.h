#import <Foundation/Foundation.h>
#import "ALExportedScanResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALExportedScanResult (Extras)

/**
 * Creates an ALExportedScanResult from a JSON dictionary
 * @param jsonConfig The JSON configuration dictionary
 * @return ALExportedScanResult object or nil if conversion fails
 */
+ (ALExportedScanResult *)fromJSONDictionary:(NSDictionary *)jsonConfig;

/**
 * Converts the ALExportedScanResult to a JSON dictionary
 * @return NSDictionary representation of the exported scan result
 */
- (NSDictionary * )toJSONDictionary;

/**
 * Deletes all saved image files associated with this exported scan result
 * @return YES if all files were successfully deleted, NO otherwise
 */
- (BOOL)deleteFiles;

@end

NS_ASSUME_NONNULL_END
