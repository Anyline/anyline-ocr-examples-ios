//
//  ALAbstractScanViewPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 29/05/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALCameraView.h"
#import "ALCutoutView.h"
#import "ALFlashButton.h"
#import "ALTorchManager.h"
#import "ALVisualFeedbackOverlay.h"

#import "ALScanInfo.h"
#import "ALBasicConfig.h"
#import "ALAbstractScanPlugin.h"
#import "ALSampleBufferImageProvider.h"

@interface ALAbstractScanViewPlugin : UIView<ALInfoDelegate>

/**
 The video view which is responsible for video preview, frame extraction, ...
 */
@property (nullable, nonatomic, strong) ALCameraView *cameraView;

@property (nullable, nonatomic, strong) ALCaptureDeviceManager *captureDeviceManager;

@property (nullable, nonatomic, strong) ALSampleBufferImageProvider *sampleBufferImageProvider;

@property (nullable, nonatomic, strong) ALCutoutView *cutoutView;

@property (nullable, nonatomic, strong) ALFlashButton *flashButton;

@property (nullable, nonatomic, strong) ALTorchManager *torchManager;

@property (nullable, nonatomic, strong) ALVisualFeedbackOverlay *visualFeedbackOverlay;

@property (nullable, nonatomic, strong) ALSquare *outline;

@property (nullable, nonatomic, strong) ALImage *scanImage;

/**
 * The UI Configuration for the scanning UI
 */
@property (nullable, nonatomic, copy) ALBasicConfig *basicConfig;

/**
 * Returns the bounding Rect of the visible WatermarkView with the correct location on the Module View.
 *
 * @warning May be nil before the layout process is completed or the license is not community.
 */
@property (nonatomic, readonly) CGRect watermarkRect;

// Private Stuff

@property (nonatomic, assign) CGFloat scale;

@property (nullable, nonatomic, strong) NSArray<ALBasicConfig *> *uiConfigs;

- (void)customInit;

- (BOOL)startAndReturnError:(NSError * _Nullable * _Nullable)error;

- (BOOL)stopAndReturnError:(NSError * _Nullable * _Nullable)error;

/**
 * Stop listening for device motion.
 */
- (void)stopListeningForMotion;

- (void)triggerScannedFeedback;

- (NSArray * _Nonnull)convertContours:(ALContours * _Nonnull)contoursValue;

- (ALSquare * _Nonnull)convertCGRect:(NSValue * _Nonnull)concreteValue;

- (void)updateDispatchTimer;

@end
