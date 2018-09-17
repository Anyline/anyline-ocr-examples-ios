//
//  ALScanView.h
//  Anyline
//
//  Created by Daniel Albertini on 30/05/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALCaptureDeviceManager.h"
#import "ALAbstractScanViewPlugin.h"

#import "ALVisualFeedbackOverlay.h"
#import "ALCutoutView.h"
#import "ALUIFeedback.h"

#import "ALFlashButton.h"
#import "ALTorchManager.h"

@interface ALScanView : UIView

//@property (nullable, nonatomic, strong) ALCutoutView *cutoutView;
//@property (nullable, nonatomic, strong) ALVisualFeedbackOverlay *visualFeedbackOverlay;
@property (nullable, nonatomic, strong) ALUIFeedback *uiOverlayView;

@property (nonatomic, strong) ALCameraConfig * _Nullable cameraConfig;
@property (nonatomic, strong) ALFlashButtonConfig * _Nullable flashButtonConfig;

@property (nullable, nonatomic, strong) ALFlashButton *flashButton;
@property (nullable, nonatomic, strong) ALTorchManager *torchManager;

@property (nonatomic, strong) ALCaptureDeviceManager * _Nullable captureDeviceManager;
@property (nonatomic, strong) ALAbstractScanViewPlugin *_Nullable scanViewPlugin;

/**
 * Returns the bounding Rect of the visible WatermarkView with the correct location on the Module View.
 *
 * @warning May be nil before the layout process is completed or the license is not community.
 */
@property (nonatomic, readonly) CGRect watermarkRect;

- (_Nullable instancetype)initWithCameraConfig:(ALCameraConfig *_Nonnull)cameraConfig
                             flashButtonConfig:(ALFlashButtonConfig *_Nonnull)flashButtonConfig
                                scanViewPlugin:(ALAbstractScanViewPlugin * _Nullable)scanViewPlugin;

- (_Nullable instancetype)initWithScanViewPlugin:(ALAbstractScanViewPlugin * _Nullable)scanViewPlugin;

+ (_Nullable instancetype)scanViewForFrame:(CGRect)frame
                                configPath:(NSString *_Nonnull)configPath
                                licenseKey:(NSString *_Nonnull)licenseKey
                                  delegate:(id _Nonnull)delegate
                                     error:(NSError *_Nullable *_Nullable)error;

- (void)startCamera;

- (void)stopCamera;

- (void)updateDispatchTimer;

- (void)updateTextRect:(ALSquare *_Nonnull)square;

- (void)updateCutoutView:(ALCutoutConfig *_Nonnull)cutoutConfig;

- (void)updateVisualFeedbackView:(ALScanFeedbackConfig *_Nonnull)scanFeedbackConfig;

- (void)updateWebView:(ALScanViewPluginConfig *_Nonnull)config;

@end
