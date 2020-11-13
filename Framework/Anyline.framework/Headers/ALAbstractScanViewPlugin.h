//
//  ALAbstractScanViewPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 29/05/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALScanInfo.h"
#import "ALBasicConfig.h"
#import "ALAbstractScanPlugin.h"
#import "ALSampleBufferImageProvider.h"

@protocol ALScanViewPluginDelegate;

@class ALScanView;
@interface ALAbstractScanViewPlugin : UIView<ALInfoDelegate>

@property (nonatomic, strong, readonly) NSHashTable<ALScanViewPluginDelegate> * _Nullable scanViewPluginDelegates;
/**
 The SampleBufferImageProvider implements ALImageProvider and AnylineVideoDataSampleBufferDelegate
 and prepares the frame for Anyline processing
 */
@property (nullable, nonatomic, strong) ALSampleBufferImageProvider *sampleBufferImageProvider;

@property (nonatomic, weak) ALScanView * _Nullable scanView;

/**
 The position of the Cutout in the View
 */
@property (assign, nonatomic) CGRect cutoutRect;

/**
 The pluginID is useful if there are multiple plugins running at the same time
 */
@property (nullable, nonatomic, readonly) NSString *pluginID;

/**
 * The UI Configuration for the scanning UI
 */
@property (nullable, nonatomic, copy) ALScanViewPluginConfig *scanViewPluginConfig;

/**
A dictionary mapping plugin IDs to configs. For a simple scan view plugin, this will just be this plugin's pluginID and scanViewPluginConfig. For composite scan view plugins, this will be the plugin IDs and configs for all the child plugins, and not the composite itself.
 */
@property (nullable, nonatomic, copy) NSDictionary<NSString *,ALScanViewPluginConfig *> *scanViewPluginConfigs;

+ (_Nullable instancetype)scanViewPluginForConfigDict:(NSDictionary *_Nonnull)configDict
                                             delegate:(id _Nonnull)delegate
                                                error:(NSError *_Nullable *_Nullable)error;

/**
 Starts the Anyline processing.

 @param error An error if something goes wrong during the startup
 @return Boolean indicating the success of the start
 */
- (BOOL)startAndReturnError:(NSError * _Nullable * _Nullable)error;

/**
 Stops the Anyline processing

 @param error An error if something goes wrong while stopping
 @return Boolean indicating whether it stopped successfully
 */
- (BOOL)stopAndReturnError:(NSError * _Nullable * _Nullable)error;

// Internal Stuff

@property (nullable, nonatomic, strong) ALSquare *outline;

@property (nullable, nonatomic, strong) ALImage *scanImage;

@property (nonatomic, assign) CGFloat scale;

- (void)customInit;

/**
 * Stop listening for device motion.
 */
- (void)stopListeningForMotion;

- (void)triggerScannedFeedback;

- (NSArray * _Nonnull)convertContours:(ALContours * _Nonnull)contoursValue;

- (ALSquare * _Nonnull)convertCGRect:(NSValue * _Nonnull)concreteValue;

- (ALSquare * _Nonnull)convertSquare:(ALSquare * _Nonnull)unconvertedSquare;

- (void)updateCutoutRect:(CGRect)rect forPluginID:(NSString *_Nonnull)pluginID;

- (void)addScanViewPluginDelegate:(id<ALScanViewPluginDelegate> _Nonnull)scanViewPluginDelegate;

- (void)removeScanViewPluginDelegate:(id<ALScanViewPluginDelegate> _Nonnull)scanViewPluginDelegate;

@end

@protocol ALScanViewPluginDelegate <NSObject>

@optional
/**
 *
 * Called if the cutout was updated within the ScanViewPlugin class.
 *
 * @param cutoutRect The updated cutout rect(x, y, width, height)
 *
 */
- (void)anylineScanViewPlugin:(ALAbstractScanViewPlugin * _Nonnull)anylineScanViewPlugin
            updatedCutout:(CGRect)cutoutRect;

@end
