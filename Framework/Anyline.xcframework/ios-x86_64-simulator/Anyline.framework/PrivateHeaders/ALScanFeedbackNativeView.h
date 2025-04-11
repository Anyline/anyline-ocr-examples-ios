#import "ALScanFeedback.h"
#import "ALGeometry.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALCutoutDelegate;

@interface ALScanFeedbackNativeView : UIView <ALScanFeedback>

@property (nonatomic, strong) NSSet<NSString *> *visiblePlugins;

@property (nonatomic, assign) CGSize cameraResolution;

@property (nonatomic, readonly) NSDictionary<NSString *, ALViewPluginConfig *> *pluginConfigs;

- (instancetype)initWithFrame:(CGRect)frame
                pluginConfigs:(NSDictionary<NSString *, ALViewPluginConfig *> *)pluginConfigs;

@end

NS_ASSUME_NONNULL_END
