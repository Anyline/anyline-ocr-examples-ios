#import <Foundation/Foundation.h>
#import "ALPluginConfig.h"
#import "ALJSONUtilities.h"

NS_ASSUME_NONNULL_BEGIN

/// Extension methods to work with `ALPluginConfig` objects
@interface ALPluginConfig (ALExtras) <ALJSONStringRepresentable>

/// Constructs an `ALPluginConfig`. Returns a null value if the string
/// cannot be serialized into a valid object.
/// @param JSONString JSON string for the plugin configuration
/// @return the `ALPluginConfig` object, or null
+ (ALPluginConfig * _Nullable)withJSONString:(NSString *)JSONString;

/// Constructs an `ALPluginConfig` from a suitably-structured dictionary.
/// Returns a null value if the dictionary could not be serialized into a
/// valid object.
/// @param JSONDictionary JSON dictionary containing the plugin configuration
/// @return the `ALPluginConfig` object, or null
+ (ALPluginConfig * _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary;

/// Initializes an `ALPluginConfig`. Returns a null value if the string
/// cannot be serialized into a valid object.
/// @param JSONString JSON string for the plugin configuration
/// @param error an error object which is set if an error during serialization is encountered
/// @return the `ALPluginConfig` object, or null
- (instancetype _Nullable)initWithJSONString:(NSString *)JSONString
                                       error:(NSError * _Nullable * _Nullable)error;

/// Initializes an `ALPluginConfig` from a suitably-structured dictionary.
/// If the dictionary could not be serialized into a valid object, the method returns
/// null, and sets the error parameter.
/// @param JSONDictionary JSON dictionary containing the plugin configuration
/// @param error an error object which is set if an error during serialization is encountered
/// @return the `ALPluginConfig` object, or null
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary *)JSONDictionary
                                           error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
