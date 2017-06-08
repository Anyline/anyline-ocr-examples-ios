//
//  ALAbstractScanPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 15/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALCoreController.h"
#import "ALScanResult.h"
#import "ALScanInfo.h"
#import "ALRunSkippedReason.h"

@protocol ALInfoDelegate;

@interface ALAbstractScanPlugin : NSObject<ALCoreControllerDelegate>

@property (nullable, nonatomic, strong, readonly) NSString *pluginID;

@property (nonatomic, assign, readonly) NSInteger confidence;

@property (nullable, nonatomic, strong, readonly) ALImage *scanImage;

@property (nullable, nonatomic, strong) ALCoreController *coreController;

@property (nullable, nonatomic, assign) id<ALImageProvider> imageProvider;

- (instancetype _Nullable)initWithPluginID:(NSString * _Nullable)pluginID NS_DESIGNATED_INITIALIZER;
    
- (BOOL)start:(id<ALImageProvider> _Nonnull)imageProvider error:(NSError * _Nullable * _Nullable)error;
    
- (BOOL)stopAndReturnError:(NSError * _Nullable * _Nullable)error;
    
- (void)enableReporting:(BOOL)enable;
    
- (BOOL)isRunning;

- (void)addInfoDelegate:(id<ALInfoDelegate> _Nonnull)infoDelegate;

- (void)removeInfoDelegate:(id<ALInfoDelegate> _Nonnull)infoDelegate;
    
@end

/**
 *  The delegate for the ALAbstractScanPlugin.
 */
@protocol ALInfoDelegate <NSObject>

@optional
/**
 * <p>Called with interesting values, that arise during processing.</p>
 * <p>
 * Some possibly reported values:
 * <ul>
 * <li>$brightness - the brightness of the center region of the cutout as a float value </li>
 * <li>$confidence - the confidence, an Integer value between 0 and 100 </li>
 * <li>$thresholdedImage - the current image transformed into black and white (the base image used for OCR)</li>
 * </ul>
 * </p>
 *
 *  @param anylineScanPlugin    The ALAbstractScanPlugin
 *  @param variableName         The variable name of the reported value
 *  @param value                The reported value
 */
- (void)anylineScanPlugin:(ALAbstractScanPlugin * _Nonnull)anylineScanPlugin
               reportInfo:(ALScanInfo * _Nonnull)info;
/**
 *  Is called when the processing is aborted for the current image before reaching return.
 *  (If not text is found or confidence is to low, etc.)
 *
 *  @param anylineScanPlugin The ALAbstractScanPlugin
 *  @param runFailure        The reason why the run failed
 */
- (void)anylineScanPlugin:(ALAbstractScanPlugin * _Nonnull)anylineScanPlugin
               runSkipped:(ALRunSkippedReason * _Nonnull)runSkippedReason;
    
@end
