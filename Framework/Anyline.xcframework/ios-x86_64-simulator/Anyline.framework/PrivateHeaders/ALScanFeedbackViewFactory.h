#import <Foundation/Foundation.h>
#import "ALScanFeedback.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALCustomUIFeedbackContainer;
@class ALUIFeedbackConfig;

@interface ALScanFeedbackViewFactory : NSObject

+ (ALScanFeedbackViewFactory *)defaultFactory;

- (UIView<ALScanFeedback> * _Nullable)makeFeedbackViewOfType:(ALScanFeedbackType)type
                                                     frame:(CGRect)frame
                                             pluginConfigs:(NSDictionary<NSString *, ALViewPluginConfig *> *)pluginConfigs;

@end

NS_ASSUME_NONNULL_END
