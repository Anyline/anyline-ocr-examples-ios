//
//  AnylineModuleView.h
//  Anyline
//
//  Created by Daniel Albertini on 25/06/15.
//  Copyright (c) 2015 9Yards GmbH. All rights reserved.
//

#import "AnylineAbstractModuleView.h"
#import "ALSquare.h"
#import "ALDocumentScanPlugin.h"

@protocol AnylineDocumentModuleDelegate;

/**
 * The AnylineDocumentModuleView class declares the programmatic interface for an object that manages easy access to Anylines document detection. All its capabilities are bundled into this AnylineAbstractModuleView subclass. Management of the scanning process happens within the view object. It is configurable via interface builder.
 *
 * Communication with the host application is managed with a delegate that conforms to AnylineDocumentModuleDelegate.
 *
 */
@interface AnylineDocumentModuleView : AnylineAbstractModuleView

@property (nonatomic, strong) ALDocumentScanPlugin *documentScanPlugin;
/**
 *  Sets the license key and delegate.
 *
 *  @param licenseKey The Anyline license key for this application bundle
 *  @param delegate The delegate that will receive the Anyline results (hast to conform to <AnylineDocumentModuleDelegate>)
 *  @param error The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setupWithLicenseKey:(NSString *)licenseKey
                   delegate:(id<AnylineDocumentModuleDelegate>)delegate
                      error:(NSError **)error;

/**
 * Maximum deviation for the ratio. 0.15 is the default
 * @warning Parameter can only be changed when the scanning is not running.
 *
 * @since 3.8
 */
@property (nonatomic, strong) NSNumber * maxDocumentRatioDeviation;

/**
 * Sets custom document ratios (NSNumbers) that should be supported (or null to set back to all supported types).
 * @warning Parameter can only be changed when the scanning is not running. 
 *
 * @param ratios all supported formats
 * 
 * @since 3.8
 */
- (void)setDocumentRatios:(NSArray<NSNumber*>*)ratios;

- (BOOL)triggerPictureCornerDetectionAndReturnError:(NSError **)error;

/**
 *  Crops an arbitrary rectangle (e.g. trapezoid) of the input image and perspectively transforms it to a rectangle (e.g. square).
 *  After the transformation is complete the result delegate anylineDocumentScanPlugin:hasResult:fullImage:documentCorners will be triggered.
 *  In any case call [AnylineDocumentModuleView cancelScanningAndReturnError:] before using this method.
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
 *  In any case call [AnylineDocumentModuleView cancelScanningAndReturnError:] before using this method.
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


@end

@protocol AnylineDocumentModuleDelegate <NSObject>

@required

/**
 *
 * Called if a full result is found. A full result is considerd to be a successful preview, followed by a
 * successful full scan.
 *
 * @param transformedImage The transformed image (cropped, deskewed)
 * @param fullFrame        The full image (not cropped or deskewed)
 * @param corners          The corners of the document in the full frame
 * @since 3.6.1
 */
- (void)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView
                        hasResult:(UIImage *)transformedImage
                        fullImage:(UIImage *)fullFrame
                  documentCorners:(ALSquare *)corners;

@optional

/**
 *
 * Called if a full result is found. A full result is considerd to be a successful preview, followed by a
 * successful full scan.
 *
 * @param transformedImage The transformed image (cropped, deskewed)
 * @param fullFrame        The full image (not cropped or deskewed)
 * @since 3.3.1
 *
 * @deprecated since 3.6.1
 */
- (void)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView
                        hasResult:(UIImage *)transformedImage
                        fullImage:(UIImage *)fullFrame __deprecated_msg("Deprecated since 3.6.1 Use method anylineDocumentModuleView:hasResult:fullImage:documentCorners: instead.");


/**
 *
 * If triggerPictureCornerDetectionAndReturnError: is used this callback provides the image and the document corners
 * successful full scan.
 *
 * @param corners      The corners of the document
 * @param image        The full image (not cropped or deskewed)
 * @since 3.3.1
 *
 * @since 3.6.1
 */
- (void)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView
           detectedPictureCorners:(ALSquare *)corners
                          inImage:(UIImage *)image;

/**
 * Called if the preview scan detected a sharp and correctly placed document.
 * After this callback, a full frame scan of the document starts automatically.
 *
 * @param anylineImage The image of the successful preview. There is no transformation performed on this image.
 * @since 3.3.1
 */
- (void)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView
             reportsPreviewResult:(UIImage *)image;

/** 
 * Called if the preview run failed on an image. The error is provided, and the next run is started automatically.
 *
 * @param error The error of the preview run.
 * @since 3.3.1
 */
- (void)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView
  reportsPreviewProcessingFailure:(ALDocumentError)error;


/**
 * Called if the run on the full frame was unsuccessful. The scanning process automatically starts again with a
 * preview scan.
 *
 * @param error The error of the full frame run
 * @since 3.3.1
 */
- (void)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView
  reportsPictureProcessingFailure:(ALDocumentError)error;


/**
 * Return true if your implementation consumed the outline (e.g. drew the outline), or false / do not implement the delegate method, if the
 * DocumentScanView should draw the outline.
 *
 * @param outline     An NSArray containing the points of the document outline wrapped in an NSValue
 * @param anglesValid A boolean indicating if interior angles of the rectangle are within a tolerance (so that it
 *                    is not skew)
 * @return True if the outline is drawn by the implementation itself or omitted, false if the outline should be
 * drawn by the {@link DocumentScanView}
 * @since 3.3.1
 */
- (BOOL)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView
          documentOutlineDetected:(NSArray *)outline
                      anglesValid:(BOOL)anglesValid;

/**
 * Called after a picture was successfully taken from the camera.
 *
 * The taken picture will be processed after this method call.
 *
 * @since 3.3.1
 */
- (void)anylineDocumentModuleViewTakePictureSuccess:(AnylineDocumentModuleView *)anylineDocumentModuleView;


/**
 * Called if there was an error capturing the picture from the camera.
 *
 * @param error The error that was thrown during taking the picture
 * @since 3.3.1
 */
- (void)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView takePictureError:(NSError *)error;

@end
