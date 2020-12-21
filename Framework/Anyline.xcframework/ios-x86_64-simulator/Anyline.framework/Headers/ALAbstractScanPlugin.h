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
#import "ALAssetContext.h"
#import "ALAssetDelegate.h"
#import "ALAssetController.h"

@protocol ALInfoDelegate;

@interface ALAbstractScanPlugin : NSObject<ALCoreControllerDelegate>

@property (nonatomic, strong, readonly) NSHashTable<ALInfoDelegate> * _Nullable infoDelegates;

/**
 The pluginID is useful if there are multiple plugins running at the same time
 */
@property (nullable, nonatomic, strong) NSString *pluginID;

/**
 The ImageProvider implementation takes care of getting new images in the SDK for processing
 */
@property (nullable, nonatomic, weak) id<ALImageProvider> imageProvider;
    
/**
 Start the scanning with an ImageProvider. Anyline will ask the ImageProvider for new frames until
 we get a result with high enough confidence.

 @param imageProvider The ImageProvider implementation
 @param error An error if something went wrong during startup
 @return Boolean indicating the success of the start
 */
- (BOOL)start:(id<ALImageProvider> _Nonnull)imageProvider error:(NSError * _Nullable * _Nullable)error;
    
/**
 Stops the scanning.

 @param error An error if something went wrong during startup
 @return Boolean indicating the success of the start
 */
- (BOOL)stopAndReturnError:(NSError * _Nullable * _Nullable)error;
    
/**
 Method to enable/disable the reporting functionality. Anyline reports anonymous scan data
 to there servers to improve and monitor scan quality. Depending on your license reporting
 is already disabled or can't be disabled.

 @param enable Boolean if reporting should be on/off
 */
- (void)enableReporting:(BOOL)enable;
    
/**
 The isRunning boolean indicates if a Anyline process is started.

 @return Boolean indicating if Anyline is running
 */
- (BOOL)isRunning;

- (void)addInfoDelegate:(id<ALInfoDelegate> _Nonnull)infoDelegate;

- (void)removeInfoDelegate:(id<ALInfoDelegate> _Nonnull)infoDelegate;


//Scan Delay Properties and Methods
@property (nonatomic) int delayStartScanTime; //in milliseconds

/**
 *  The delayedScanTimeFulfilled indicates if the configured delayStartScanTime has been fulfilled.
 *  No result will be returned unless this method returns true.
 *
 *  @return Boolean indicating if the delayStartScanTime has been fulfilled.
 */
- (BOOL)delayedScanTimeFulfilled;
/**
 *  Will set the current timestamp for the delayedScantimeFulfilled check
 */
- (void)setCurrentScanStartTime;

/**
* Sets up the asset service to fetch assets OTA. This needs to be called before trying
* to check for updates with {@link #checkForUpdates()} or updating the assets with
* {@link #updateAssets()}
*
* @param context The context
* @param delegate The delegate
*/
- (void)setupAssetUpdateWithContext:(ALAssetContext *_Nonnull)context delegate:(NSObject<ALAssetDelegate> *_Nonnull)delegate;


// Internal Properties
@property (nonatomic, assign) NSInteger confidence;

@property (nullable, nonatomic, strong, readonly) ALImage *scanImage;

@property (nullable, nonatomic, strong) ALCoreController *coreController;
/// The name of the product.
@property (nullable, nonatomic) NSString *productName;

@property (nullable, nonatomic, strong) ALAssetController *assetController;

- (NSString * _Nonnull)assetPath;
@end

/**
 *  The delegate for the ALAbstractScanPlugin.
 */
@protocol ALInfoDelegate <NSObject>

@optional
/**
 * <p>Called with interesting values that arise during processing.</p>
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
 *  @param info         An object containing the variable name and value
 *   */
- (void)anylineScanPlugin:(ALAbstractScanPlugin * _Nonnull)anylineScanPlugin
               reportInfo:(ALScanInfo * _Nonnull)info;
/**
 *  Is called when the processing is aborted for the current image before reaching return.
 *  (If not text is found or confidence is to low, etc.)
 *
 *  @param anylineScanPlugin The ALAbstractScanPlugin
 *  @param runSkippedReason        The reason why the run failed
 */
- (void)anylineScanPlugin:(ALAbstractScanPlugin * _Nonnull)anylineScanPlugin
               runSkipped:(ALRunSkippedReason * _Nonnull)runSkippedReason;


    
@end
