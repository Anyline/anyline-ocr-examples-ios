#import <Foundation/Foundation.h>
#import "ALScanResult.h"
#import "ALExportedScanResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALScanResult (Extras)

/**
 * Converts an ALScanResult to ALExportedScanResult with the specified image container and parameters
 * @param imageContainer The image container configuration for the exported result
 * @param imageParameters The image parameters for compression and format settings
 * @param error The error
 * @return ALExportedScanResult object with processed images
 */
- (ALExportedScanResult * _Nullable)convertToExportedScanResultWithImageContainer:(ALExportedScanResultImageContainer *)imageContainer
                                                        imageParameters:(ALExportedScanResultImageParameters *)imageParameters
                                                                  error:(NSError **)error;

/**
 * Creates an ALScanResult from an ALExportedScanResult
 * @param exportedScanResult The exported scan result to convert from
 * @param error The error
 * @return ALScanResult object or nil if conversion fails
 */
+ (ALScanResult * _Nullable)fromExportedScanResult:(ALExportedScanResult *)exportedScanResult
                                             error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
