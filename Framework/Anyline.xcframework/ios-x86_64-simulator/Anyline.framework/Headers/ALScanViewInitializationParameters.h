#import <Foundation/Foundation.h>

@class ALScanViewInitializationParameters;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

/// Schema for ScanView JSON initialization parameters
@interface ALScanViewInitializationParameters : NSObject
/// An optional uuid (v4) to correlate scans and data points within a workflow.
@property (nonatomic, nullable, copy) NSString *correlationID;

@end

NS_ASSUME_NONNULL_END
