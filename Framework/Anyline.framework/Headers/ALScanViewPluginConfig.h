#import <Foundation/Foundation.h>
#import "ALCutoutConfig.h"
#import "ALScanFeedbackConfig.h"
#import "ALJSONUtilities.h"

@class ALPluginConfig;

NS_ASSUME_NONNULL_BEGIN

/// Configuration object for a ScanViewPlugin
@interface ALScanViewPluginConfig : NSObject <ALJSONStringRepresentable>

/// Configuration object for the associated cutout config
@property (nonatomic, readonly) ALCutoutConfig *cutoutConfig;

/// Configuration object for the associated scan feedback config
@property (nonatomic, readonly) ALScanFeedbackConfig *scanFeedbackConfig;

/// Configuration object for the associated plugin config
@property (nonatomic, readonly) ALPluginConfig *pluginConfig;

/// Initializes an `ALScanViewPluginConfig` with PluginConfig, CutoutConfig, and
/// ScanFeedbackConfig components.
/// @param pluginConfig Configuration object for the associated plugin config
/// @param cutoutConfig Configuration object for the associated cutout config
/// @param scanFeedbackConfig Configuration object for the associated scan feedback config
/// @param error NSError object which is filled with appropriate information when initialization fails
/// @return the ALScanViewPluginConfig instance
- (instancetype _Nullable)initWithPluginConfig:(ALPluginConfig *)pluginConfig
                                  cutoutConfig:(ALCutoutConfig * _Nullable)cutoutConfig
                            scanFeedbackConfig:(ALScanFeedbackConfig * _Nullable)scanFeedbackConfig
                                         error:(NSError * _Nullable * _Nullable)error NS_DESIGNATED_INITIALIZER;

/**
 Initializes the ScanViewPluginConfig with an ALPluginConfig instance

 @param pluginConfig The PluginConfig instance
 @param error An NSError object that is filled with the appropriate error information when initialization fails
 @return the ALScanViewPluginConfig instance
 */
- (instancetype _Nullable)initWithPluginConfig:(ALPluginConfig *)pluginConfig
                                         error:(NSError * _Nullable * _Nullable)error;

/// Initializes a ScanViewPluginConfig with an NSDictionary representing the configuration
/// @param JSONDictionary the JSON object representing the configuration
/// @param error NSError object that is filled with the appropriate error information when initialization fails
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary *)JSONDictionary
                                           error:(NSError * _Nullable * _Nullable)error;

/// Creates a ScanViewPluginConfig with with PluginConfig, CutoutConfig,
/// and ScanFeedbackConfig components.
/// @param pluginConfig Configuration object for the associated plugin config
/// @param cutoutConfig (Optional) Configuration object for the associated cutout config
/// @param scanFeedbackConfig (Optional) Configuration object for the associated scan feedback config
/// @return the ALScanViewPluginConfig instance
+ (ALScanViewPluginConfig * _Nullable)withPluginConfig:(ALPluginConfig *)pluginConfig
                                          cutoutConfig:(ALCutoutConfig * _Nullable)cutoutConfig
                                    scanFeedbackConfig:(ALScanFeedbackConfig * _Nullable)scanFeedbackConfig;

/// Creates a ScanViewPluginConfig with with PluginConfig, CutoutConfig,
/// and ScanFeedbackConfig components.
/// @param pluginConfig Configuration object for the associated plugin config
/// @return the ALScanViewPluginConfig instance
+ (ALScanViewPluginConfig * _Nullable)withPluginConfig:(ALPluginConfig *)pluginConfig;

/// Creates a ScanViewPluginConfig with an NSDictionary representing the configuration
/// @param JSONDictionary the JSON object representing the configuration
/// @return the ALScanViewPluginConfig instance
+ (instancetype _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary;

@end

NS_ASSUME_NONNULL_END
