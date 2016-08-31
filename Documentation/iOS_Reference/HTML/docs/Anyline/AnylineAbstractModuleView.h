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

#import "AnylineController.h"

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
 * Report scan result
 *
 * @param scanResultState There are 3 different possible states.
 *
 * ALScanResultUserDidAbortState - The App should report this state to Anyline when the user stopped scanning / switched
 *                                      to manual entry without scanning 1 successful entry. When there was a successful scan
 *                                      stopping should be ignored.
 *
 * ALScanResultScanSuccessfulState - The App should report this state to Anyline when Anyline returned a value and the value
 *                                   was validated by the backend or the user.
 *
 * ALScanResultScanErrorWrongResultState - The App should report this state to Anyline when the result from Anyline was wrong
 *                                         or the user edited the values.
 */
- (void)reportScanResultState:(ALScanResultState)scanResultState;

/**
 * @return Boolean indicating if a scanning is in progress.
 */
- (BOOL)isRunning;

@end
