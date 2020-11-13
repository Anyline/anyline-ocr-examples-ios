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

#import "ALCutoutView.h"
#import "ALUIFeedback.h"

#import "ALFlashButton.h"
#import "ALTorchManager.h"

@interface ALScanView : UIView

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

/**
 Constructor for ScanView

 @param frame The frame for the ScanView
 @param scanViewPlugin The ScanViewPlugin which you want to use for scanning (ID,Meter, Barcode, OCR or LicensePlate)
 @return An instance of a ScanView
 */
- (_Nullable instancetype)initWithFrame:(CGRect)frame
                         scanViewPlugin:(ALAbstractScanViewPlugin * _Nullable)scanViewPlugin;


/**
  Constructor for ScanView

 @param frame The frame for the ScanView
 @param scanViewPlugin The ScanViewPlugin which you want to use for scanning (ID,Meter, Barcode, OCR or LicensePlate)
 @param cameraConfig The CameraConfig for the ScanView
 @param flashButtonConfig The flashButtonCOnfig for the ScanView
 @return An instance of a ScanView
 */
- (_Nullable instancetype)initWithFrame:(CGRect)frame
                         scanViewPlugin:(ALAbstractScanViewPlugin * _Nullable)scanViewPlugin
                           cameraConfig:(ALCameraConfig *_Nonnull)cameraConfig
                      flashButtonConfig:(ALFlashButtonConfig *_Nonnull)flashButtonConfig;

/**
 Constructor to setup Anyline with a JSon Config.

 @param frame The frame for the ScanView
 @param configPath An absolute path to the Anyline json config file
 @param licenseKey The Anyline license key
 @param delegate The delegate which will be called when scanning (ALIDPluginDelegate, ALOCRScanPluginDelegate,
                 ALMeterScanPluginDelegate, ALBarcodeScanPluginDelegate, ALDocumentScanPluginDelegate or ALLicensePlateScanPluginDelegate)
 @param error The error if something goes wrong during setup
 @return Boolean indicating the success of the setup
 */
+ (_Nullable instancetype)scanViewForFrame:(CGRect)frame
                                configPath:(NSString *_Nonnull)configPath
                                  delegate:(id _Nonnull)delegate
                                     error:(NSError *_Nullable *_Nullable)error;

/**
 Constructor to setup Anyline with a JSon Config.

 @param frame The frame for the ScanView
 @param configDict A dictionary representing an Anyline json config
 @param licenseKey The Anyline license key
 @param delegate The delegate which will be called when scanning (ALIDPluginDelegate, ALOCRScanPluginDelegate,
                 ALMeterScanPluginDelegate, ALBarcodeScanPluginDelegate, ALDocumentScanPluginDelegate or ALLicensePlateScanPluginDelegate)
 @param error The error if something goes wrong during setup
 @return Boolean indicating the success of the setup
 */
+ (_Nullable instancetype)scanViewForFrame:(CGRect)frame
                                configDict:(NSDictionary *_Nonnull)configDict
                                  delegate:(id _Nonnull)delegate
                                     error:(NSError *_Nullable *_Nullable)error;

/**
 Starts the camera on an async thread
 */
- (void)startCamera;
/**
 Stops the camera
 */
- (void)stopCamera;



/**
 Methods for updating the UI
 */

- (void)updateTextRect:(ALSquare *_Nonnull)square forPluginID:(NSString *_Nonnull)pluginID;

- (void)updateCutoutView:(ALCutoutConfig *_Nonnull)cutoutConfig;

- (void)updateVisualFeedbackView:(ALScanFeedbackConfig *_Nonnull)scanFeedbackConfig;

- (void)updateWebView:(ALScanViewPluginConfig *_Nonnull)config   forPluginID:(NSString *_Nonnull)pluginID;
- (void)updateWebViewWithMultipleConfigs:(NSDictionary<NSString *,ALScanViewPluginConfig *> *_Nonnull)configs visiblePlugins:(NSSet<NSString *> *_Nonnull)visible;

/**
 * Zoom Features
 * @param enabled Whether to enable the pinch gesture to zoom in and out
 */
- (void)enableZoomPinchGesture:(BOOL)enabled;

@end
