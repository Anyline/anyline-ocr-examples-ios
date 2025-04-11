#ifndef ALScanResult_Private_h
#define ALScanResult_Private_h

@class ALPluginConfig;

NS_ASSUME_NONNULL_BEGIN

@interface ALScanResult ()

- (instancetype)initWithScanResultEvent:(ALEvent *)event pluginConfig:(ALPluginConfig *)pluginConfig;

+ (ALScanResult *)withScanResultEvent:(ALEvent *)event
                         pluginConfig:(ALPluginConfig *)pluginConfig;

@property (nonatomic, readonly) BOOL shouldReturnFaceImage;

@end

NS_ASSUME_NONNULL_END

#endif /* ALScanResult_Private_h */
