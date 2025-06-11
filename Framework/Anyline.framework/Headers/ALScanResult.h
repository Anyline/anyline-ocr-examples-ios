#import <UIKit/UIKit.h>
#import "ALJSONUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@class ALImage;
@class ALEvent;
@class ALMultiImageEvent;
@class ALPluginResult;

/// Object containing details for a successful scan result
@interface ALScanResult : NSObject <ALJSONStringRepresentable>

/// Blob key uniquely identifying this scan
@property (nonatomic, readonly) NSString *blobKey;

/// ID of the plugin that was initialized for this scan
@property (nonatomic, readonly) NSString *pluginID;

/// A full sized image taken from the device camera that the successful scan was based on
@property (nonatomic, readonly) UIImage *fullSizeImage;

/// A cropped version of the image taken from the device consisting of the region shown on
/// the cutout
@property (nonatomic, readonly) UIImage *croppedImage;

/// Image of detected facial photo, if any
@property (nonatomic, readonly, nullable) UIImage *faceImage;

/// An `ALPluginResult` object which contains complete plugin-specific details regarding
/// the scan result
@property (nonatomic, readonly) ALPluginResult *pluginResult;

/// The scan result in NSDictionary form
@property (nonatomic, readonly) NSDictionary *resultDictionary;

/// Initializes an `ALScanResult` with a suitably-structured dictionary, and the
/// image associated with the scan result
/// @param resultJSON the `NSDictionary` that encapsulates the scan result data
/// @param image a `UIImage` of the scan that led to this result
/// @param error error information that is filled when initialization fails
/// @return the `ALScanResult` object, if no error is encountered, otherwise null
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary *)resultJSON
                                           image:(UIImage *)image
                                           error:(NSError * _Nullable * _Nullable)error;

/// Initializes an `ALScanResult` with an scan result-related `ALEvent` object
/// @param event an `ALEvent` object containing details about the scan result
/// @return the `ALScanResult` object
- (instancetype _Nullable)initWithScanResultEvent:(ALEvent *)event;

/// Creates an `ALScanResult` with an scan result-related `ALEvent` object
/// @param event an `ALEvent` object containing details about the scan result
/// @return the `ALScanResult` object
+ (ALScanResult * _Nullable)withScanResultEvent:(ALEvent *)event;

/// Report Corrected Result
- (NSString * _Nullable)reportCorrectedResult:(NSString *)correctedResult
                                        error:(NSError * _Nullable * _Nullable)error;

/// Report Corrected Result with ApiKey
- (NSString * _Nullable)reportCorrectedResult:(NSString *)correctedResult
                                       apiKey:(NSString * _Nullable)apiKey
                                        error:(NSError * _Nullable * _Nullable)error;

/// Report Corrected Result from BlobKey
+ (NSString * _Nullable)reportCorrectedResultFromBlobKey:(NSString *)blobKey
                                         correctedResult:(NSString *)correctedResult
                                                  apiKey:(NSString * _Nullable)apiKey
                                                   error:(NSError * _Nullable * _Nullable)error;
@end

NS_ASSUME_NONNULL_END
