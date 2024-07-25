#import <Foundation/Foundation.h>
#import "ALJSONUtilities.h"
#import "ALScanViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

/// This protocol defines common behaviors for config-type classes.
@protocol ALJSONConfig <ALJSONStringRepresentable>

/// Create a config instance prefilled with default values defined in the schema.
+ (instancetype)defaultConfig;

/// Initializes an instance of the config object with a JSON string. The JSON object will be
/// validated against the schema and cause the return value to be null if invalid.
/// - Parameters:
///   - JSONString: the JSON string corresponding to the config object
///   - error: error information when trying to create the config instance
- (instancetype _Nullable)initWithJSONString:(NSString *)JSONString error:(NSError * _Nullable * _Nullable)error;

/// Initializes an instance of the config object with a JSON dictionary. The JSON object will be
/// validated against the schema and cause the return value to be null if invalid.
/// - Parameters:
///   - JSONDictionary: the JSON dictionary corresponding to the config object
///   - error: error information when trying to create the config instance
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary *)JSONDictionary
                                           error:(NSError * _Nullable * _Nullable)error;

/// Create an instance of the config object with a JSON string. The JSON object will be
/// validated against the schema and cause the return value to be null if invalid.
/// - Parameters:
///   - JSONString: the JSON string corresponding to the config object
///   - error: error information when trying to create the config instance
+ (instancetype _Nullable)withJSONString:(NSString *)JSONString
                                   error:(NSError * _Nullable * _Nullable)error;

/// Create an instance of the config object with a JSON dictionary. The JSON object will be
/// validated against the schema and cause the return value to be null if invalid.
/// - Parameters:
///   - JSONDictionary: the JSON dictionary corresponding to the config object
///   - error: error information when trying to create the config instance
+ (instancetype _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary
                                       error:(NSError * _Nullable * _Nullable)error;

@end


@interface ALScanViewConfig (ALPublicInterface) <ALJSONConfig> @end

@interface ALViewPluginConfig (ALPublicInterface) <ALJSONConfig> @end

@interface ALViewPluginCompositeConfig (ALPublicInterface) <ALJSONConfig> @end

@interface ALFlashConfig (ALPrivateExtras) <ALJSONConfig> @end

@interface ALCameraConfig (ALPrivateExtras) <ALJSONConfig> @end

@interface ALPluginConfig (ALPrivateExtras) <ALJSONConfig> @end

@interface ALCutoutConfig (ALPublicInterface) <ALJSONConfig> @end

@interface ALScanFeedbackConfig (ALPublicInterface) <ALJSONConfig> @end

NS_ASSUME_NONNULL_END
