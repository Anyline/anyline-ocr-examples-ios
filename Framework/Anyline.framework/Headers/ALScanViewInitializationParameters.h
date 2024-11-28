#import <Foundation/Foundation.h>

@class ALScanViewInitializationParameters;
@class ALDemo;
@class ALSfdc;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

/// Schema for ScanView JSON initialization parameters
@interface ALScanViewInitializationParameters : NSObject
/// An optional uuid (v4) to correlate scans and data points within a workflow.
@property (nonatomic, nullable, copy) NSString *correlationID;
/// Data contained within the QR code that's required to unlock scanning with the Showcase
/// Apps.
@property (nonatomic, nullable, strong) ALDemo *demo;

@end

/// Data contained within the QR code that's required to unlock scanning with the Showcase
/// Apps.
@interface ALDemo : NSObject
@property (nonatomic, assign)         NSInteger qrVersion;
@property (nonatomic, strong)         ALSfdc *sfdc;
@property (nonatomic, nullable, copy) NSString *validityDate;
@end

@interface ALSfdc : NSObject
@property (nonatomic, nullable, copy) NSString *accountID;
@property (nonatomic, nullable, copy) NSString *accountName;
@property (nonatomic, nullable, copy) NSString *oppID;
@end

NS_ASSUME_NONNULL_END
