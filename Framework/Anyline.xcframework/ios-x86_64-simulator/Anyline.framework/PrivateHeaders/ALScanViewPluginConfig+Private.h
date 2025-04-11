#ifndef ALScanViewPluginConfig_Private_h
#define ALScanViewPluginConfig_Private_h

NS_ASSUME_NONNULL_BEGIN

@class ALPluginConfig, ALUIFeedbackConfig;

@interface ALViewPluginConfig (ALUIFeedbackConfig)

@property (nonatomic, readonly) ALUIFeedbackConfig *uiFeedbackConfig;

/// Creates a ScanViewPluginConfig with with PluginConfig, CutoutConfig,
/// and ScanFeedbackConfig components.
/// @param pluginConfig Configuration object for the associated plugin config
/// @param cutoutConfig (Optional) Configuration object for the associated cutout config
/// @param scanFeedbackConfig (Optional) Configuration object for the associated scan feedback config
/// @param uiFeedbackConfig (Optional) Configuration object for the associated ui feedback config
/// @return the ALViewPluginConfig instance
+ (ALViewPluginConfig * _Nullable)withPluginConfig:(ALPluginConfig *)pluginConfig
                                          cutoutConfig:(ALCutoutConfig * _Nullable)cutoutConfig
                                    scanFeedbackConfig:(ALScanFeedbackConfig * _Nullable)scanFeedbackConfig
                                      uiFeedbackConfig:(ALUIFeedbackConfig * _Nullable)uiFeedbackConfig;


/// Initializes an `ALViewPluginConfig` with PluginConfig, CutoutConfig, and
/// ScanFeedbackConfig components.
/// @param pluginConfig Configuration object for the associated plugin config
/// @param cutoutConfig Configuration object for the associated cutout config
/// @param scanFeedbackConfig Configuration object for the associated scan feedback config
/// @param uiFeedbackConfig Configuration object for the associated ui feedback config
/// @param error NSError object which is filled with appropriate information when initialization fails
/// @return the ALViewPluginConfig instance
- (instancetype _Nullable)initWithPluginConfig:(ALPluginConfig *)pluginConfig
                                  cutoutConfig:(ALCutoutConfig * _Nullable)cutoutConfig
                            scanFeedbackConfig:(ALScanFeedbackConfig * _Nullable)scanFeedbackConfig
                              uiFeedbackConfig:(ALUIFeedbackConfig * _Nullable)uiFeedbackConfig
                                         error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END

#endif /* ALScanViewPluginConfig_Private_h */
