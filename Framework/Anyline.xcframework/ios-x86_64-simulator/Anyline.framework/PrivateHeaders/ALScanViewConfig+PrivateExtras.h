#import <Foundation/Foundation.h>
#import "ALJSONUtilities.h"
#import "ALScanViewConfig+Extras.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALScanViewConfig (ALPrivateExtras)

@end


@protocol ALJSONConfigWithDefaults <ALJSONConfig>

// this will need to be implemented according the (unwritten) rules of the schema
- (void)setDefaults;

@end

NS_ASSUME_NONNULL_END
