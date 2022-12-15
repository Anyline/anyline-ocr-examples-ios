#import <Foundation/Foundation.h>
#import "ALJSONUtilities.h"

/// The flash mode (whether it starts on, off, in auto mode, or hidden)
typedef NS_ENUM(NSUInteger, ALFlashMode) {

    /// deprecated -- use ALFlashModeManualOff instead, which will give you the same behaviour
    ALFlashModeManual=0,

    /// flash toggle is hidden, no flash
    ALFlashModeNone=1,

    /// uses ambient light to detect whether the flash will turn on or off
    ALFlashModeAuto=2,

    /// starts with the flash toggle off. Can be turned on manually
    ALFlashModeManualOff=3,

    /// starts with the flash toggle on. Can be turned off manually
    ALFlashModeManualOn=4
};

/**
 *  Alignment of the flash button within the scan view.
 */
typedef NS_ENUM(NSUInteger, ALFlashAlignment) {
    /**
     *  Top center. Equivalent to TOP in JSON config.
     */
    ALFlashAlignmentTop=0,
    /**
     *  Top left. Equivalent to TOP_LEFT in JSON config.
     */
    ALFlashAlignmentTopLeft=1,
    /**
     *  Top right. Equivalent to TOP_RIGHT in JSON config.
     */
    ALFlashAlignmentTopRight=2,
    /**
     *  Bottom center. Equivalent to BOTTOM in JSON config.
     */
    ALFlashAlignmentBottom=3,
    /**
     *  Bottom left. Equivalent to BOTTOM_LEFT in JSON config.
     */
    ALFlashAlignmentBottomLeft=4,
    /**
     *  Bottom right. Equivalent to BOTTOM_RIGHT in JSON config.
     */
    ALFlashAlignmentBottomRight=5
};

NS_ASSUME_NONNULL_BEGIN

/// Object configuring the flash module of the scan view
@interface ALFlashConfig : NSObject <ALJSONStringRepresentable>

/// The flash mode
@property (nonatomic, readonly) ALFlashMode flashMode;

/// The starting location of the flash button in the scan view
@property (nonatomic, readonly) ALFlashAlignment flashAlignment;

/// If provided, the image shown for the flash
@property (nonatomic, readonly, nullable) UIImage *flashImage;

/// A point offset positioning the flash button. Used in conjunction with the flash alignment
@property (nonatomic, readonly) CGPoint flashOffset;

/// Initializes an ALFlashConfig with an NSDictionary representing the JSON config object
/// @param JSONDictionary NSDictionary representing the JSON config object
/// @param error NSError object which is filled with appropriate information when initialization fails
/// @return an instance of ALFlashConfig
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary *)JSONDictionary
                                           error:(NSError * _Nullable * _Nullable)error;

/// Creates an ALFlashConfig with an NSDictionary representing the JSON config object
/// @param JSONDictionary NSDictionary representing the JSON config object
/// @return an instance of ALFlashConfig
+ (instancetype _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary;

/// Creates an ALFlashConfig with default values, useful for further customization
+ (instancetype _Nonnull)defaultFlashConfig;

@end


NS_ASSUME_NONNULL_END
