#import <Foundation/Foundation.h>
#import "ALJSONUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@class ALPluginConfig;

/// Configuration object for a ScanPlugin. This object contains an `ALPluginConfig`
/// which contains configuration for a specific scanning use case.
@interface ALScanPluginConfig : NSObject <ALJSONStringRepresentable>

/// Plugin ID: each plugin should have a non-empty, and unique plugin string.
@property (nonatomic, readonly, copy) NSString *pluginID;

/// Amount of time, in milliseconds, where scanning is delayed upon starting a plugin.
/// This might help with some cases where scanning happens too fast and the resulting
/// image returned is blurry
@property (nonatomic, readonly) NSInteger startScanDelay;

/// Stops the running plugin when a result is found. Defaults to true
@property (nonatomic, readonly) BOOL cancelOnResult;

/// The scanning use case specific configuration
@property (nonatomic, readonly) ALPluginConfig *pluginConfig;

/// Initializes a scan plugin config with a plugin config
/// @param pluginConfig the plugin config object
- (id)initWithPluginConfig:(ALPluginConfig *)pluginConfig;

/// Initiailizes a scan plugin config with a JSON dictionary
/// @param JSONDictionary the JSON config object in NSDictionary form
/// @param error NSError object which is filled with relevant error information in case initialization fails
- (id _Nullable)initWithJSONDictionary:(NSDictionary *)JSONDictionary
                                 error:(NSError * _Nullable * _Nullable)error;

/// Convenience initializer taking an `ALPluginConfig`
/// @param pluginConfig an `ALPluginConfig` object
+ (ALScanPluginConfig *)withPluginConfig:(ALPluginConfig *)pluginConfig;

/// Convenience initializer taking a JSON Dictionary object representing the config
/// @param JSONDictionary NSDictionary representing the ScanPluginConfig
+ (ALScanPluginConfig * _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary;

@end

NS_ASSUME_NONNULL_END
