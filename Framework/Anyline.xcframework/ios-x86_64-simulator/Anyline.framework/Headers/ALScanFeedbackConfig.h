#import <Foundation/Foundation.h>
#import "ALJSONUtilities.h"

NS_ASSUME_NONNULL_BEGIN

/// The scan feedback style
typedef NS_ENUM(NSUInteger, ALScanFeedbackStyle) {

    /// Shows a rectangle around the detected object
    ALScanFeedbackStyleRect=0,

    /// Shows rectangles surrounding each character/symbol in the detected object
    ALScanFeedbackStyleContourRect,

    /// Shows underlines underneath each character/symbol in the detected object
    ALScanFeedbackStyleContourUnderline __deprecated_enum_msg("ALScanFeedbackStyleContourUnderline has been deprecated. Use ALScanFeedbackStyleContourRect instead.") = ALScanFeedbackStyleContourRect,

    /// Shows points over each character/symbol in the detected object
    ALScanFeedbackStyleContourPoint __deprecated_enum_msg("ALScanFeedbackStyleContourPoint has been deprecated. Use ALScanFeedbackStyleContourRect instead.") = ALScanFeedbackStyleContourRect,

    /// Animates the cutout rectangle when a sample is detected
    ALScanFeedbackStyleAnimatedRect,

    /// No visible feedback is displayed
    ALScanFeedbackStyleNone
};

/// The scan feedback animation style
typedef NS_ENUM(NSUInteger, ALFeedbackAnimationStyle) {

    /// Uses the "traverse single" animation style
    ALFeedbackAnimationStyleTraverseSingle = 0,

    /// Uses the "traverse multi" animation style
    ALFeedbackAnimationStyleTraverseMulti,

    /// Uses the "kitt" animation style
    ALFeedbackAnimationStyleKitt,

    /// Uses the "blink" animation style
    ALFeedbackAnimationStyleBlink,

    /// Uses the "resize" animation style
    ALFeedbackAnimationStyleResize,

    /// Uses the "pulse" animation style
    ALFeedbackAnimationStylePulse,

    /// Uses the "random pulse" animation style
    ALFeedbackAnimationStylePulseRandom,

    /// No animation is shown with the visual scan feedback
    ALFeedbackAnimationStyleNone
};

/// Object configuring how the scan view responds when it finds an object
/// it recognizes
@interface ALScanFeedbackConfig : NSObject <ALJSONStringRepresentable>

/// The scan feedback style displayed when an object is detected
@property (nonatomic, readonly) ALScanFeedbackStyle feedbackStyle;

/// Stroke color of the visual feedback. Use a "XXXXXX" hex string
@property (nonatomic, readonly) NSString *strokeColor;

/// Stroke color of the visual feedback. Use a "XXXXXXXX" hex string with the
/// first two characters representing the alpha component of the fill
@property (nonatomic, readonly) NSString *fillColor;

/// Stroke width of the visual feedback
@property (nonatomic, readonly) NSInteger strokeWidth;

/// The corner rounding level for visual feedback
@property (nonatomic, readonly) NSInteger cornerRadius;

/// The amount of time the visual feedback remains on screen until it is removed
@property (nonatomic, assign) NSInteger redrawTimeout;

/// How long the animation lasts, in ms
@property (nonatomic, readonly) NSInteger animationDuration;

/// The animation style used with the visual feedback drawn on the scan view
@property (nonatomic, readonly) ALFeedbackAnimationStyle animationStyle;

/// Indicate whether a brief "flicker" of the scan view is shown when an object
/// is successfully scanned
@property (nonatomic, readonly) BOOL blinkAnimationOnResult;

/// Indicate whether a device beep sound is played when an object is successfully
/// scanned
@property (nonatomic, readonly) BOOL beepOnResult;

/// Indicate whether the device will vibrate briefly when an object is successfully
/// scanned
@property (nonatomic, readonly) BOOL vibrateOnResult;

/// The string representation of the feedback style
@property (nonatomic, readonly) NSString *feedbackStyleStr;

/// The string representation of the feedback animation style
@property (nonatomic, readonly) NSString *animationStyleStr;

/// Initializes an `ALScanFeedbackConfig` with an `NSDictionary` representing the JSON config object
/// @param JSONDictionary an `NSDictionary` representing the JSON config object
/// @param error `NSError` object which is filled with appropriate information when initialization fails
/// @return an instance of ALScanFeedbackConfig
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary * _Nonnull)JSONDictionary
                                           error:(NSError * _Nullable * _Nullable)error;

/// Creates an ALScanFeedbackConfig with an NSDictionary representing the JSON config object
/// @param JSONDictionary NSDictionary representing the JSON config object
/// @return an instance of ALScanFeedbackConfig
+ (ALScanFeedbackConfig * _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary;

/// Creates an ALScanFeedbackConfig with default values set. Useful for further customization
///
/// @return an instance of ALScanFeedbackConfig
+ (ALScanFeedbackConfig *)defaultScanFeedbackConfig;

- (instancetype)initWithFeedbackStyle:(ALScanFeedbackStyle)feedbackStyle
                       animationStyle:(ALFeedbackAnimationStyle)animationStyle
                    animationDuration:(NSInteger)animationDuration
                          strokeWidth:(NSInteger)strokeWidth
                          strokeColor:(NSString * _Nullable)strokeColor
                            fillColor:(NSString * _Nullable)fillColor
                         cornerRadius:(NSInteger)cornerRadius
                        redrawTimeout:(NSInteger)redrawTimeout
                         beepOnResult:(BOOL)beepOnResult
               blinkAnimationOnResult:(BOOL)blinkAnimationOnResult
                      vibrateOnResult:(BOOL)vibrateOnResult NS_DESIGNATED_INITIALIZER;

+ (ALScanFeedbackConfig *)withFeedbackStyle:(ALScanFeedbackStyle)feedbackStyle
                             animationStyle:(ALFeedbackAnimationStyle)animationStyle
                          animationDuration:(NSInteger)animationDuration
                                strokeWidth:(NSInteger)strokeWidth
                                strokeColor:(NSString * _Nullable)strokeColor
                                  fillColor:(NSString * _Nullable)fillColor
                               cornerRadius:(NSInteger)cornerRadius
                              redrawTimeout:(NSInteger)redrawTimeout
                               beepOnResult:(BOOL)beepOnResult
                     blinkAnimationOnResult:(BOOL)blinkAnimationOnResult
                            vibrateOnResult:(BOOL)vibrateOnResult;

@end

NS_ASSUME_NONNULL_END
