#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class ALCameraConfig;
@class ALImageProvider;

@protocol AnylineVideoDataSampleBufferDelegate;
@protocol AnylineNativeBarcodeDelegate;


NS_ASSUME_NONNULL_BEGIN

@interface ALCaptureDeviceManager : NSObject

- (instancetype _Nullable)initWithCameraConfig:(ALCameraConfig *)cameraConfig
                                    videoQueue:(dispatch_queue_t _Nullable)videoQueue;

/// The native barcode recognition delegate. Implement this delegate to receive barcodes
/// results during scanning.
///
/// @warning Do not implement this delegate when you use the Barcode module.
@property (nonatomic, strong, readonly) NSPointerArray<AnylineNativeBarcodeDelegate> *barcodeDelegates;

/// The sample buffer delegate gives you access to the video frames. You will
/// get frames around 25 times per second. Do only access as much frames as you need,
/// otherwise the performance will suffer.
@property (nonatomic, strong, readonly) NSPointerArray<AnylineVideoDataSampleBufferDelegate> *sampleBufferDelegates;

@property (nullable, nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

// ACO only used to initialize the torch view by ScanView
@property (nullable, nonatomic, strong) AVCaptureDevice *captureDevice;

@property (nonatomic, readonly) UIInterfaceOrientation orientation;

@property (nonatomic, readonly) CGSize cameraResolution;

@property (nonatomic, readonly) BOOL isFrontCamera;

@property (nonatomic, assign) CGFloat zoomLevel;

// MARK: - Manage session

- (void)startSession;

- (void)stopSession;

// Sample Buffer Delegate

- (void)addSampleBufferDelegate:(id<AnylineVideoDataSampleBufferDelegate>)delegate;

- (void)removeSampleBufferDelegate:(id<AnylineVideoDataSampleBufferDelegate>)delegate;

- (void)removeAllSampleBufferDelegates;

// Applying the video preview layer to a view


/// "ROI" is the rectangular region within the sample buffer frame that corresponds to
/// the cutout bounds displayed over camera preview layer of the scanview. Note that the
/// ROI is expressed in terms of the total image resolution (configurable from cameraConfig)
/// of the sample buffer. It is computed by taking the cutout frame based on the preview layer's
/// (hence scanview's) coordinate system, and translating it into the buffer coordinate system.
///
/// @param cutoutRect the cutout frame returned by the scan view feedback layer as determined
/// from the scan plugin config
/// @param cropOffset the crop offset as defined by the scan view plugin config
/// @param cropPadding the crop padding as defined by the scan view plugin config
/// @param pluginID the ID of the plugin making the call
- (CGRect)ROIForPreviewLayerWithPluginID:(NSString *)pluginID
                             cutoutFrame:(CGRect)cutoutRect
                              cropOffset:(CGPoint)cropOffset
                             cropPadding:(CGSize)cropPadding;

- (void)addVideoLayerOnView:(UIView *)view;

- (void)updateVideoLayer:(UIView *)view;

// Configure Camera

- (void)setFocusAndExposurePoint:(CGPoint)point;

- (void)setZoomGestureLevel:(CGFloat)velocity;

// Native Barcode Support

/// To enable native barcode detection, call this prior to starting the session.
/// Afterwards adding a barcode delegate is also necessary.
///
/// @param formats a list of native barcode formats (AVMetadataObjectType)
/// @param error error object when native barcode was for any reason unavailable
- (void)enableNativeBarcodeWithFormats:(NSArray * _Nullable)formats
                                 error:(NSError * _Nullable * _Nullable)error;

- (BOOL)addBarcodeDelegate:(id<AnylineNativeBarcodeDelegate>)delegate
                     error:(NSError * _Nullable * _Nullable)error;

- (void)removeBarcodeDelegate:(id<AnylineNativeBarcodeDelegate>)delegate;

@end


@protocol AnylineNativeBarcodeDelegate <NSObject>

///  Called whenever Apple finds a new barcode in the frame. The same barcode
///  can also be found in multiple frames, then the delegate will be called
///  multiple times.
///
///  @param captureDeviceManager The ALCaptureDeviceManager object
///  @param scanResult The scanned barcode value as NSString
///  @param barcodeType The iOS Barcode type. see AVMetaDataObject documentation for
///  all the types.
- (void)anylineCaptureDeviceManager:(ALCaptureDeviceManager *)captureDeviceManager
               didFindBarcodeResult:(NSString *)scanResult
                               type:(NSString *)barcodeType;

@end


@protocol AnylineVideoDataSampleBufferDelegate <NSObject>

/// Called whenever an AVCaptureVideoDataOutput instance outputs a new video
/// frame. For more information look at the Apple AVCaptureSession documentation.
///
/// @param captureDeviceManager The ALCaptureDeviceManager object
/// @param sampleBuffer A CMSampleBuffer object containing the video frame data
/// and additional information about the frame, such as its format and presentation time.
- (void)anylineCaptureDeviceManager:(ALCaptureDeviceManager *)captureDeviceManager
              didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
