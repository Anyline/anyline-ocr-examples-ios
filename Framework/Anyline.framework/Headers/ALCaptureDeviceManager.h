//
//  ALCaptureDeviceManager.h
//  Anyline
//
//  Created by Daniel Albertini on 16/06/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "ALImageProvider.h"
#import "ALViewConstants.h"
#import "ALSquare.h"

@protocol AnylineVideoDataSampleBufferDelegate;
@protocol AnylineNativeBarcodeDelegate;

@interface ALCaptureDeviceManager : NSObject<ALImageProvider>

- (_Nullable instancetype)initWithCaptureResolution:(ALCaptureViewResolution)captureResolution
                                  pictureResolution:(ALPictureResolution)pictureResolution
                                       cutoutScreen:(CGRect)cutoutScreen
                                      cutoutPadding:(CGSize)cutoutPadding
                                       cutoutOffset:(CGPoint)cutoutOffset
                                      defaultDevice:(NSString * _Nonnull)defaultDevice;

/**
 The native Barcode Recognition Delegate. Implement this delegate to receive barcodes results during scanning.
 
 @warning Do not implement this delegate when you use the Barcode module.
 */
@property (nullable, nonatomic, weak) id<AnylineNativeBarcodeDelegate> barcodeDelegate;
/**
 The Sample Buffer Delegate gives you access to the video frames. You will get frames around 25 times per second. Do only access as much frames as you need, otherwise the performance will suffer.
 */
@property (nullable, nonatomic, weak) id<AnylineVideoDataSampleBufferDelegate> sampleBufferDelegate;

@property (nonatomic, assign) ALCaptureViewResolution captureResolution;
@property (nonatomic, assign) ALPictureResolution pictureResolution;

@property (nonatomic, assign) CGSize videoResolution;

@property (atomic, assign) CGRect cutoutFrame;
@property (nonatomic, assign) CGSize bufferFrame;
@property (nonatomic, assign) CGRect cutoutScreen;
@property (nonatomic, assign) CGSize cutoutPadding;
@property (nonatomic, assign) CGPoint cutoutOffset;

@property (nullable, nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

- (void)addVideoLayerOnView:(UIView * _Nonnull)view;
- (void)updateVideoLayer:(UIView * _Nonnull)view;

- (void)setFocusAndExposurePoint:(CGPoint)point;

- (void)startSession;

- (void)stopSession;

- (BOOL)isRunning;

- (CGPoint)convertPoint:(CGPoint)inPoint;

- (CGPoint)convertPoint:(CGPoint)inPoint
             imageWidth:(CGFloat)inWidth;

- (CGPoint)fullResolutionPointForPointInPreview:(CGPoint)inPoint;

- (UIInterfaceOrientation)currentInterfaceOrientation;

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
