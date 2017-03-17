//
//  AnylineAbstractModuleView.h
//  
//
//  Created by Daniel Albertini on 01/07/15.
//
//

#import <UIKit/UIKit.h>
#import "ALFlashButton.h"
#import "ALUIConfiguration.h"
#import "AnylineVideoView.h"
#import "AnylineController.h"
#import "ALMotionDetector.h"
#import "AnylineVideoView.h"

/**
 * The name for a reported brightness value
 *
 * @type NSNumber holding a double
 */
extern NSString * const kBrightnessVariableName;

/**
 * The name for a reported text outline value
 *
 * @type cv::Rect
 */
extern NSString * const kOutlineVariableName;

/**
 * The name for a reported device acceleration value
 *
 * @type NSNumber holding a double
 */
extern NSString * const kDeviceAccelerationVariableName;

/**
 * The name for a reported thresholded image value
 *
 * @type ALImage
 */
extern NSString * const kThresholdedImageVariableName;

/**
 * The name for a reported contour value
 *
 * @type std::vector<al::Contour>
 */
extern NSString * const kContoursVariableName;

/**
 * The name for a reported square value
 *
 * @type cv::Rect
 */
extern NSString * const kSquareVariableName;

/**
 * The name for a reported polygon value
 *
 * @type ALPolygon
 */
extern NSString * const kPolygonVariableName;

/**
 * The name for a reported sharpness value
 *
 * @type NSNumber holding a double
 */
extern NSString * const kSharpnessVariableName;

/**
 * The name for a reported shake detection warning value
 *
 * @type NSNumber holding a BOOL
 */
extern NSString * const kShakeDetectionWarningVariableName;

/**
 *  The possible run error codes for this module.
 *  You can listen to the error codes for each run via the delegate method anylineOCRModuleView:reportsRunFailure:
 */
typedef NS_ENUM(NSInteger, ALRunFailure) {
    /**
     *  An unknown error occurred.
     */
    ALRunFailureUnkown                  = -1,
    /**
     *  No text lines found in imag
     */
    ALRunFailureNoLinesFound            = -2,
    /**
     *  No text found in lines
     */
    ALRunFailureNoTextFound             = -3,
    /**
     *  The required min confidence is not reached for this run
     */
    ALRunFailureConfidenceNotReached    = -4,
    /**
     *  The result does not match the validation regular expression
     */
    ALRunFailureResultNotValid          = -5,
    /**
     *  The min sharpness for this run is not reached
     */
    ALRunFailureSharpnessNotReached     = -6,
};

/**
 *  The base result object for all the modules
 */
@interface ALScanResult<__covariant ObjectType> : NSObject
/**
 *  The scanned result.
 */
@property (nonatomic, strong, readonly) ObjectType result;
/**
 *  The image where the scanned text was found.
 */
@property (nonatomic, strong, readonly) UIImage *image;
/**
 *  The full frme image where the scanned text was found.
 */
@property (nonatomic, strong, readonly) UIImage *fullImage;
/**
 *  The confidence for the scanned value.
 */
@property (nonatomic, assign, readonly) NSInteger confidence;
/**
 *  The outline of the found text in relation to the ModuleView.
 */
@property (nonatomic, strong, readonly) ALSquare *outline;

- (instancetype)initWithResult:(ObjectType)result
                         image:(UIImage *)image
                     fullImage:(UIImage *)fullImage
                    confidence:(NSInteger)confidence
                       outline:(ALSquare *)outline;

@end

@protocol AnylineDebugDelegate;

/**
 * The AnylineAbstractModuleView is a programmatic interface for an object that manages easy access to Anylines scanning modes.  It is a subclass of UIView.
 * You should sublcass this class to build Anyline modules.
 *
 * Overwrite startScanningAndReturnError: to add additional initilization before scanning begins.
 *
 * Overwrite cancelScanningAndReturnError: to do additional clean-up after scanning ends.
 *
 * Overwrite reportScanResultState: to check the various scanning states
 *
 */
@interface AnylineAbstractModuleView : UIView

@property (nonatomic, weak) id<AnylineDebugDelegate> debugDelegate;

/**
 The video view which is responsible for video preview, frame extraction, ...
 */
@property (nonatomic, strong) AnylineVideoView *videoView;

/**
 * The UI Configuration for the scanning UI
 */
@property (nonatomic, strong) ALUIConfiguration *currentConfiguration;


/**
 *  Sets the width of the views border
 */
@property (nonatomic) IBInspectable NSInteger strokeWidth;

/**
 *  Sets the color of the views border
 */
@property (nonatomic, strong) IBInspectable UIColor *strokeColor;

/**
 *  Sets the corner radius of the views border
 */
@property (nonatomic) IBInspectable NSInteger cornerRadius;

/**
 *  Sets the color of the space surrounding the view
 */
@property (nonatomic, strong) IBInspectable UIColor *outerColor;

/**
 *  Sets the alpha of the space surrounding the view
 */
@property (nonatomic) IBInspectable CGFloat outerAlpha;

/**
 *  Sets image the user uses to toggle the flash
 */
@property (nonatomic, strong) IBInspectable UIImage *flashImage;

/**
 *  Sets the alignment of the flash button. Possible values are:
 *  ALFlashAlignmentTop, ALFlashAlignmentTopLeft, ALFlashAlignmentTopRight,
 *  ALFlashAlignmentBottomLeft, ALFlashAlignmentBottom and
 *  ALFlashAlignmentBottomRight
 */
@property (nonatomic) ALFlashAlignment flashButtonAlignment;

/**
 * Property for the flash button offset.
 */
@property (nonatomic) CGPoint flashButtonOffset;

/**
 *  Reads the status of the flash
 */
@property (nonatomic) ALFlashStatus flashStatus;

/**
 *  This property tells Anyline if it should stop reading once a result was found
 */
@property (nonatomic) IBInspectable BOOL cancelOnResult;

/**
 *  This property tells Anyline if it should beep once a result was found
 */
@property (nonatomic) IBInspectable BOOL beepOnResult;

/**
 *  This property tells Anyline if it should blink once a result was found
 */
@property (nonatomic) IBInspectable BOOL blinkOnResult;

/**
 *  This property tells Anyline if it should vibrate once a result was found
 */
@property (nonatomic) IBInspectable BOOL vibrateOnResult;

/**
 * Returns the bounding Rect of the visible Cutout with the correct location on the Module View.
 *
 * @warning May be nil before the layout process is completed.
 */
@property (nonatomic, readonly) CGRect cutoutRect;

/**
 * Returns the bounding Rect of the visible WatermarkView with the correct location on the Module View.
 *
 * @warning May be nil before the layout process is completed or the license is not community.
 */
@property (nonatomic, readonly) CGRect watermarkRect;

/**
 *  Starts the scanning process or sets the error object
 *
 *  @param error The error that occured
 *
 *  @return Boolean indicating if the scanning could be started
 */
- (BOOL)startScanningAndReturnError:(NSError **)error;

/**
 *  Stops the scanning process or sets the error object
 *
 *  @param error The error that occured
 *
 *  @return Boolean indicating if the scanning could be stopped
 */
- (BOOL)cancelScanningAndReturnError:(NSError **)error;

/**
 * Reporting ON Switch, off by default
 *
 * @param enable if YES, anyline will report for QA failed scan tries. Use reportImageForLog in ALC file,
 *               and use the reportScanResultState: for reporting
 */
-(void)enableReporting:(BOOL)enable;

/**
 * @return Boolean indicating if a scanning is in progress.
 */
- (BOOL)isRunning;

/**
 * Stop listening for device motion.
 */
- (void)stopListeningForMotion;
@end

/**
 *  The delegate for the AnylineOCRModuleView.
 */
@protocol AnylineDebugDelegate <NSObject>

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
 *  @param anylineModuleView The AnylineAbstractModuleView
 *  @param variableName         The variable name of the reported value
 *  @param value                The reported value
 */
- (void)anylineModuleView:(AnylineAbstractModuleView *)anylineModuleView
      reportDebugVariable:(NSString *)variableName
                    value:(id)value;
/**
 *  Is called when the processing is aborted for the current image before reaching return.
 *  (If not text is found or confidence is to low, etc.)
 *
 *  @param anylineModuleView The AnylineAbstractModuleView
 *  @param runFailure        The reason why the run failed
 */
- (void)anylineModuleView:(AnylineAbstractModuleView *)anylineModuleView
               runSkipped:(ALRunFailure)runFailure;

@end
