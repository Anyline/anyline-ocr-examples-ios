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

@class ALScanView;
@interface ALAbstractScanViewPlugin : UIView<ALInfoDelegate>

@property (nullable, nonatomic, strong) ALSampleBufferImageProvider *sampleBufferImageProvider;

@property (nonatomic, weak) ALScanView * _Nullable scanView;

@property (nullable, nonatomic, strong) ALSquare *outline;

@property (nullable, nonatomic, strong) ALImage *scanImage;

/**
 * The UI Configuration for the scanning UI
 */
@property (nullable, nonatomic, copy) ALScanViewPluginConfig *scanViewPluginConfig;

// Private Stuff

@property (nonatomic, assign) CGFloat scale;

+ (_Nullable instancetype)scanViewPluginForFrame:(CGRect)frame
                                      configDict:(NSDictionary *_Nonnull)configDict
                                      licenseKey:(NSString *_Nonnull)licenseKey
                                        delegate:(id _Nonnull)delegate
                                           error:(NSError *_Nullable *_Nullable)error;

- (void)customInit;

- (BOOL)startAndReturnError:(NSError * _Nullable * _Nullable)error;

- (BOOL)stopAndReturnError:(NSError * _Nullable * _Nullable)error;

/**
 * Stop listening for device motion.
 */
- (void)stopListeningForMotion;

- (void)triggerScannedFeedback;

- (NSArray * _Nonnull)convertContours:(ALContours * _Nonnull)contoursValue;

- (ALSquare * _Nonnull)convertCGRect:(NSValue * _Nonnull)concreteValue;

- (void)updateCutoutRect:(CGRect)rect;

@end
