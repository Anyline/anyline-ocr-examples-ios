#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ALFlashButton.h"

@interface ALTorchManager : NSObject <ALFlashButtonStatusDelegate>

@property (nonatomic, assign) ALFlashStatus flashStatus;

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
