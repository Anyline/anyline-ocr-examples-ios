#import <Foundation/Foundation.h>
#import "ALCutoutConfig.h"
#import "ALScanFeedbackConfig.h"
#import "ALScanPluginConfig.h"
#import "ALJSONUtilities.h"

NS_ASSUME_NONNULL_BEGIN

/// Configuration object for a ScanViewPlugin
@interface ALScanViewPluginConfig : NSObject <ALJSONStringRepresentable>

/// Configuration object for the associated cutout config
@property (nonatomic, readonly) ALCutoutConfig *cutoutConfig;

/// Configuration object for the associated scan feedback config
@property (nonatomic, readonly) ALScanFeedbackConfig *scanFeedbackConfig;

/// Configuration object for the associated scan plugin config
@property (nonatomic, readonly) ALScanPluginConfig *scanPluginConfig;

/// Initializes an `ALScanViewPluginConfig` with ScanPluginConfig, CutoutConfig, and
/// ScanFeedbackConfig components.
/// @param scanPluginConfig Configuration object for the associated scan plugin config
/// @param cutoutConfig Configuration object for the associated cutout config
/// @param scanFeedbackConfig Configuration object for the associated scan feedback config
/// @param error NSError object which is filled with appropriate information when initialization fails
/// @return the ALScanViewPluginConfig instance
- (instancetype _Nullable)initWithScanPluginConfig:(ALScanPluginConfig *)scanPluginConfig
                                      cutoutConfig:(ALCutoutConfig * _Nullable)cutoutConfig
                                scanFeedbackConfig:(ALScanFeedbackConfig * _Nullable)scanFeedbackConfig
                                             error:(NSError * _Nullable * _Nullable)error NS_DESIGNATED_INITIALIZER;

/**
 Initializes the ScanViewPluginConfig with an ALScanPluginConfig instance

 @param scanPluginConfig The ScanPluginConfig instance
 @param error An NSError object that is filled with the appropriate error information when initialization fails
 @return the ALScanViewPluginConfig instance
 */
- (instancetype _Nullable)initWithScanPluginConfig:(ALScanPluginConfig *)scanPluginConfig
                                             error:(NSError * _Nullable * _Nullable)error;

/// Initializes a ScanViewPluginConfig with an NSDictionary representing the configuration
/// @param JSONDictionary the JSON object representing the configuration
/// @param error NSError object that is filled with the appropriate error information when initialization fails
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary *)JSONDictionary
                                           error:(NSError * _Nullable * _Nullable)error;

/// Creates a ScanViewPluginConfig with with ScanPluginConfig, CutoutConfig,
/// and ScanFeedbackConfig components.
/// @param scanPluginConfig Configuration object for the associated scan plugin config
/// @param cutoutConfig (Optional) Configuration object for the associated cutout config
/// @param scanFeedbackConfig (Optional) Configuration object for the associated scan feedback config
/// @return the ALScanViewPluginConfig instance
+ (ALScanViewPluginConfig * _Nullable)withScanPluginConfig:(ALScanPluginConfig *)scanPluginConfig
                                              cutoutConfig:(ALCutoutConfig * _Nullable)cutoutConfig
                                        scanFeedbackConfig:(ALScanFeedbackConfig * _Nullable)scanFeedbackConfig;

/// Creates a ScanViewPluginConfig with with ScanPluginConfig, CutoutConfig,
/// and ScanFeedbackConfig components.
/// @param scanPluginConfig Configuration object for the associated scan plugin config
/// @return the ALScanViewPluginConfig instance
+ (ALScanViewPluginConfig * _Nullable)withScanPluginConfig:(ALScanPluginConfig *)scanPluginConfig;

/// Creates a ScanViewPluginConfig with an NSDictionary representing the configuration
/// @param JSONDictionary the JSON object representing the configuration
/// @return the ALScanViewPluginConfig instance
+ (instancetype _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary;

@end

NS_ASSUME_NONNULL_END
