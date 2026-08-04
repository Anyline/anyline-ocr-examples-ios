#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ALImageProviding.h"
#import "ALCaptureDeviceManager.h" // AnylineVideoDataSampleBufferDelegate

@class ALFrameReplayCutoutSlideshowConfig;

NS_ASSUME_NONNULL_BEGIN

/// Deterministic frame-replay image source, plugged into a `ScanView` through the DI frame-source seam
/// (`ALCustomFrameSourceProvider`). Each frame is a `frameSize` canvas filled with the config's `backgroundColor`,
/// onto which the current slide of every active plugin is composited into that plugin's cutout (aspect-fit,
/// clipped) — with per-slide fade/zoom transitions and `flashVisibility` gating. The composited frame is fed
/// to the engine as an `ALImage` and shown in the ScanView preview.
///
/// Self-configuring: the SDK hands it the ScanViewConfig via `configureWithScanViewConfig:`, from which it
/// derives its output frame size (from `captureResolution`), the frame flips, and full-frame cutouts, and
/// returns that size (which the SDK adopts as the capture resolution). Cutout rects then arrive per plugin via
/// `cutoutDidChangeForPluginID:`. Self-driving: produces frames while subscribed, on the main run loop.
@interface ALFrameReplaySlideshowProvider : NSObject <ALImageProviding, AnylineVideoDataSampleBufferDelegate>

/// @param config the cutout-slideshow config (framework model, parsed from a fixture file).
/// @param imageLoader resolves a slide `imagePath` to a `UIImage` (the caller supplies fixture-bundle
///        resolution). Returning nil skips that slide.
+ (instancetype)providerWithConfig:(ALFrameReplayCutoutSlideshowConfig *)config
                       imageLoader:(UIImage * _Nullable (^)(NSString *imagePath))imageLoader;

@end

NS_ASSUME_NONNULL_END