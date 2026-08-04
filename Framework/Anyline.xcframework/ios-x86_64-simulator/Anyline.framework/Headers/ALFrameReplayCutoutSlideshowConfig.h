// To parse this JSON:
//
//   NSError *error;
//   ALFrameReplayCutoutSlideshowConfig *frameReplayCutoutSlideshowConfig = [ALFrameReplayCutoutSlideshowConfig fromJSON:json encoding:NSUTF8Encoding error:&error];

#import <Foundation/Foundation.h>

@class ALFrameReplayCutoutSlideshowConfig;
@class ALFrameReplayCutoutImageConfig;
@class ALFrameReplayImageInfo;
@class ALFrameReplayImageBehavior;
@class ALFrameReplayAppearanceTransition;
@class ALFrameReplayAppearanceEffect;
@class ALFrameReplaySizeTransition;
@class ALFrameReplaySizeEffect;
@class ALFrameReplayExpectedResultContent;
@class ALFrameReplayFlashVisibility;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Boxed enums

/// none, fadeIn (0 to full over durationMs), or fadeOut (full to 0 over the last durationMs
/// of the slide).
@interface ALFrameReplayAppearanceEffect : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALFrameReplayAppearanceEffect *)fadeIn;
+ (ALFrameReplayAppearanceEffect *)fadeOut;
+ (ALFrameReplayAppearanceEffect *)none;
@end

/// none, zoomIn (grows up to fit), or zoomOut (shrinks from fit).
@interface ALFrameReplaySizeEffect : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALFrameReplaySizeEffect *)none;
+ (ALFrameReplaySizeEffect *)zoomIn;
+ (ALFrameReplaySizeEffect *)zoomOut;
@end

/// Gates this slide by the SDK-requested flash/torch state. 'always' (default): shown
/// regardless. 'on': shown only while flash is on. 'off': shown only while flash is off.
/// Lets a replay verify the SDK's flash control drives the frame source — e.g. a slide that
/// only becomes readable once flash turns on.
@interface ALFrameReplayFlashVisibility : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALFrameReplayFlashVisibility *)always;
+ (ALFrameReplayFlashVisibility *)off;
+ (ALFrameReplayFlashVisibility *)on;
@end

#pragma mark - Object interfaces

/// The complete synthetic frame source for one frame-replay run: a set of per-plugin cutout
/// slideshows composited together each frame. Handed to the runner separately from the
/// FrameReplayTestDefinition and used to build the cutout-slideshow custom camera that feeds
/// the engine.
@interface ALFrameReplayCutoutSlideshowConfig : NSObject
/// Opaque fill for the frame area outside every cutout, as a hex color string without a
/// leading '#': 'RRGGBB', or 'AARRGGBB' to include alpha. Follows the same hex-color
/// convention as cutoutConfig (e.g. outerColor / strokeColor).
@property (nonatomic, copy) NSString *backgroundColor;
/// One cutout slideshow per plugin id. Each entry declares the plugin whose cutout it fills
/// and the ordered, timed slides (with per-slide expected result contents) composited into
/// that cutout.
@property (nonatomic, copy) NSArray<ALFrameReplayCutoutImageConfig *> *cutoutImageConfigs;
/// Fallback playback behavior applied to any slide that does not declare its own `behavior`.
/// A slide's own `behavior`, when present, fully replaces this default for that slide
/// (whole-object, not merged field-by-field). Omit to fall back to built-in defaults
/// (hold-forever, no transitions).
@property (nonatomic, nullable, strong) ALFrameReplayImageBehavior *defaultBehavior;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

/// Synthetic-frame building block for a frame-replay test: the slideshow of images
/// composited into a single scan plugin's cutout. One config per plugin id. Ported from the
/// Android CutoutSlideshowCustomCamera example so both platforms share one definition.
@interface ALFrameReplayCutoutImageConfig : NSObject
/// Ordered slides played back inside the cutout as a timed slideshow.
@property (nonatomic, copy) NSArray<ALFrameReplayImageInfo *> *imageInfo;
/// Id of the scan plugin whose cutout this slideshow fills. Matched against the active
/// plugin's config id at runtime.
@property (nonatomic, copy) NSString *pluginID;
@end

/// A single slide: an image, its optional expected result contents, playback behavior (hold
/// duration + transitions), and flash gating.
@interface ALFrameReplayImageInfo : NSObject
/// Playback behavior for this slide (hold duration + optional fade/zoom). When omitted, the
/// slideshow's `defaultBehavior` applies; if that is also absent, built-in defaults
/// (hold-forever, no transitions).
@property (nonatomic, nullable, strong) ALFrameReplayImageBehavior *behavior;
/// Expected contents of the PluginResult produced while this slide is shown, as path/value
/// pairs.
@property (nonatomic, nullable, copy) NSArray<ALFrameReplayExpectedResultContent *> *expectedResultContents;
/// Gates this slide by the SDK-requested flash/torch state. 'always' (default): shown
/// regardless. 'on': shown only while flash is on. 'off': shown only while flash is off.
/// Lets a replay verify the SDK's flash control drives the frame source — e.g. a slide that
/// only becomes readable once flash turns on.
@property (nonatomic, nullable, assign) ALFrameReplayFlashVisibility *flashVisibility;
/// Path of the image under the runner's bundled test assets.
@property (nonatomic, copy) NSString *imagePath;
@end

/// Playback behavior for this slide (hold duration + optional fade/zoom). When omitted, the
/// slideshow's `defaultBehavior` applies; if that is also absent, built-in defaults
/// (hold-forever, no transitions).
///
/// Playback behavior for a frame-replay slide: how long it is held plus its optional
/// fade/zoom transitions. Referenced per-slide (frameReplayImageInfo.behavior) and as the
/// slideshow-wide fallback (defaultBehavior).
///
/// Fallback playback behavior applied to any slide that does not declare its own `behavior`.
/// A slide's own `behavior`, when present, fully replaces this default for that slide
/// (whole-object, not merged field-by-field). Omit to fall back to built-in defaults
/// (hold-forever, no transitions).
@interface ALFrameReplayImageBehavior : NSObject
/// Optional alpha animation applied while the slide is shown.
@property (nonatomic, nullable, strong) ALFrameReplayAppearanceTransition *appearanceTransition;
/// How long this slide is shown before advancing to the next. Omit or 0 means it never
/// advances (single slide or hold-forever).
@property (nonatomic, nullable, strong) NSNumber *durationMS;
/// Optional zoom (Ken-Burns) animation applied while the slide is shown.
@property (nonatomic, nullable, strong) ALFrameReplaySizeTransition *sizeTransition;
@end

/// Optional alpha animation applied while the slide is shown.
///
/// Alpha transition for a slide.
@interface ALFrameReplayAppearanceTransition : NSObject
/// Effect duration in milliseconds. Ignored when effect is none.
@property (nonatomic, nullable, strong) NSNumber *durationMS;
/// none, fadeIn (0 to full over durationMs), or fadeOut (full to 0 over the last durationMs
/// of the slide).
@property (nonatomic, assign) ALFrameReplayAppearanceEffect *effect;
@end

/// Optional zoom (Ken-Burns) animation applied while the slide is shown.
///
/// Zoom transition for a slide.
@interface ALFrameReplaySizeTransition : NSObject
/// Effect duration in milliseconds. Ignored when effect is none.
@property (nonatomic, nullable, strong) NSNumber *durationMS;
/// none, zoomIn (grows up to fit), or zoomOut (shrinks from fit).
@property (nonatomic, assign) ALFrameReplaySizeEffect *effect;
@end

/// A field expected in the PluginResult. Only 'path' is required: the field must be
/// POPULATED at that path (an integration/wiring check). 'value' is optional and, when
/// present, is compared only as a soft, non-gating check — expected values are accuracy
/// testing (Phase 4) and are deliberately omitted here for most fixtures.
@interface ALFrameReplayExpectedResultContent : NSObject
/// Dotted path into the result JSON where a value is expected to be populated.
@property (nonatomic, copy) NSString *path;
/// Optional expected value at path, compared as a soft (non-gating) check when present.
@property (nonatomic, nullable, copy) NSString *value;
@end

NS_ASSUME_NONNULL_END
