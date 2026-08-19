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

/// Called with the complete set of plugin IDs whose cutout is currently visible, whenever that set changes.
/// Each call REPLACES the previous set, so a source can composite only the plugins that are actually
/// scanning — for a composite that is one child at a time (sequential) or the children that have not yet
/// produced a result (parallel).
///
/// Prefer this over inferring visibility from a `CGRectZero` in `cutoutDidChangeForPluginID:frame:`. That
/// signal is per-plugin, so it can only ever say "this one went away": nothing re-announces a plugin that
/// becomes visible again, which makes hiding irreversible. This one is set-valued and therefore
/// self-correcting — a plugin momentarily missing from one call simply reappears in the next.
///
/// Optional, like the rest of this section: a source that does not implement it is never called, so the
/// built-in device-camera provider is unaffected. Of interest to a custom frame source that composites its
/// own frames, which is the only thing that has to decide which cutouts to paint.
- (void)visibleCutoutPluginIDsDidChange:(NSSet<NSString *> *)visiblePluginIDs;

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
