//
//  AnylineOCRModuleView.h
//  Anyline
//
//  Created by Daniel Albertini on 10/11/15.
//  Copyright © 2015 9Yards GmbH. All rights reserved.
//

#import <Anyline/Anyline.h>
#import "ALOCRResult.h"
#import "ALOCRConfig.h"
#import "ALOCRScanPlugin.h"

/**
 *  The possible run error codes for this module. 
 *  You can listen to the error codes for each run via the delegate method anylineOCRModuleView:reportsRunFailure:
 */
typedef NS_ENUM(NSInteger, ALOCRError) {
    /**
     *  An unknown error occurred.
     */
    ALOCRErrorUnkown                  = -1,
    /**
     *  No text lines found in imag
     */
    ALOCRErrorNoLinesFound            = -2,
    /**
     *  No text found in lines
     */
    ALOCRErrorNoTextFound             = -3,
    /**
     *  The required min confidence is not reached for this run
     */
    ALOCRErrorConfidenceNotReached    = -4,
    /**
     *  The result does not match the validation regular expression
     */
    ALOCRErrorResultNotValid          = -5,
    /**
     *  The min sharpness for this run is not reached
     */
    ALOCRErrorSharpnessNotReached     = -6,
} __deprecated_msg("Deprecated since 3.10 Use enum ALRunFailure instead.");


@protocol AnylineOCRModuleDelegate;
/**
 *  The AnylineOcrScanView can be used to recognize text.
 *  It can be adapted to different kinds of use cases with the {@link AnylineViewConfig} (settings for the camera and UI)
 *  and the {@link AnylineOcrConfig} (settings to adapt the recognition to your use case).
 *
 *  @since 3.4
 */
@interface AnylineOCRModuleView : AnylineAbstractModuleView

@property (nonatomic, strong) ALOCRScanPlugin *ocrScanPlugin;

/**
 *  Read-only property for the ALOCRConfig
 *
 *  Use method setOCRConfig:error: for setting the config.
 */
@property (nonatomic, strong, readonly) ALOCRConfig *ocrConfig;

/**
 *  Sets the license key and delegate.
 *
 *  @param licenseKey   The Anyline license key for this application bundle
 *  @param delegate     The delegate that will receive the Anyline results (hast to conform to <AnylineOCRModuleDelegate>)
 *  @param ocrConfig    The ocrConfig to use for the scanning
 *  @param error        The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setupWithLicenseKey:(NSString *)licenseKey
                   delegate:(id<AnylineOCRModuleDelegate>)delegate
                  ocrConfig:(ALOCRConfig *)ocrConfig
                      error:(NSError **)error;
/**
 *  Sets a new ALOCRConfig and returns an Error if something failed.
 *
 *  @param ocrConfig The ALOCRConfig to set
 *  @param error     The Error object if something fails
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setOCRConfig:(ALOCRConfig *)ocrConfig error:(NSError **)error;
/**
 *  Use this method to copy a custom trained font data into the Anyline work environment.
 *  This method is mandatory if you want to use custom fonts.
 *
 *  @param trainedDataPath  The full path to your trained data file
 *  @param fileHash         The hash of the traineddata file so Anyline knows when it changed.
 *  @param error            The Error object if something fails
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)copyTrainedData:(NSString *)trainedDataPath
               fileHash:(NSString *)hash
                  error:(NSError **)error;

@end
/**
 *  The delegate for the AnylineOCRModuleView.
 */
@protocol AnylineOCRModuleDelegate <NSObject>

@required

/**
 *  Called when a result is found
 *
 *  @param anylineOCRModuleView The AnylineOCRModuleView
 *  @param result               The result object
 */
- (void)anylineOCRModuleView:(AnylineOCRModuleView *)anylineOCRModuleView
               didFindResult:(ALOCRResult *)result;

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
 *  @param anylineOCRModuleView The AnylineOCRModuleView
 *  @param variableName         The variable name of the reported value
 *  @param value                The reported value
 *
 *  @deprecated since 3.10
 */
- (void)anylineOCRModuleView:(AnylineOCRModuleView *)anylineOCRModuleView
             reportsVariable:(NSString *)variableName
                       value:(id)value __deprecated_msg("Deprecated since 3.10 Use AnylineDebugDelegate instead.");
/**
 *  Is called when the processing is aborted for the current image before reaching return.
 *  (If not text is found or confidence is to low, etc.)
 *
 *  @param anylineOCRModuleView The AnylineOCRModuleView
 *  @param error                The error enum
 *
 *  @deprecated since 3.10
 */
- (void)anylineOCRModuleView:(AnylineOCRModuleView *)anylineOCRModuleView
           reportsRunFailure:(ALOCRError)error __deprecated_msg("Deprecated since 3.10 Use AnylineDebugDelegate instead.");
/**
 *  Called when the outline of a possible text is detected. (currently always a rect with 4 points,
 *  but this may change in the future)
 *
 *  @warning When not implemented Anyline will handle the drawing. Deactivate it by implementing this delegate
 *           and return YES
 *
 *  @param anylineOCRModuleView The AnylineOCRModuleView
 *  @param outline              The ALSquare with the 4 points.
 *
 *  @return YES if you handle drawing by yourself, NO if Anyline should draw the outline.
 *
 *  @deprecated since 3.10
 */
- (BOOL)anylineOCRModuleView:(AnylineOCRModuleView *)anylineOCRModuleView
         textOutlineDetected:(ALSquare *)outline __deprecated_msg("Deprecated since 3.10 Use AnylineDebugDelegate instead.");

@end
