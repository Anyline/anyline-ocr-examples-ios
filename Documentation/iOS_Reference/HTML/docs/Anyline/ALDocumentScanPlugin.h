//
//  ALDocumentScanPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 27/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALCoreController.h"
#import "ALScanInfo.h"

typedef NS_ENUM(NSInteger, ALDocumentError) {
    ALDocumentErrorUnkown           = -1,
    ALDocumentErrorOutlineNotFound  = -2,
    ALDocumentErrorSkewTooHigh      = -3,
    ALDocumentErrorGlareDetected    = -4,
    ALDocumentErrorImageTooDark     = -5,
    ALDocumentErrorNotSharp         = -6,
    ALDocumentErrorShakeDetected    = -7,
    ALDocumentErrorRatioOutsideOfTolerance = -8,
    ALDocumentErrorBoundsOutsideOfTolerance = -9,
};

/**
 *
 * Predefinded document ratios
 *
 */

extern CGFloat const ALDocumentRatioDINAXLandscape;
extern CGFloat const ALDocumentRatioDINAXPortrait;
extern CGFloat const ALDocumentRatioCompimentsSlipLandscape;
extern CGFloat const ALDocumentRatioCompimentsSlipPortrait;
extern CGFloat const ALDocumentRatioBusinessCardLandscape;
extern CGFloat const ALDocumentRatioBusinessCardPortrait;
extern CGFloat const ALDocumentRatioLetterLandscape;
extern CGFloat const ALDocumentRatioLetterPortrait;

@protocol ALDocumentScanPluginDelegate;
@protocol ALDocumentInfoDelegate;

/**
 * The ALDocumentScanPlugin class declares the programmatic interface for an object that manages easy access to Anylines document detection. All its capabilities are bundled into this AnylineAbstractModuleView subclass. Management of the scanning process happens within the view object. It is configurable via interface builder.
 *
 * Communication with the host application is managed with a delegate that conforms to ALDocumentScanPluginDelegate.
 *
 */
@interface ALDocumentScanPlugin : NSObject

@property (nullable, nonatomic, strong, readonly) NSString *pluginID;

@property (nullable, nonatomic, strong, readonly) ALImage *scanImage;

@property (nullable, nonatomic, strong) ALCoreController *coreController;

@property (nullable, nonatomic, assign) id<ALImageProvider> imageProvider;

@property (nonatomic, assign) BOOL justDetectCornersIfPossible;

- (instancetype _Nullable)initWithPluginID:(NSString * _Nullable)pluginID NS_DESIGNATED_INITIALIZER;

- (BOOL)start:(id<ALImageProvider> _Nonnull)imageProvider error:(NSError * _Nullable * _Nullable)error;

- (BOOL)stopAndReturnError:(NSError * _Nullable * _Nullable)error;

- (void)enableReporting:(BOOL)enable;

- (BOOL)isRunning;

- (BOOL)triggerPictureCornerDetectionAndReturnError:(NSError * _Nullable * _Nullable)error;

/**
 *  Crops an arbitrary rectangle (e.g. trapezoid) of the input image and perspectively transforms it to a rectangle (e.g. square).
 *  After the transformation is complete the result delegate anylineDocumentScanPlugin:hasResult:fullImage:documentCorners will be triggered.
 *  In any case call [ALDocumentScanPlugin cancelScanningAndReturnError:] before using this method.
 *
 *  @param square The input image will be transformed to this square
 *  @param image The UIImage which will be processed and transformed
 *  @param error The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)transformImageWithSquare:(ALSquare * _Nullable)square
                           image:(UIImage * _Nullable)image
                           error:(NSError * _Nullable * _Nullable)error;

/**
 *  Crops an arbitrary rectangle (e.g. trapezoid) of the input image and perspectively transforms it to a rectangle (e.g. square).
 *  After the transformation is complete the result delegate anylineDocumentScanPlugin:hasResult:fullImage:documentCorners will be triggered.
 *  In any case call [ALDocumentScanPlugin cancelScanningAndReturnError:] before using this method.
 *
 *  @param square The input image will be transformed to this square
 *  @param image The ALImage which will be processed and transformed
 *  @param error The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)transformALImageWithSquare:(ALSquare * _Nullable)square
                             image:(ALImage * _Nullable)image
                             error:(NSError * _Nullable * _Nullable)error;
/**
 *  Sets the license key and delegate.
 *
 *  @param licenseKey The Anyline license key for this application bundle
 *  @param delegate The delegate that will receive the Anyline results (hast to conform to <ALDocumentScanPluginDelegate>)
 *  @param error The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setupWithLicenseKey:(NSString * _Nonnull)licenseKey
                   delegate:(id<ALDocumentScanPluginDelegate> _Nonnull)delegate
                      error:(NSError * _Nullable * _Nullable)error;

/**
 * Maximum deviation for the ratio. 0.15 is the default
 * @warning Parameter can only be changed when the scanning is not running.
 *
 * @since 3.8
 */
@property (nonnull, nonatomic, strong) NSNumber *maxDocumentRatioDeviation;

/**
 * Sets custom document ratios (NSNumbers) that should be supported (or null to set back to all supported types).
 * @warning Parameter can only be changed when the scanning is not running.
 *
 * @param ratios all supported formats
 *
 * @since 3.8
 */
@property (nullable, nonatomic, strong) NSArray<NSNumber*> * documentRatios;

- (void)addDelegate:(id<ALDocumentScanPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALDocumentScanPluginDelegate> _Nonnull)delegate;

- (void)addInfoDelegate:(id<ALDocumentInfoDelegate> _Nonnull)infoDelegate;

- (void)removeInfoDelegate:(id<ALDocumentInfoDelegate> _Nonnull)infoDelegate;

@end

@protocol ALDocumentScanPluginDelegate <NSObject>

@required

/**
 *
 * Called if a full result is found. A full result is considerd to be a successful preview, followed by a
 * successful full scan.
 *
 * @param transformedImage The transformed image (cropped, deskewed)
 * @param fullFrame        The full image (not cropped or deskewed)
 * @param corners          The corners of the document in the full frame
 *
 */
- (void)anylineDocumentScanPlugin:(ALDocumentScanPlugin * _Nonnull)anylineDocumentScanPlugin
                        hasResult:(UIImage * _Nonnull)transformedImage
                        fullImage:(UIImage * _Nonnull)fullFrame
                  documentCorners:(ALSquare * _Nonnull)corners;

@end

@protocol ALDocumentInfoDelegate <NSObject>

@optional


/**
 *
 * If triggerPictureCornerDetectionAndReturnError: is used this callback provides the image and the document corners
 * successful full scan.
 *
 * @param corners      The corners of the document
 * @param image        The full image (not cropped or deskewed)
 */
- (void)anylineDocumentScanPlugin:(ALDocumentScanPlugin * _Nonnull)anylineDocumentScanPlugin
           detectedPictureCorners:(ALSquare * _Nonnull)corners
                          inImage:(UIImage * _Nonnull)image;

/**
 * Called if the preview scan detected a sharp and correctly placed document.
 * After this callback, a full frame scan of the document starts automatically.
 *
 * @param anylineImage The image of the successful preview. There is no transformation performed on this image.
 *
 */
- (void)anylineDocumentScanPlugin:(ALDocumentScanPlugin * _Nonnull)anylineDocumentScanPlugin
             reportsPreviewResult:(UIImage * _Nonnull)image;

/**
 * Called if the preview run failed on an image. The error is provided, and the next run is started automatically.
 *
 * @param error The error of the preview run.
 *
 */
- (void)anylineDocumentScanPlugin:(ALDocumentScanPlugin * _Nonnull)anylineDocumentScanPlugin
  reportsPreviewProcessingFailure:(ALDocumentError)error;


/**
 * Called if the run on the full frame was unsuccessful. The scanning process automatically starts again with a
 * preview scan.
 *
 * @param error The error of the full frame run
 *
 */
- (void)anylineDocumentScanPlugin:(ALDocumentScanPlugin * _Nonnull)anylineDocumentScanPlugin
  reportsPictureProcessingFailure:(ALDocumentError)error;

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
 *  @param anylineScanPlugin    The ALDocumentScanPlugin
 *  @param scanInfo             The reported ScanInfo
 */
- (void)anylineDocumentScanPlugin:(ALDocumentScanPlugin * _Nonnull)anylineDocumentScanPlugin
                       reportInfo:(ALScanInfo * _Nonnull)scanInfo;


@end

