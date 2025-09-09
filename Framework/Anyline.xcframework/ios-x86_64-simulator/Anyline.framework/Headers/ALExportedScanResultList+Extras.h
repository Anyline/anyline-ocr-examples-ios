#import <Foundation/Foundation.h>
#import "ALExportedScanResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ALExportedScanResultListExtras)

/**
 * Creates an array of ALExportedScanResult objects from a JSON array
 * @param jsonArray The JSON array containing exported scan result configurations
 * @return NSArray of ALExportedScanResult objects or nil if conversion fails
 */
+ (NSArray<ALExportedScanResult *> * _Nullable)fromJSONArray:(NSArray *)jsonArray;

/**
 * Converts the array of ALExportedScanResult objects to a JSON array
 * @return NSArray of NSDictionary objects representing the exported scan results
 */
- (NSArray *)toJSONArray;

@end

NS_ASSUME_NONNULL_END 
