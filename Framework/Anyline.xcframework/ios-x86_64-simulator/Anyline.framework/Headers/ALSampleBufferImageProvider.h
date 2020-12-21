//
//  ALSampleBufferImageProvider.h
//  Anyline
//
//  Created by Daniel Albertini on 06.03.18.
//  Copyright © 2018 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "ALImageProvider.h"
#import "ALCaptureDeviceManager.h"



@interface ALSampleBufferImageProvider : NSObject<ALImageProvider, AnylineVideoDataSampleBufferDelegate>

@property (atomic, assign) CGRect cutoutFrame;
@property (nonatomic, assign) CGSize cameraFrame;
@property (nonatomic, assign) CGRect cutoutScreen;
@property (nonatomic, assign) CGSize cutoutPadding;
@property (nonatomic, assign) CGPoint cutoutOffset;

@property (nonatomic, weak) ALCaptureDeviceManager * _Nullable captureDeviceManager;

- (_Nullable instancetype)initWithCutoutScreen:(CGRect)cutoutScreen
                                 cutoutPadding:(CGSize)cutoutPadding
                                  cutoutOffset:(CGPoint)cutoutOffset;

- (CGPoint)convertPoint:(CGPoint)inPoint
           previewLayer:(AVCaptureVideoPreviewLayer * _Nonnull)previewLayer;

- (CGPoint)convertPoint:(CGPoint)inPoint
           previewLayer:(AVCaptureVideoPreviewLayer * _Nonnull)previewLayer
             imageWidth:(CGFloat)inWidth;

- (void)updateCutoutScreen:(CGRect)rect;

@end


