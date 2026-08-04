#ifndef ALImageProviding_h
#define ALImageProviding_h

NS_ASSUME_NONNULL_BEGIN

@class ALImage;
@class ALScanViewConfig;

typedef void (^NewImageBlock)(ALImage * _Nullable image, UIInterfaceOrientation orientation, BOOL isLeftRightFlipped, BOOL isTopBottomFlipped);

@protocol ALImageProviding

- (id<NSObject> _Nonnull)subscribeToNewImages:(NewImageBlock _Nonnull)block;

- (void)unsubscribeFromNewImages:(id _Nonnull)subscriber;

@property (nonatomic, assign) BOOL shouldDropFrames;

/// Indicates whether frames should be processed synchronously. Defaults to YES.
@property (nonatomic, assign) BOOL shouldProcessFramesSynchronized;

@optional

/// Called when the SDK's logical flash/torch state changes. A frame source with no physical torch can
/// implement this to react — e.g. gate which frames it emits on the current flash state.
- (void)flashStateDidChange:(BOOL)flashOn;

/// Called when a plugin's cutout rectangle changes (ScanView coordinate space); `CGRectZero` means the
/// cutout is currently hidden. A custom frame source can implement this to composite each plugin's frames
/// into its current cutout.
- (void)cutoutDidChangeForPluginID:(NSString *)pluginID frame:(CGRect)frame;

/// Hand the frame source the config this ScanView runs, so it can adapt its output, and return the pixel
/// size of the frames it will produce (the space its cutout ROIs are expressed in; the SDK adopts it as the
/// capture resolution for geometric ROI computation). Called during ScanView setup, before scanning. A custom
/// source can size the frames it produces from `cameraConfig.captureResolution` and flip them per
/// `cameraConfig.enableFlipFramesLeftRight`/`enableFlipFramesTopBottom`; the full config is available for
/// plugin-level needs (e.g. emitting YUV vs RGB per `barcodeConfig.fastProcessMode`).
- (CGSize)configureWithScanViewConfig:(ALScanViewConfig *)scanViewConfig;

@end

#endif /* ALImageProviding_h */

NS_ASSUME_NONNULL_END
