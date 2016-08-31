//
//  AnylineVideoView.h
//  OCR7
//
//  Created by Daniel Albertini on 20.06.13.
//  Copyright (c) 2013 9Yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "ALImageProvider.h"
#import "ALTorchManager.h"

@class ALSquare;
@class ALImage;
@class ALUIConfiguration;
@class ALCutoutView;
@class ALFlashButton;

/**
 *  The AnylineVideoView renders the CapturePreview from the Camera on the screen. It also handles an efficient way to extract frames
 *  from the Video and provide them to Anyline with the ALImageProvider protocol. It should be initialised via ALUIConfiguration.
 *
 *  This View also provides appropriate cutoutView and flashButton subViews as configured in the ALUIConfiguration.
 */
@interface AnylineVideoView : UIView<ALImageProvider>
/**
 *  The FlashButton subview. Can be configured in the ALUIConfiguration.
 */
@property (nonatomic, strong, readonly) ALFlashButton *flashButton;
/**
 *  The CutoutView subview. Configurable with an ALUIConfiguration.
 */
@property (nonatomic, strong, readonly) ALCutoutView *cutoutView;
/**
 * Returns the bounding Rect of the visible WatermarkView with the correct location on the Module View.
 *
 * @warning May be nil before the layout process is completed or the license is not community.
 */
@property (nonatomic, readonly) CGRect watermarkRect;

/*
 The torch Manager is teh interface to the flash/torch
 */
@property (nonatomic, strong) ALTorchManager *torchManager;

@property (nonatomic) CGRect cropRect;

/**
 *  Initialises a new AnylineVideoView with a frame and a configuration.
 *
 *  @param frame            The frame where the view should be positioned.
 *  @param configuration    The configuration used to load the video view and the subviews.
 *
 *  @return A new instance of AnylineVideoView.
 */
- (instancetype)initWithFrame:(CGRect)frame configuration:(ALUIConfiguration *)configuration;
/**
 *  Initialises a new AnylineVideoView with a frame. The CaptureView will be initialised with the default 720p
 *  video. No FlashButton or CutoutView will be initialised.
 *
 *  @param frame            The frame where the view should be positioned.
 *
 *  @return A new instance of AnylineVideoView.
 */
- (instancetype)initWithFrame:(CGRect)frame;
/**
 *  Initialises a new AnylineVideoView with a coder and a configuration.
 *
 *  @param frame            The coder to initialise the view.
 *  @param configuration    The configuration used to load the video view and the subviews.
 *
 *  @return A new instance of AnylineVideoView
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder configuration:(ALUIConfiguration *)configuration;
/**
 *  Initialises a new AnylineVideoView with a coder. The CaptureView will be initialised with the default 720p
 *  video. No FlashButton or CutoutView will be initialised.
 *
 *  @param frame            The coder to initialise the view.
 *
 *  @return A new instance of AnylineVideoView.
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder;

- (void)updateConfiguration:(ALUIConfiguration *)configuration;

- (BOOL)startVideoAndReturnError:(NSError **)error;

- (void)stopVideo;

- (void)setFocusAndExposurePoint:(CGPoint)point;

- (void)blink;

- (CGPoint)convertPoint:(CGPoint)inPoint;

- (CGPoint)convertPoint:(CGPoint)inPoint imageWidth:(CGFloat)inWidth;

- (void)prepareForMovieCapture:(NSString *)filename;

- (void)startRecording;

- (void)stopRecording:(void (^)(NSURL *fileURL))handler;

- (void)captureNextFrameAsHighResImage:(BOOL)capt;

@end
