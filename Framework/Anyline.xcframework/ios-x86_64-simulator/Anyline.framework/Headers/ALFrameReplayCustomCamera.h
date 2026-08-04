#import <Foundation/Foundation.h>

@class ALFrameReplayCutoutSlideshowConfig;
@class UIImage;

NS_ASSUME_NONNULL_BEGIN

/// Drives scanning from recorded frames instead of the device camera, for integration testing. It
/// installs a config-driven frame source that replays a cutout slideshow into a newly created `ALScanView`.
///
/// Register a config before the `ALScanView` is created; the ScanView reads it during construction. Call
/// `clearInstance` when the test is finished so later scan views use the device camera again. Register and
/// clear on the main thread.
///
/// Intended for integration-test harnesses; reachable via `#import <Anyline/ALFrameReplayCustomCamera.h>`.
@interface ALFrameReplayCustomCamera : NSObject

/// Install the replay frame source built from `config`. Call before creating the `ALScanView`.
///
/// @param config      the cutout-slideshow config, parsed from a fixture file (for example with
///                    `+[ALFrameReplayCutoutSlideshowConfig fromJSON:encoding:error:]`).
/// @param imageLoader resolves a slide's `imagePath` to a `UIImage`, typically from the caller's own
///                    bundle. Return nil to skip a slide.
+ (void)setInstanceWithConfig:(ALFrameReplayCutoutSlideshowConfig *)config
                  imageLoader:(UIImage * _Nullable (^)(NSString *imagePath))imageLoader;

/// Clear the installed replay frame source. Later `ALScanView`s use the device camera.
+ (void)clearInstance;

@end

NS_ASSUME_NONNULL_END