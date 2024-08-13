#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ALScanViewPlugin.h"
#import "ALScanViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class ALScanViewInitializationParameters;
@protocol ALScanViewDelegate;

/// The visible component that manages the acquisition of image frames from the device,
/// as well as user input, and passes them to the scan plugin for processing
@interface ALScanView : UIView

/// Initializes an `ALScanView` object with a scan view plugin, and a scan view config object
/// @param frame the frame of the scan view within the view hierarchy
/// @param scanViewPlugin an `ALScanViewPlugin` object
/// @param scanViewConfig an optional `ALScanViewConfig` object. Defaults will be assumed if null
/// @param error if error is encountered while initializing the ScanView object, this will be
/// populated with the reasons for the failure
/// @return the `ALScanView` object
- (_Nullable instancetype)initWithFrame:(CGRect)frame
                         scanViewPlugin:(NSObject<ALViewPluginBase> * _Nullable)scanViewPlugin
                         scanViewConfig:(ALScanViewConfig * _Nullable)scanViewConfig
                                  error:(NSError * _Nullable * _Nullable)error;

/// Initializes an `ALScanView` object with a scan view plugin
/// @param frame the frame of the scan view within the view hierarchy
/// @param scanViewPlugin an `ALScanViewPlugin` object
/// @param error if error is encountered while initializing the ScanView object, this will be
/// populated with the reasons for the failure
/// @return the `ALScanView` object
- (_Nullable instancetype)initWithFrame:(CGRect)frame
                         scanViewPlugin:(NSObject<ALViewPluginBase> *)scanViewPlugin
                                  error:(NSError * _Nullable * _Nullable)error;

/// Initializes an `ALScanView` object with a scan view config. Delegates to scan view
/// and underlying components are not set, and will have to be done separately.
/// @param frame the frame of the scan view within the view hierarchy
/// @param scanViewConfig an `ALScanViewConfig` object
/// @param error if error is encountered while initializing the ScanView object, this will be
/// populated with the reasons for the failure
- (_Nullable instancetype)initWithFrame:(CGRect)frame
                         scanViewConfig:(ALScanViewConfig *)scanViewConfig
                                  error:(NSError * _Nullable * _Nullable)error;

/// Update a scan view with a different view plugin. The visual elements displayed
/// will also be updated. The view plugin replaced is stopped, and the new view plugin
/// is not assumed to have been started automatically. Likewise, this view plugin's
/// delegates should be set separately.
/// @param viewPlugin a different view plugin
/// @param error if error is encountered while setting the ScanViewPlugin object, this will be
/// populated with the reason for the failure
/// @return a boolean indicating whether or not the operation succeeded.
- (BOOL)setViewPlugin:(NSObject<ALViewPluginBase> *)viewPlugin
                error:(NSError * _Nullable * _Nullable)error;

/// Update a scan view with a different view plugin config. Any existing cutout and feedback
/// layers will also be updated. This will stop scanning. Delegates to new underlying
/// and underlying components are not set, and will have to be done separately.
/// @param viewPluginConfig the view plugin config to be applied to the scan view
/// @param error if error is encountered while setting the ScanViewPluginConfig object, this will be
/// populated with the reason for the failure
/// @return a boolean indicating whether or not the operation succeeded.
- (BOOL)setViewPluginConfig:(ALViewPluginConfig *)viewPluginConfig
                      error:(NSError * _Nullable * _Nullable)error;

/// Update a scan view with a different view plugin composite config. Any existing cutout and feedback
/// layers will also be updated. Delegates to scan view  and underlying components are not set, and will
/// have to be done separately.
/// @param viewPluginCompositeConfig the view plugin composite config to be applied to the scan view
/// @param error if error is encountered while setting the ALViewPluginCompositeConfig object, this will be
/// populated with the reason for the failure
/// @return a boolean indicating whether or not the operation succeeded.
- (BOOL)setViewPluginCompositeConfig:(ALViewPluginCompositeConfig *)viewPluginCompositeConfig
                               error:(NSError * _Nullable * _Nullable)error;


/// Initializes an `ALScanView` object with a scan view plugin, and a scan view config object
/// @param frame the frame of the scan view within the view hierarchy
/// @param scanViewPlugin an `ALScanViewPlugin` object
/// @param scanViewConfig an optional `ALScanViewConfig` object. Defaults will be assumed if null
/// @param initializationParams an optional object containing additional parameters to configure plugin behavior
/// @param error if error is encountered while initializing the ScanView object, this will be
/// populated with the reasons for the failure
/// @return the `ALScanView` object
- (_Nullable instancetype)initWithFrame:(CGRect)frame
                         scanViewPlugin:(NSObject<ALViewPluginBase> * _Nullable)scanViewPlugin
                         scanViewConfig:(ALScanViewConfig * _Nullable)scanViewConfig
                   initializationParams:(ALScanViewInitializationParameters * _Nullable)initializationParams
                                  error:(NSError * _Nullable * _Nullable)error;

/// Initializes an `ALScanView` object with a scan view plugin
/// @param frame the frame of the scan view within the view hierarchy
/// @param scanViewPlugin an `ALScanViewPlugin` object
/// @param initializationParams an optional object containing additional parameters to configure plugin behavior
/// @param error if error is encountered while initializing the ScanView object, this will be
/// populated with the reasons for the failure
/// @return the `ALScanView` object
- (_Nullable instancetype)initWithFrame:(CGRect)frame
                         scanViewPlugin:(NSObject<ALViewPluginBase> *)scanViewPlugin
                   initializationParams:(ALScanViewInitializationParameters * _Nullable)initializationParams
                                  error:(NSError * _Nullable * _Nullable)error;

/// Initializes an `ALScanView` object with a scan view config. Delegates to scan view
/// and underlying components are not set, and will have to be done separately.
/// @param frame the frame of the scan view within the view hierarchy
/// @param scanViewConfig an `ALScanViewConfig` object
/// @param initializationParams an optional object containing additional parameters to configure plugin behavior
/// @param error if error is encountered while initializing the ScanView object, this will be
/// populated with the reasons for the failure
- (_Nullable instancetype)initWithFrame:(CGRect)frame
                         scanViewConfig:(ALScanViewConfig *)scanViewConfig
                   initializationParams:(ALScanViewInitializationParameters * _Nullable)initializationParams
                                  error:(NSError * _Nullable * _Nullable)error;

/// Update a scan view with a different view plugin. The visual elements displayed
/// will also be updated. The view plugin replaced is stopped, and the new view plugin
/// is not assumed to have been started automatically. Likewise, this view plugin's
/// delegates should be set separately.
/// @param viewPlugin a different view plugin
/// @param initializationParams an optional object containing additional parameters to configure plugin behavior
/// @param error if error is encountered while setting the ScanViewPlugin object, this will be
/// populated with the reason for the failure
/// @return a boolean indicating whether or not the operation succeeded.
- (BOOL)setViewPlugin:(NSObject<ALViewPluginBase> *)viewPlugin
 initializationParams:(ALScanViewInitializationParameters * _Nullable)initializationParams
                error:(NSError * _Nullable * _Nullable)error;

/// Update a scan view with a different view plugin config. Any existing cutout and feedback
/// layers will also be updated. This will stop scanning. Delegates to new underlying
/// and underlying components are not set, and will have to be done separately.
/// @param viewPluginConfig the view plugin config to be applied to the scan view
/// @param initializationParams an optional object containing additional parameters to configure plugin behavior
/// @param error if error is encountered while setting the ScanViewPluginConfig object, this will be
/// populated with the reason for the failure
/// @return a boolean indicating whether or not the operation succeeded.
- (BOOL)setViewPluginConfig:(ALViewPluginConfig *)viewPluginConfig
       initializationParams:(ALScanViewInitializationParameters * _Nullable)initializationParams
                      error:(NSError * _Nullable * _Nullable)error;

/// Update a scan view with a different view plugin composite config. Any existing cutout and feedback
/// layers will also be updated. Delegates to scan view  and underlying components are not set, and will
/// have to be done separately.
/// @param viewPluginCompositeConfig the view plugin composite config to be applied to the scan view
/// @param initializationParams an optional object containing additional parameters to configure plugin behavior
/// @param error if error is encountered while setting the ALViewPluginCompositeConfig object, this will be
/// populated with the reason for the failure
/// @return a boolean indicating whether or not the operation succeeded.
- (BOOL)setViewPluginCompositeConfig:(ALViewPluginCompositeConfig *)viewPluginCompositeConfig
                initializationParams:(ALScanViewInitializationParameters * _Nullable)initializationParams
                               error:(NSError * _Nullable * _Nullable)error;


/// The object to be notified of events reported by the scan view
@property (nonatomic, weak) id<ALScanViewDelegate> delegate;

/// The scan view plugin instance
@property (nonatomic, readonly) NSObject<ALViewPluginBase> *viewPlugin;

/// The frame of the visible flash toggle button. The frame can be useful for some
/// operations done on the UI layer
@property (nonatomic, readonly) CGRect flashButtonFrame;

/// The scan view config passed to this object during initialization
@property (nonatomic, readonly) ALScanViewConfig * _Nullable scanViewConfig;

/// Enable native barcode scanning by providing a list of valid barcode formats to use.
/// You may also set an empty array to scan all possible types (may impact performance),
/// or null to disable. In either case, do so before calling `startCamera`. This is by
/// default null.
@property (nonatomic, strong, nullable) NSArray<AVMetadataObjectType> *supportedNativeBarcodeFormats;

@property (nonatomic, readonly, nullable) ALScanViewInitializationParameters *initializationParams;

/// Starts the scan view camera
- (void)startCamera;

/// Stops the scan view camera
- (void)stopCamera;

/// Starts scanning with the provided Anyline configuration. If `viewPlugin` is nil,
/// an error object is thrown.
/// - Parameter error: error object containing the reason for the error
- (BOOL)startScanningWithError:(NSError * _Nullable * _Nullable)error;

/// Stops scanning. If `viewPlugin` is nil, an error object is thrown.
/// - Parameter error: error object containing the reason for the error
- (BOOL)stopScanningWithError:(NSError * _Nullable * _Nullable)error;

@end


/// Object that is notified when an `ALScanView` reports events of interest
@protocol ALScanViewDelegate <NSObject>

@optional

/// This method is called when the scan view has managed to detect large and sustained movement
/// of the device during scanning, degrading scanning performance. This can be utilized to inform
/// the user to limit shaking as much as possible
/// @param scanView the scan view calling this method
- (void)scanViewMotionExceededThreshold:(ALScanView *)scanView;

/// This method is called to report any barcodes found on the frame by the iOS native barcode scanner.
/// Note, that the quality of the results may not match those of the Anyline Barcode plugin and the
/// performance is not expected to be as good.
/// @param scanView the scan view calling this method
/// @param scanResult the barcode scan results
- (void)scanView:(ALScanView *)scanView didReceiveNativeBarcodeResult:(ALScanResult *)scanResult;

/// This method is called to report the latest `CGRect` frame of the cutout in display. An interesting
/// way this could be utilized is to position any UI overlays / prompts over the scan view cutout.
/// @param scanView the scan view calling this method
/// @param frame the size and position of the cutout. If the cutout was hidden, the reported frame is null
/// @param pluginID the ID of the plugin, useful in a composite scanning setup
- (void)scanView:(ALScanView *)scanView updatedCutoutWithPluginID:(NSString *)pluginID frame:(CGRect)frame;

/// This method is called when a the scan view encountered an error during scanning.
/// @param scanView the scan view calling this method
/// @param error an NSError object holding information about the error encountered
- (void)scanView:(ALScanView *)scanView encounteredError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
