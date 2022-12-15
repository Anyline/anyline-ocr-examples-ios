#import <Foundation/Foundation.h>
#import "ALJSONUtilities.h"

@class ALCameraConfig;
@class ALFlashConfig;

NS_ASSUME_NONNULL_BEGIN

/// An object that configures the scan view. Holds the camera and flash configurations
@interface ALScanViewConfig : NSObject <ALJSONStringRepresentable>

/// Component object configuring the scan view camera
@property (nonatomic, readonly) ALCameraConfig *cameraConfig;

/// Component object configuring the flash / torch module
@property (nonatomic, readonly) ALFlashConfig *flashConfig;

/// Initializes an ALScanViewConfig with the camera and flash configuration objects
/// @param cameraConfig Component object configuring the scan view camera
/// @param flashConfig Component object configuring the flash / torch module
/// @return an instance of ALScanViewConfig
- (instancetype)initWithCameraConfig:(ALCameraConfig * _Nullable)cameraConfig
                         flashConfig:(ALFlashConfig * _Nullable)flashConfig;

/// Initializes an ALScanViewConfig with a NSDictionary holding the configuration object in JSON
/// @param JSONDictionary the Dictionary containing the scan view config
/// @param error will be set with the failure reason if initialization has failed
/// @return an instance of ALScanViewConfig
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary *)JSONDictionary
                                           error:(NSError * _Nullable * _Nullable)error;

/// Creates an ALScanViewConfig with a NSDictionary holding the configuration object in JSON
/// @param JSONDictionary the Dictionary containing the scan view config
/// @return an instance of ALScanViewConfig
+ (ALScanViewConfig * _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary;

/// Creates an ALScanViewConfig with default values. Useful for further customization
/// @return an instance of ALScanViewConfig
+ (ALScanViewConfig *)defaultScanViewConfig;

/// Creates an ALScanViewConfig with the camera and flash configuration objects
/// @param cameraConfig Component object configuring the scan view camera
/// @param flashConfig Component object configuring the flash / torch module
/// @return an instance of ALScanViewConfig
+ (ALScanViewConfig *)withCameraConfig:(ALCameraConfig * _Nullable)cameraConfig
                           flashConfig:(ALFlashConfig * _Nullable)flashConfig;

@end

NS_ASSUME_NONNULL_END
