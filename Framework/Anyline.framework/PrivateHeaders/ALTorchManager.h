#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ALFlashButton.h"

@class ALTorchManager;

/// Notified when the SDK's *logical* torch/flash state changes (on/off), independent of whether a
/// physical capture device is present. This lets a custom (no-device) frame source react to flash
/// decisions the same way the device torch would be toggled — e.g. a replay provider gating slides
/// on flash state (MSDK-1523 frame-source seam).
@protocol ALTorchManagerDelegate <NSObject>

- (void)torchManager:(ALTorchManager *)torchManager didUpdateTorchOn:(BOOL)torchOn;

@end

@interface ALTorchManager : NSObject <ALFlashButtonStatusDelegate>

@property (nonatomic, assign) ALFlashStatus flashStatus;

/// Logical torch state, tracked independently of the physical `AVCaptureDevice` (which may be
/// absent for a custom frame source). Source of truth for AUTO-mode toggling and delegate updates.
@property (nonatomic, readonly) BOOL torchOn;

/// Notified on every logical torch-state transition (works with or without a capture device).
@property (nonatomic, weak) id<ALTorchManagerDelegate> delegate;

//- (void)setBrightnessThresholdForAutoFlash:(int)brightness;
//- (void)setAutoFlashLimitWindow:(int)limitWindow;

/// light level beneath which a vote is made to turn on flash in AUTO mode. The higher
/// this is, the sooner it will happen. Default 50.
@property (nonatomic, assign) NSInteger autoFlashBrightnessThreshold;

/// how many consecutive "below threshold" brightness reports have to be made before turning
/// on the flash in AUTO mode. This serves to dampen flash toggle activity in cases where
/// brightness reports frequently linger near the threshold value. The lower this is, the more
/// sensitive to changes. Default 5.
@property (nonatomic, assign) NSInteger autoFlashLowBrightnessReportCount;
@property (nonatomic, assign) NSInteger autoFlashHighBrightnessReportCount;

- (void)resetLightLevelCounter;
- (void)calculateBrightnessCount:(float)brightness;
- (void)setTorch:(BOOL)onOff;
- (BOOL)torchAvailable;
- (BOOL)setTorchModeOnWithLevel:(float)torchLever error:(NSError *_Nullable *_Nullable)error;

- (_Nullable instancetype)initWithCaptureDevice:(AVCaptureDevice * _Nullable)captureDevice;

@end
