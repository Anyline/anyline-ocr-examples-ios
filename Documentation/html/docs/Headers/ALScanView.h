#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ALScanViewConfig.h"
#import "ALScanViewPlugin.h"

@protocol ALUIFeedback;

NS_ASSUME_NONNULL_BEGIN

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
                         scanViewPlugin:(id<ALScanViewPluginBase>)scanViewPlugin
                         scanViewConfig:(ALScanViewConfig * _Nullable)scanViewConfig
                                  error:(NSError * _Nullable * _Nullable)error;

/// Initializes an `ALScanView` object with a scan view plugin
/// @param frame the frame of the scan view within the view hierarchy
/// @param scanViewPlugin an `ALScanViewPlugin` object
/// @param error if error is encountered while initializing the ScanView object, this will be
/// populated with the reasons for the failure
/// @return the `ALScanView` object
- (_Nullable instancetype)initWithFrame:(CGRect)frame
                         scanViewPlugin:(id<ALScanViewPluginBase>)scanViewPlugin
                                  error:(NSError * _Nullable * _Nullable)error;

/// Update a scan view with a different scan view plugin. The cutout and feedback layers
/// will also be updated.
/// @param scanViewPlugin a different scan view plugin
/// @param error if error is encountered while setting the ScanViewPlugin object, this will be
/// populated with the reason for the failure
/// @return a boolean indicating whether or not the operation succeeded.
- (BOOL)setScanViewPlugin:(id<ALScanViewPluginBase>)scanViewPlugin
                    error:(NSError * _Nullable * _Nullable)error;

/// The object to be notified of events reported by the scan view
@property (nonatomic, weak) id<ALScanViewDelegate> delegate;

/// The scan view plugin instance
@property (nonatomic, readonly) id<ALScanViewPluginBase> scanViewPlugin;

/// The frame of the visible flash toggle button. The frame can be useful for some
/// operations done on the UI layer
@property (nonatomic, readonly) CGRect flashButtonFrame;

/// The scan view config passed to this object during initialization
@property (nonatomic, readonly) ALScanViewConfig * _Nullable scanViewConfig;

/// An event provider to inform subscribers when too much motion is currently
/// detected while the scan view is running, which poses problems for object
/// detection.
@property (nonatomic, readonly) id<ALEventProviding> motionExceededThreshold;

/// When native barcode mode is enabled, subscribers to this event provider
/// will be able to obtain any applicable barcode results emitted back. Note
/// that native barcode scanning as a feature is different from the ScanPlugin
/// with a barcode config
@property (nonatomic, readonly) id<ALEventProviding> nativeBarcodeResult;

/// Enable native barcode scanning by providing a list of valid barcode formats to use.
/// You may also set an empty array to scan all possible types (may impact performance),
/// or null to disable. In either case, do so before calling `startCamera`. This is by
/// default null.
@property (nonatomic, strong, nullable) NSArray<AVMetadataObjectType> *supportedNativeBarcodeFormats;

/// Copied from internal implementation of ALScanView, to make this visible to the tests.
/// As there are potentially two feedback layers in play (native and web), we
/// need to know to which one is visible at a given time. For instance, with
/// parallel scanning, we can have both being shown simultaneously if for instance
/// at least one plugin uses web and at least one other is using native feedback.
@property (nonatomic, readonly) NSSet<UIView<ALUIFeedback> *> *visibleFeedbackLayers;

/// Starts the scan view camera
- (void)startCamera;

/// Stops the scan view camera
- (void)stopCamera;

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

@end

NS_ASSUME_NONNULL_END
