#import <Foundation/Foundation.h>
#import "ALImageProviding.h"
#import "ALCaptureDeviceManager.h" // AnylineVideoDataSampleBufferDelegate

NS_ASSUME_NONNULL_BEGIN

/// Internal DI seam — a **private** framework header (`Anyline/Platform/`), not shipped in the public
/// framework. Its only external-facing use case, frame-replay test injection, is exposed through the public
/// `ALFrameReplayCustomCamera` convenience, which wires this up internally so callers never touch this header.
///
/// Supplies a custom frame source to the SDK when an `ALScanView` is constructed, via dependency injection
/// rather than a constructor. Register a provider on `ALCustomFrameSourceProviderRegistry` **before** creating
/// the ScanView; the ScanView reads it during construction and builds its frame source (no `AVCaptureSession`,
/// no camera-permission prompt). If no provider is registered, the ScanView uses the built-in device camera.
@protocol ALCustomFrameSourceProvider <NSObject>

/// Return a fresh frame source for the ScanView being constructed. The SDK then calls
/// `-configureWithScanViewConfig:` on it to hand over the config and learn its frame size.
- (NSObject<ALImageProviding, AnylineVideoDataSampleBufferDelegate> *)provideImageProvider;

@end

/// Process-global registry for the custom-frame-source provider (the DI switch).
///
/// Once set, EVERY ScanView created anywhere uses it until cleared — clear it (`setProvider:nil`) once the
/// custom-source screen is gone, otherwise unrelated ScanViews would inadvertently receive a custom source.
/// Register/clear from the main thread only; the backing field is not synchronized.
@interface ALCustomFrameSourceProviderRegistry : NSObject

+ (nullable id<ALCustomFrameSourceProvider>)provider;
+ (void)setProvider:(nullable id<ALCustomFrameSourceProvider>)provider;

@end

/// Convenience `ALCustomFrameSourceProvider` backed by a block — ergonomic for tests and simple integrations.
@interface ALBlockCustomFrameSourceProvider : NSObject <ALCustomFrameSourceProvider>

+ (instancetype)providerWithBlock:(NSObject<ALImageProviding, AnylineVideoDataSampleBufferDelegate> *(^)(void))block;

@end

NS_ASSUME_NONNULL_END