//
//  AnylineModuleView.h
//  Anyline
//
//  Created by Daniel Albertini on 25/06/15.
//  Copyright (c) 2015 9Yards GmbH. All rights reserved.
//

#import "AnylineAbstractModuleView.h"
#import "ALSquare.h"

typedef NS_ENUM(NSInteger, ALDocumentError) {
    ALDocumentErrorUnkown           = -1,
    ALDocumentErrorOutlineNotFound  = -2,
    ALDocumentErrorSkewTooHigh      = -3,
    ALDocumentErrorGlareDetected    = -4,
    ALDocumentErrorImageTooDark     = -5,
    ALDocumentErrorNotSharp         = -6,
    ALDocumentErrorShakeDetected    = -7,
};

@protocol AnylineDocumentModuleDelegate;

/**
 * The AnylineDocumentModuleView class declares the programmatic interface for an object that manages easy access to Anylines document detection. All its capabilities are bundled into this AnylineAbstractModuleView subclass. Management of the scanning process happens within the view object. It is configurable via interface builder.
 *
 * Communication with the host application is managed with a delegate that conforms to AnylineDocumentModuleDelegate.
 *
 */
@interface AnylineDocumentModuleView : AnylineAbstractModuleView


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
 * @since 3.3.1
 */
- (void)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView
                        hasResult:(UIImage *)transformedImage
                        fullImage:(UIImage *)fullFrame;

@optional

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
 * @param outline     The ALSquare containing the four points of the document outline
 * @param anglesValid A boolean indicating if interior angles of the rectangle are within a tolerance (so that it
 *                    is not skew)
 * @return True if the outline is drawn by the implementation itself or omitted, false if the outline should be
 * drawn by the {@link DocumentScanView}
 * @since 3.3.1
 */
- (BOOL)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView
          documentOutlineDetected:(ALSquare *)outline
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