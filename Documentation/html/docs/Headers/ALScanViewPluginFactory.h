#import <Foundation/Foundation.h>
#import "ALScanViewPluginBase.h"

NS_ASSUME_NONNULL_BEGIN

/// Creates scan view plugins (`ALScanViewPlugin` or `ALViewPluginComposite`) from JSON objects
@interface ALScanViewPluginFactory : NSObject

/// Creates a scan view plugin (`ALScanViewPlugin` or `ALViewPluginComposite`) from a JSON
/// dictionary
/// @param JSONDictionary a suitably-formatted JSON `NSDictionary`
/// @param error an NSError object that will contain error information if creation
/// of the scan view plugin is unsuccessful
/// @return an object of type `NSObject<ALScanViewPluginBase> *` (`ALScanViewPlugin` or
///  `ALViewPluginComposite`),
/// or null if the JSON object could not be deserialized
+ (NSObject<ALScanViewPluginBase> * _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary
                                                   error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
