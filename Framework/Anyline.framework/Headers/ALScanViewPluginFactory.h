#import <Foundation/Foundation.h>
#import <Anyline/ALViewPluginBase.h>

NS_ASSUME_NONNULL_BEGIN

/// Creates scan view plugins (`ALScanViewPlugin` or `ALViewPluginComposite`) from JSON objects
@interface ALScanViewPluginFactory : NSObject

/// Creates a scan view plugin (`ALScanViewPlugin` or `ALViewPluginComposite`) from a JSON
/// dictionary
/// @param JSONDictionary a JSON dictionary corresponding to an `ALViewPluginConfig` or
/// `ALViewPluginCompositeConfig` object
/// @param error an NSError object that will contain error information if creation
/// of the scan view plugin is unsuccessful
/// @return an object of type `NSObject<ALViewPluginBase> *` (`ALScanViewPlugin` or
///  `ALViewPluginComposite`),
/// or null if the JSON object could not be deserialized
+ (NSObject<ALViewPluginBase> * _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary
                                                       error:(NSError * _Nullable * _Nullable)error;

/// Creates a scan view plugin (`ALScanViewPlugin` or `ALViewPluginComposite`) from a JSON
/// dictionary
/// @param JSONString the config string in JSON corresponding to an `ALViewPluginConfig` or
/// `ALViewPluginCompositeConfig` object
/// @param error an NSError object that will contain error information if creation
/// of the scan view plugin is unsuccessful
/// @return an object of type `NSObject<ALViewPluginBase> *` (`ALScanViewPlugin` or
///  `ALViewPluginComposite`),
/// or null if the JSON object could not be deserialized
+ (NSObject<ALViewPluginBase> * _Nullable)withJSONString:(NSString *)JSONString
                                                   error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
