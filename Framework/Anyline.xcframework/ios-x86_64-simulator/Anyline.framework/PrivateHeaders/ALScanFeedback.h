#import <Foundation/Foundation.h>
#import "ALGeometry.h"

NS_ASSUME_NONNULL_BEGIN

@class ALViewPluginConfig;

@protocol ALCutoutDelegate;

typedef NS_ENUM(NSUInteger, ALScanFeedbackType) {
    ALScanFeedbackTypeWeb=0,
    ALScanFeedbackTypeNative
};

@protocol ALScanFeedback <NSObject>

@property (nonatomic, strong) NSSet<NSString *> *visiblePlugins;

@property (nonatomic, readonly) NSDictionary<NSString *, ALViewPluginConfig *> *pluginConfigs;

@property (nonatomic, assign) CGSize cameraResolution;

@property (nonatomic, readonly) ALScanFeedbackType type;

- (void)addCutoutDelegate:(id<ALCutoutDelegate>)delegate;

- (void)removeCutoutDelegate:(id<ALCutoutDelegate>)delegate;

- (void)setSquare:(ALSquare *)square pluginID:(NSString *)pluginID;

- (void)setPolygons:(NSArray<ALSquare *> *)polygons pluginID:(NSString *)pluginID;

- (CGRect)cutoutRectForPluginID:(NSString *)pluginID;

@end


@protocol ALCutoutDelegate <NSObject>

@required

- (void)scanFeedback:(UIView<ALScanFeedback> *)uiFeedback
   updatedCutoutRect:(CGRect)cutoutRect
            pluginID:(NSString *)pluginID;

@end

NS_ASSUME_NONNULL_END
