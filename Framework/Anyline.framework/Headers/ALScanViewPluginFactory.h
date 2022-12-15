#import <Foundation/Foundation.h>
#import "ALScanViewPluginBase.h"

NS_ASSUME_NONNULL_BEGIN

/// Creates scan view plugins (`ALScanViewPlugin` or `ALViewPluginComposite`) from JSON objects
@interface ALScanViewPluginFactory : NSObject

/// Creates a scan view plugin (`ALScanViewPlugin` or `ALViewPluginComposite`) from a JSON
/// dictionary
/// @param JSONDictionary a suitably-formatted JSON `NSDictionary`
/// @return an object of type `id<ALScanViewPluginBase>` (`ALScanViewPlugin` or `ALViewPluginComposite`),
/// or null if the JSON object could not be deserialized
+ (id<ALScanViewPluginBase> _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary;

@end

NS_ASSUME_NONNULL_END
