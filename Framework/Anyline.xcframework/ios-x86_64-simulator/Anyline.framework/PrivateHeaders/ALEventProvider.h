#import <Foundation/Foundation.h>
#import "ALImage.h"

NS_ASSUME_NONNULL_BEGIN

@class ALEvent;

typedef void (^NewEventBlock)(ALEvent * _Nullable event);


typedef NS_ENUM(NSUInteger, EventChannel) {
    // ScanPlugin
    EventChannelScanPluginUnknown,
    EventChannelScanPluginResult,
    EventChannelScanPluginInfo,
    EventChannelScanPluginError,
    EventChannelScanPluginRunSkipped,
    EventChannelScanPluginVisualFeedback,
    EventChannelScanPluginStarted,
    EventChannelScanPluginStopped,
    EventChannelScanPluginDebug1,

    // ScanViewPlugin
    EventChannelScanViewPluginVisualFeedback,
    EventChannelScanViewPluginResultBeep,
    EventChannelScanViewPluginResultBlink,
    EventChannelScanViewPluginBrightness,
    EventChannelScanViewPluginCutoutVisibility,
    EventChannelScanViewPluginVibrate,
    EventChannelScanViewPluginScanInfo,

    // Composite
    EventChannelPluginCompositeVisualFeedback,
    EventChannelPluginCompositeResultBeep,
    EventChannelPluginCompositeResultBlink,
    EventChannelPluginCompositeBrightness,
    EventChannelPluginCompositeCutoutVisibility,
    EventChannelPluginCompositeVibrate,
    EventChannelPluginCompositeAllResultsReceived,
    EventChannelPluginCompositeErrorFound,
    EventChannelPluginCompositeDebug1,
    EventChannelPluginCompositeScanInfo,

    // ScanView
    EventChannelScanViewMotionExceededThreshold,
    EventChannelScanViewNativeBarcodeDetected,
};

@protocol ALEventSubscribing <NSObject>

@end


@protocol ALEventProviding
// NOTE: callbacks are called in the same thread/queue from where the pushEvent happens!
- (id<NSObject>)subscribe:(NewEventBlock)block;

- (id<NSObject>)subscribe:(id<ALEventSubscribing> _Nullable)subscriber
                 callback:(NewEventBlock)block;

- (void)unsubscribeFromNewEvents:(id<ALEventSubscribing>)subscriber;

- (void)pushEvent:(ALEvent *)event;

@end


// the base class for event providers. NSNotificationCenter injectable.
@interface ALEventProvider : NSObject<ALEventProviding>

- (instancetype)initWithChannel:(EventChannel)eventChannel;

- (instancetype)initWithChannel:(EventChannel)eventChannel
             notificationCenter:(NSNotificationCenter * _Nullable)notificationCenter;

@property (nonatomic, readonly) int subscriberCount;

@end

NS_ASSUME_NONNULL_END
