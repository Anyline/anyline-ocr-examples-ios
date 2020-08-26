//
//  ALCaptureDeviceManager.h
//  Anyline
//
//  Created by Daniel Albertini on 16/06/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "ALViewConstants.h"
#import "ALSquare.h"
#import "ALCameraConfig.h"

@protocol AnylineVideoDataSampleBufferDelegate;
@protocol AnylineNativeBarcodeDelegate;

@interface ALCaptureDeviceManager : NSObject

- (instancetype _Nullable )initWithCameraConfig:(ALCameraConfig *_Nonnull)cameraConfig;

/**
 The native Barcode Recognition Delegate. Implement this delegate to receive barcodes results during scanning.
 
 @warning Do not implement this delegate when you use the Barcode module.
 */
@property (nonatomic, strong, readonly) NSHashTable<AnylineNativeBarcodeDelegate> * _Nullable barcodeDelegates;
/**
 The Sample Buffer Delegate gives you access to the video frames. You will get frames around 25 times per second. Do only access as much frames as you need, otherwise the performance will suffer.
 */
@property (nonatomic, strong, readonly) NSHashTable<AnylineVideoDataSampleBufferDelegate> * _Nullable sampleBufferDelegates;

@property (nullable, nonatomic, strong) ALCameraConfig *cameraConfig;

@property (nullable, nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nullable, nonatomic, strong) AVCaptureDevice *captureDevice;

@property (nullable, nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, assign) CGSize videoResolution;

- (void)addBarcodeDelegate:(id<AnylineNativeBarcodeDelegate> _Nonnull)delegate __deprecated_msg("Deprecated since 4. Use method addBarcodeDelegate:error: instead.");

- (BOOL)addBarcodeDelegate:(id<AnylineNativeBarcodeDelegate> _Nonnull)delegate error:(NSError *_Nullable*_Nullable)error;

- (void)removeBarcodeDelegate:(id<AnylineNativeBarcodeDelegate> _Nonnull)delegate;

- (void)addSampleBufferDelegate:(id<AnylineVideoDataSampleBufferDelegate> _Nonnull)delegate;

- (void)removeSampleBufferDelegate:(id<AnylineVideoDataSampleBufferDelegate> _Nonnull)delegate;

- (void)addVideoLayerOnView:(UIView * _Nonnull)view;
- (void)updateVideoLayer:(UIView * _Nonnull)view;

- (void)setFocusAndExposurePoint:(CGPoint)point;

- (void)setZoomLevel:(CGFloat)zoomFactor;
- (void)setZoomGestureLevel:(CGFloat)velocity;
- (CGFloat)minAvailableVideoZoomFactor;
- (CGFloat)maxAvailableVideoZoomFactor;
- (void)setMaxVideoZoomFactor:(CGFloat)factor;

- (CGFloat)currentFocalLength;
- (CGFloat)currentZoomRatio;
- (CGFloat)currentVideoZoomFactor;

- (void)startSession;

- (void)stopSession;

- (BOOL)isRunning;

- (CGPoint)fullResolutionPointForPointInPreview:(CGPoint)inPoint;

- (UIInterfaceOrientation)currentInterfaceOrientation;

- (void)setNativeBarcodeFormats:(NSArray * _Nullable)formats;

+ (AVAuthorizationStatus)cameraPermissionStatus;

+ (void)requestCameraPermission:(void (^_Nonnull)(BOOL granted))handler;

- (void)captureStillImageAsynchronously;

@end

@protocol AnylineVideoDataSampleBufferDelegate <NSObject>

@required
/**
 Called whenever an AVCaptureVideoDataOutput instance outputs a new video frame. For more information look at the Apple AVCaptureSession documentation.
 
 @param captureDeviceManager The ALCaptureDeviceManager object
 @param sampleBuffer A CMSampleBuffer object containing the video frame data and additional information about the frame, such as its format and presentation time.
 */
- (void)anylineCaptureDeviceManager:(ALCaptureDeviceManager * _Nonnull)captureDeviceManager
              didOutputSampleBuffer:(CMSampleBufferRef _Nonnull)sampleBuffer;

- (void)anylineCaptureDeviceManager:(ALCaptureDeviceManager * _Nonnull)captureDeviceManager
         didOutputPhotoSampleBuffer:(CMSampleBufferRef _Nonnull)sampleBuffer;

@end

@protocol AnylineNativeBarcodeDelegate <NSObject>

@required
/**
 Called whenever Apple finds a new Barcode in the frame. The same barcode can also be found in multiple frames, then the delegate will be called multiple times.
 
 @param captureDeviceManager The ALCaptureDeviceManager object
 @param scanResult The scanned barcode value as NSString
 @param barcodeType The iOS Barcode type. see AVMetaDataObject documentation for all the types.
 */
- (void)anylineCaptureDeviceManager:(ALCaptureDeviceManager * _Nonnull)captureDeviceManager
               didFindBarcodeResult:(NSString * _Nonnull)scanResult
                               type:(NSString * _Nonnull)barcodeType;

@end

