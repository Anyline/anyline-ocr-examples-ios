#import <Foundation/Foundation.h>
#import "ALJSONUtilities.h"

NS_ASSUME_NONNULL_BEGIN

/// Cutout starting position within the scan view
typedef NS_ENUM(NSUInteger, ALCutoutAlignment) {

    /// Pinned to top of the scan view
    ALCutoutAlignmentTop = 0,

    /// Pinned to middle of the upper half of the scan view
    ALCutoutAlignmentTopHalf,

    /// Pinned to the center of the scan view
    ALCutoutAlignmentCenter,

    /// Pinned to middle of the bottom half of the scan view
    ALCutoutAlignmentBottomHalf,

    /// Pinned to bottom of the scanview
    ALCutoutAlignmentBottom
};

/// Cutout animation appearance
typedef NS_ENUM(NSUInteger, ALCutoutAnimationStyle) {
    /// Cutout appears normally when scan view is loaded
    ALCutoutAnimationStyleNone = 0,

    /// Cutout appears through a fade animation when scan view is loaded
    ALCutoutAnimationStyleFade,

    /// Cutout appears throgh a zoom animation when scan view is loaded
    ALCutoutAnimationStyleZoom
};

/// Configuration object for a plugin's cutout visible on the ScanView
@interface ALCutoutConfig : NSObject <ALJSONStringRepresentable>

/// Preset position indicating where a cutout is generally placed
@property (nonatomic, readonly) ALCutoutAlignment alignment;

/// Suggested width in pixels (based on device capture resolution width) of the cutout.
/// Used, unless maxWidthPercent is specified, and evaluates to a smaller width.
@property (nonatomic, readonly) NSInteger width;

/// The maximum width in percent (0-100) of the scan view the cutout will occupy
@property (nonatomic, readonly) NSInteger maxWidthPercent;

/// The maximum height in percent (0-100) of the scan view the cutout will occupy
@property (nonatomic, readonly) NSInteger maxHeightPercent;

/// A CGSize value indicating the cutout width-height ratio
@property (nonatomic, readonly) CGSize ratioFromSize;

/// Stroke width of the cutout
@property (nonatomic, readonly) NSInteger strokeWidth;

/// Stroke color of the cutout: use a hex string ("00CCFF")
@property (nonatomic, readonly) NSString *strokeColor;

/// Color of the cutout when the scanner is reporting feedback: use a hex string (eg "00CCFF")
@property (nonatomic, readonly) NSString *feedbackStrokeColor;

/// Amount of corner rounding applied to the cutout
@property (nonatomic, readonly) NSInteger cornerRadius;

/// Background color as a hex string. Use a hex string format ("XXXXXX", or "XXXXXXXX" in which the
/// alpha component takes the first two characters).
@property (nonatomic, readonly) NSString *outerColor;

/// Position offset of the cutout, used in conjunction with `alignment`
@property (nonatomic, readonly) CGPoint offset;

/// (Not currently supported) image used for the cutout
@property (nonatomic, readonly) NSString *image;

/// (Not currently supported) animation shown with the cutout
@property (nonatomic, readonly) ALCutoutAnimationStyle animation;

/// Amount of padding to be applied to the cutout (use positive amounts only). A crop padding
/// truncates the visual area represented by the cutout; used in optimizing scan performance
/// for some plugins
@property (nonatomic, readonly) CGSize cropPadding;

/// Used in conjunction with `cropPadding`. The offset further adjusts the crop position after
/// the padding is applied
@property (nonatomic, readonly) CGPoint cropOffset;

/// The cutout alignment as a human-readable string
@property (nonatomic, readonly) NSString *alignmentString;

/// The cutout animation as a human-readable string
@property (nonatomic, readonly) NSString *animationString;

/// Used to create a cutout configuration with default values; possibly useful as a base for further customization
+ (ALCutoutConfig *)defaultCutoutConfig;

/// Initializes a CutoutConfig with a JSON Dictionary
/// @param JSONDict JSON dictionary. "cutoutConfig" can be the parent node
/// @param error an NSError object which is filled when attempting to initialize with the JSON fails
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary *)JSONDict error:(NSError * _Nullable * _Nullable)error;

/// Convenience initializer that takes a JSON Dictionary
/// @param JSONDict the JSON Dictionary
+ (ALCutoutConfig * _Nullable)withJSONDictionary:(NSDictionary *)JSONDict;

@end

NS_ASSUME_NONNULL_END
