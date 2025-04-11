#ifndef ALScanView_Private_h
#define ALScanView_Private_h

#import <Anyline/Anyline-Swift.h>

// forward declarations
typedef NS_ENUM(NSUInteger, ALScanFeedbackType);
@class ALCaptureDeviceManager;
@class ALScanFeedbackViewFactory;
@class ALUIFeedbackElementConfig;
@class ALScanViewInitializationParameters;
@protocol ALImageProviding;
@protocol ALEventProviding;
@protocol AnylineVideoDataSampleBufferDelegate;
@protocol ALScanFeedback;

NS_ASSUME_NONNULL_BEGIN

@protocol ALScanViewFeedbackDelegate <NSObject>

// TODO: has to be expose a public type, maybe the element's ID.
- (void)scanView:(ALScanView *)scanView selectedFeedbackElementWithConfig:(ALUIFeedbackElementConfig *)elementConfig pluginID:(NSString *)pluginID;

@end


@interface ALScanView (Private)

- (_Nullable instancetype)initWithFrame:(CGRect)frame
                         scanViewPlugin:(NSObject<ALViewPluginBase> *)scanViewPlugin
                         scanViewConfig:(ALScanViewConfig *)scanViewConfig
                   captureDeviceManager:(ALCaptureDeviceManager * _Nullable)captureDeviceManager
                          imageProvider:(NSObject<ALImageProviding, AnylineVideoDataSampleBufferDelegate> *)imageProvider
                    feedbackViewFactory:(ALScanFeedbackViewFactory * _Nullable)feedbackLayerFactory
                   initializationParams:(ALScanViewInitializationParameters * _Nullable)initializationParams
                                  error:(NSError * _Nullable * _Nullable)error;

+ (NSDictionary<NSString *, ALViewPluginConfig *> *)pluginMappingsOfType:(ALScanFeedbackType)type
                                                                  viewPlugin:(NSObject<ALViewPluginBase> *)viewPlugin;

/// An event provider to inform subscribers when too much motion is currently
/// detected while the scan view is running, which poses problems for object
/// detection.
@property (nonatomic, readonly) id<ALEventProviding> motionExceededThreshold;

/// When native barcode mode is enabled, subscribers to this event provider
/// will be able to obtain any applicable barcode results emitted back. Note
/// that native barcode scanning as a feature is different from the ScanPlugin
/// with a barcode config
@property (nonatomic, readonly) id<ALEventProviding> nativeBarcodeResult;

/// As there are potentially two feedback layers in play (native and web), we
/// need to know to which one is visible at a given time. For instance, with
/// parallel scanning, we can have both being shown simultaneously if for instance
/// at least one plugin uses web and at least one other is using native feedback.
@property (nonatomic, readonly) NSSet<UIView<ALScanFeedback> *> *visibleFeedbackViews;

@property (nonatomic, weak) id<ALScanViewFeedbackDelegate> feedbackDelegate;

@end


NS_ASSUME_NONNULL_END

#endif /* ALScanView_Private_h */
