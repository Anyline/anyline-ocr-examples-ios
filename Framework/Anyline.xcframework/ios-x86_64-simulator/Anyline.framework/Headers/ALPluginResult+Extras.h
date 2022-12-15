#import <Foundation/Foundation.h>
#import "ALPluginResult.h"
#import "ALJSONUtilities.h"

NS_ASSUME_NONNULL_BEGIN

/// Extension methods to work with `ALPluginResult` objects
@interface ALPluginResult (ALExtras) <ALJSONStringRepresentable>

/// Constructs an `ALPluginResult` object. Returns a null value if the string
/// cannot be serialized into a valid object.
/// @param JSONString JSON string for the plugin result
/// @return the `ALPluginResult` object, or null
+ (ALPluginResult * _Nullable)withJSONString:(NSString *)JSONString;

/// Constructs an `ALPluginResult` object. Returns a null value if the string
/// cannot be serialized into a valid object.
/// @param JSONDictionary JSON dictionary containing the plugin result
/// @return the `ALPluginResult` object, or null
+ (ALPluginResult * _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary;

/// Initializes an `ALPluginResult` object. Returns a null value if the string
/// cannot be serialized into a valid object.
/// @param JSONString JSON string for the plugin result
/// @param error an error object which is set if an error during serialization is encountered
/// @return the `ALPluginResult` object, or null
- (instancetype _Nullable)initWithJSONString:(NSString *)JSONString
                                       error:(NSError * _Nullable * _Nullable)error;

/// Initializes an `ALPluginResult` object. Returns a null value if the string
/// cannot be serialized into a valid object.
/// @param JSONDictionary JSON dictionary containing the plugin result
/// @param error an error object which is set if an error during serialization is encountered
/// @return the `ALPluginResult` object, or null
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary *)JSONDictionary
                                           error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
