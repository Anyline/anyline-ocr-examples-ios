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

@interface ALScanView : UIView

@property (nonatomic, strong) ALCameraConfig * _Nullable cameraConfig;
@property (nonatomic, strong) ALFlashButtonConfig * _Nullable flashButtonConfig;

@property (nonatomic, strong) ALCaptureDeviceManager * _Nullable captureDeviceManager;
@property (nonatomic, strong) ALAbstractScanViewPlugin *_Nullable scanViewPlugin;

@property (nullable, nonatomic, strong) ALFlashButton *flashButton;
@property (nullable, nonatomic, strong) ALTorchManager *torchManager;

- (_Nullable instancetype)initWithFrame:(CGRect)frame
                           cameraConfig:(ALCameraConfig *_Nonnull)cameraConfig
                      flashButtonConfig:(ALFlashButtonConfig *_Nonnull)flashButtonConfig
                         scanViewPlugin:(ALAbstractScanViewPlugin * _Nullable)scanViewPlugin;

- (_Nullable instancetype)initWithFrame:(CGRect)frame
                           cameraConfig:(ALCameraConfig *_Nonnull)cameraConfig
                      flashButtonConfig:(ALFlashButtonConfig *_Nonnull)flashButtonConfig;

- (void)startCamera;

- (void)stopCamera;

@end
