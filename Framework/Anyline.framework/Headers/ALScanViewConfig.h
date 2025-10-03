#import <Foundation/Foundation.h>

@class ALScanViewConfig;
@class ALCameraConfig;
@class ALFlashConfig;
@class ALFlashConfigAlignment;
@class ALMode;
@class ALOffset;
@class ALViewPluginCompositeConfig;
@class ALProcessingMode;
@class ALViewPlugin;
@class ALViewPluginConfig;
@class ALCutoutConfig;
@class ALCutoutConfigAlignment;
@class ALCutoutConfigAnimation;
@class ALRatioFromSize;
@class ALPluginConfig;
@class ALBarcodeConfig;
@class ALBarcodeFormat;
@class ALCommercialTireIDConfig;
@class ALUpsideDownMode;
@class ALContainerConfig;
@class ALContainerConfigScanMode;
@class ALJapaneseLandingPermissionConfig;
@class ALJapaneseLandingPermissionConfigFieldOption;
@class ALMrzScanOption;
@class ALLicensePlateConfig;
@class ALLicensePlateConfigScanMode;
@class ALVehicleInspectionSticker;
@class ALMeterConfig;
@class ALMeterConfigScanMode;
@class ALMrzConfig;
@class ALMrzFieldScanOptions;
@class ALMrzMinFieldConfidences;
@class ALOcrConfig;
@class ALOcrConfigScanMode;
@class ALOdometerConfig;
@class ALStartVariable;
@class ALTinConfig;
@class ALTinConfigScanMode;
@class ALTireMakeConfig;
@class ALTireSizeConfig;
@class ALUniversalIDConfig;
@class ALAllowedLayouts;
@class ALAlphabet;
@class ALLayoutDrivingLicense;
@class ALUniversalIDField;
@class ALLayoutInsuranceCard;
@class ALLayoutMrz;
@class ALLayoutIDFront;
@class ALVehicleRegistrationCertificateConfig;
@class ALLayoutVehicleRegistrationCertificate;
@class ALVehicleRegistrationCertificateField;
@class ALVinConfig;
@class ALScanFeedbackConfig;
@class ALScanFeedbackConfigAnimation;
@class ALStyle;
@class ALUIFeedbackConfig;
@class ALUIFeedbackElementConfig;
@class ALContentTypeEnum;
@class ALUIFeedbackElementAttributesConfig;
@class ALImageScaleType;
@class ALTextAlignment;
@class ALUIFeedbackElementContentConfig;
@class ALOverlayConfig;
@class ALOverlayAnchorConfig;
@class ALOverlayDimensionConfig;
@class ALOverlayScaleConfig;
@class ALOverlayScaleTypeConfig;
@class ALUIFeedbackPresetConfig;
@class ALUIFeedbackPresetAttributeConfig;
@class ALOverlaySource;
@class ALUIFeedbackElementTriggerConfig;
@class ALUIFeedbackElementTriggerWhenRunSkippedConfig;
@class ALRunSkippedWhen;
@class ALUIFeedbackElementTriggerWhenScanInfoConfig;
@class ALScanInfoWhen;
@class ALUIFeedbackPresetDefinitionConfig;
@class ALUIFeedbackPresetDefinitionAttributeConfig;
@class ALElementTypeEnum;
@class ALUIFeedbackPresetContentConfig;
@class ALType;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Boxed enums

/// The alignment of the flash button.
@interface ALFlashConfigAlignment : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALFlashConfigAlignment *)bottom;
+ (ALFlashConfigAlignment *)bottomLeft;
+ (ALFlashConfigAlignment *)bottomRight;
+ (ALFlashConfigAlignment *)top;
+ (ALFlashConfigAlignment *)topLeft;
+ (ALFlashConfigAlignment *)topRight;
@end

/// The flash mode.
@interface ALMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALMode *)manual;
+ (ALMode *)manualOff;
+ (ALMode *)manualOn;
+ (ALMode *)modeAuto;
+ (ALMode *)none;
@end

/// The processing mode of the workflow (parallel, sequential, parallelFirstScan).
@interface ALProcessingMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALProcessingMode *)parallel;
+ (ALProcessingMode *)parallelFirstScan;
+ (ALProcessingMode *)sequential;
@end

/// The alignment of the cutout area.
@interface ALCutoutConfigAlignment : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALCutoutConfigAlignment *)bottom;
+ (ALCutoutConfigAlignment *)bottomHalf;
+ (ALCutoutConfigAlignment *)center;
+ (ALCutoutConfigAlignment *)top;
+ (ALCutoutConfigAlignment *)topHalf;
@end

/// Animation type for the cutout when initially displayed. Values: none, fade, zoom
@interface ALCutoutConfigAnimation : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALCutoutConfigAnimation *)fade;
+ (ALCutoutConfigAnimation *)none;
+ (ALCutoutConfigAnimation *)zoom;
@end

@interface ALBarcodeFormat : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALBarcodeFormat *)all;
+ (ALBarcodeFormat *)aztec;
+ (ALBarcodeFormat *)aztecInverse;
+ (ALBarcodeFormat *)bookland;
+ (ALBarcodeFormat *)codabar;
+ (ALBarcodeFormat *)code11;
+ (ALBarcodeFormat *)code128;
+ (ALBarcodeFormat *)code32;
+ (ALBarcodeFormat *)code39;
+ (ALBarcodeFormat *)code93;
+ (ALBarcodeFormat *)coupon;
+ (ALBarcodeFormat *)dataMatrix;
+ (ALBarcodeFormat *)databar;
+ (ALBarcodeFormat *)discrete2_5;
+ (ALBarcodeFormat *)dotCode;
+ (ALBarcodeFormat *)ean13;
+ (ALBarcodeFormat *)ean8;
+ (ALBarcodeFormat *)gs1128;
+ (ALBarcodeFormat *)gs1QrCode;
+ (ALBarcodeFormat *)isbt128;
+ (ALBarcodeFormat *)issnEan;
+ (ALBarcodeFormat *)itf;
+ (ALBarcodeFormat *)kix;
+ (ALBarcodeFormat *)matrix2_5;
+ (ALBarcodeFormat *)maxicode;
+ (ALBarcodeFormat *)microPDF;
+ (ALBarcodeFormat *)microQr;
+ (ALBarcodeFormat *)msi;
+ (ALBarcodeFormat *)oneDInverse;
+ (ALBarcodeFormat *)pdf417;
+ (ALBarcodeFormat *)postUk;
+ (ALBarcodeFormat *)qrCode;
+ (ALBarcodeFormat *)qrInverse;
+ (ALBarcodeFormat *)rss14;
+ (ALBarcodeFormat *)rssExpanded;
+ (ALBarcodeFormat *)trioptic;
+ (ALBarcodeFormat *)upcA;
+ (ALBarcodeFormat *)upcE;
+ (ALBarcodeFormat *)upcEanExtension;
+ (ALBarcodeFormat *)upuFics;
+ (ALBarcodeFormat *)usPlanet;
+ (ALBarcodeFormat *)usPostnet;
+ (ALBarcodeFormat *)usps4Cb;
@end

/// Sets whether the text shall also be scanned upside-down.
@interface ALUpsideDownMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALUpsideDownMode *)disabled;
+ (ALUpsideDownMode *)enabled;
+ (ALUpsideDownMode *)upsideDownModeAUTO;
@end

/// Determines if container numbers shall be scanned horizontally or vertically.
@interface ALContainerConfigScanMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALContainerConfigScanMode *)horizontal;
+ (ALContainerConfigScanMode *)vertical;
@end

/// The scanOption determines whether a field is considered optional, mandatory, disabled or
/// follows a default behavior. Default behavior is one of the other three that yields the
/// best recall results with all layouts enabled.
///
/// The mrzScanOption determines whether a field is considered optional, mandatory, disabled
/// or follows a default behavior.
@interface ALMrzScanOption : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALMrzScanOption *)disabled;
+ (ALMrzScanOption *)mandatory;
+ (ALMrzScanOption *)mrzScanOptionDefault;
+ (ALMrzScanOption *)optional;
@end

/// Specifies a country or location of which license plates shall be scanned.
@interface ALLicensePlateConfigScanMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALLicensePlateConfigScanMode *)africa;
+ (ALLicensePlateConfigScanMode *)albania;
+ (ALLicensePlateConfigScanMode *)andorra;
+ (ALLicensePlateConfigScanMode *)armenia;
+ (ALLicensePlateConfigScanMode *)austria;
+ (ALLicensePlateConfigScanMode *)azerbaijan;
+ (ALLicensePlateConfigScanMode *)belarus;
+ (ALLicensePlateConfigScanMode *)belgium;
+ (ALLicensePlateConfigScanMode *)bosniaandherzegovina;
+ (ALLicensePlateConfigScanMode *)bulgaria;
+ (ALLicensePlateConfigScanMode *)canada;
+ (ALLicensePlateConfigScanMode *)croatia;
+ (ALLicensePlateConfigScanMode *)cyprus;
+ (ALLicensePlateConfigScanMode *)czech;
+ (ALLicensePlateConfigScanMode *)denmark;
+ (ALLicensePlateConfigScanMode *)estonia;
+ (ALLicensePlateConfigScanMode *)finland;
+ (ALLicensePlateConfigScanMode *)france;
+ (ALLicensePlateConfigScanMode *)georgia;
+ (ALLicensePlateConfigScanMode *)germany;
+ (ALLicensePlateConfigScanMode *)greece;
+ (ALLicensePlateConfigScanMode *)hungary;
+ (ALLicensePlateConfigScanMode *)iceland;
+ (ALLicensePlateConfigScanMode *)ireland;
+ (ALLicensePlateConfigScanMode *)italy;
+ (ALLicensePlateConfigScanMode *)latvia;
+ (ALLicensePlateConfigScanMode *)liechtenstein;
+ (ALLicensePlateConfigScanMode *)lithuania;
+ (ALLicensePlateConfigScanMode *)luxembourg;
+ (ALLicensePlateConfigScanMode *)malta;
+ (ALLicensePlateConfigScanMode *)moldova;
+ (ALLicensePlateConfigScanMode *)monaco;
+ (ALLicensePlateConfigScanMode *)montenegro;
+ (ALLicensePlateConfigScanMode *)netherlands;
+ (ALLicensePlateConfigScanMode *)northmacedonia;
+ (ALLicensePlateConfigScanMode *)norway;
+ (ALLicensePlateConfigScanMode *)norwayspecial;
+ (ALLicensePlateConfigScanMode *)poland;
+ (ALLicensePlateConfigScanMode *)portugal;
+ (ALLicensePlateConfigScanMode *)romania;
+ (ALLicensePlateConfigScanMode *)russia;
+ (ALLicensePlateConfigScanMode *)scanModeAuto;
+ (ALLicensePlateConfigScanMode *)serbia;
+ (ALLicensePlateConfigScanMode *)slovakia;
+ (ALLicensePlateConfigScanMode *)slovenia;
+ (ALLicensePlateConfigScanMode *)spain;
+ (ALLicensePlateConfigScanMode *)sweden;
+ (ALLicensePlateConfigScanMode *)switzerland;
+ (ALLicensePlateConfigScanMode *)turkey;
+ (ALLicensePlateConfigScanMode *)ukraine;
+ (ALLicensePlateConfigScanMode *)unitedkingdom;
+ (ALLicensePlateConfigScanMode *)unitedstates;
@end

/// Select if the visual inspection sticker should be scanned. If OPTIONAL, the visual
/// inspection sticker will only be returned if found successfully. If MANDATORY the scan
/// will only return if found successfully. Not available on africa and unitedstates.
@interface ALVehicleInspectionSticker : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALVehicleInspectionSticker *)disabled;
+ (ALVehicleInspectionSticker *)mandatory;
+ (ALVehicleInspectionSticker *)optional;
@end

/// Determines which types of meters to scan.
@interface ALMeterConfigScanMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALMeterConfigScanMode *)autoAnalogDigitalMeter;
+ (ALMeterConfigScanMode *)dialMeter;
+ (ALMeterConfigScanMode *)digitalMeter2_Experimental;
+ (ALMeterConfigScanMode *)multiFieldDigitalMeter;
@end

/// Sets whether to scan single-line texts, multi-line texts in a grid-formation or finds
/// text automatically.
@interface ALOcrConfigScanMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALOcrConfigScanMode *)grid;
+ (ALOcrConfigScanMode *)line;
+ (ALOcrConfigScanMode *)scanModeAuto;
@end

/// Sets the mode to scan universal TIN numbers ('UNIVERSAL') or TIN numbers of any length
/// starting with DOT ('DOT').
@interface ALTinConfigScanMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALTinConfigScanMode *)dot;
+ (ALTinConfigScanMode *)universal;
@end

/// Sets a specific character set.
@interface ALAlphabet : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALAlphabet *)arabic;
+ (ALAlphabet *)cyrillic;
+ (ALAlphabet *)latin;
@end

/// The animation style of the feedback.
@interface ALScanFeedbackConfigAnimation : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALScanFeedbackConfigAnimation *)blink;
+ (ALScanFeedbackConfigAnimation *)kitt;
+ (ALScanFeedbackConfigAnimation *)none;
+ (ALScanFeedbackConfigAnimation *)pulse;
+ (ALScanFeedbackConfigAnimation *)pulseRandom;
+ (ALScanFeedbackConfigAnimation *)resize;
+ (ALScanFeedbackConfigAnimation *)traverseMulti;
+ (ALScanFeedbackConfigAnimation *)traverseSingle;
@end

/// The style of the feedback.
@interface ALStyle : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALStyle *)animatedRect;
+ (ALStyle *)contourPoint;
+ (ALStyle *)contourRect;
+ (ALStyle *)contourUnderline;
+ (ALStyle *)none;
+ (ALStyle *)rect;
@end

/// Sets the view type of the element.
@interface ALContentTypeEnum : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALContentTypeEnum *)image;
+ (ALContentTypeEnum *)sound;
+ (ALContentTypeEnum *)text;
@end

/// Sets the image scale type.
@interface ALImageScaleType : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALImageScaleType *)center;
+ (ALImageScaleType *)centerCrop;
+ (ALImageScaleType *)fitCenter;
+ (ALImageScaleType *)fitXy;
@end

/// Sets the text alignment.
@interface ALTextAlignment : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALTextAlignment *)center;
+ (ALTextAlignment *)left;
+ (ALTextAlignment *)right;
@end

/// Sets the anchor of the overlay.
///
/// Sets the anchor of the overlay relative to the source defined in the overlaySource.
@interface ALOverlayAnchorConfig : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALOverlayAnchorConfig *)bottomCenter;
+ (ALOverlayAnchorConfig *)bottomLeft;
+ (ALOverlayAnchorConfig *)bottomRight;
+ (ALOverlayAnchorConfig *)center;
+ (ALOverlayAnchorConfig *)centerLeft;
+ (ALOverlayAnchorConfig *)centerRight;
+ (ALOverlayAnchorConfig *)topCenter;
+ (ALOverlayAnchorConfig *)topLeft;
+ (ALOverlayAnchorConfig *)topRight;
@end

/// Sets the scale type of the overlay.
@interface ALOverlayScaleTypeConfig : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALOverlayScaleTypeConfig *)fixedPx;
+ (ALOverlayScaleTypeConfig *)keepRatio;
+ (ALOverlayScaleTypeConfig *)none;
+ (ALOverlayScaleTypeConfig *)overlay;
@end

/// Sets the source of the overlay.
///
/// Sets the source of the overlay. Currently cutout is the only available overlay source.
@interface ALOverlaySource : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALOverlaySource *)cutout;
@end

/// Sets the preset definition attribute element type.
@interface ALElementTypeEnum : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALElementTypeEnum *)any;
+ (ALElementTypeEnum *)boolean;
+ (ALElementTypeEnum *)elementTypeDouble;
+ (ALElementTypeEnum *)elementTypeInt;
+ (ALElementTypeEnum *)elementTypeLong;
+ (ALElementTypeEnum *)string;
@end

/// Sets the preset definition type.
@interface ALType : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALType *)preset;
+ (ALType *)presetElement;
+ (ALType *)presetElementOverlay;
+ (ALType *)presetElementTrigger;
@end

#pragma mark - Object interfaces

/// Schema for SDK JSON configurations
@interface ALScanViewConfig : NSObject
@property (nonatomic, nullable, strong) ALCameraConfig *cameraConfig;
@property (nonatomic, nullable, strong) ALFlashConfig *flashConfig;
@property (nonatomic, nullable, copy)   NSDictionary<NSString *, id> *options;
/// An optional description for the entire ScanView configuration.
@property (nonatomic, nullable, copy)   NSString *scanViewConfigDescription;
@property (nonatomic, nullable, strong) ALViewPluginCompositeConfig *viewPluginCompositeConfig;
@property (nonatomic, nullable, strong) ALViewPluginConfig *viewPluginConfig;

@end

/// Schema for SDK Camera Configuration
@interface ALCameraConfig : NSObject
/// The preferred resolution for video capture (720p, 1080p, 4K). This resolution is used to
/// process images for scanning. 4K resolution is only supported for barcode scanning.
@property (nonatomic, copy) NSString *captureResolution;
/// Preferred camera to open: FRONT (front-facing), BACK (rear-facing), EXTERNAL (external
/// rear), EXTERNAL_FRONT (external front), TELE (iOS-only; requests the telephoto lens and
/// is honored only on devices that have one; on Android or on iOS devices without a tele
/// lens BACK will be used).
@property (nonatomic, nullable, copy) NSString *defaultCamera;
/// (EXPERIMENTAL; Android-only) Mirrors the frame sideways (left-right) before it is
/// processed, equivalent to a horizontal flip along the vertical axis. The camera preview on
/// the screen is not affected. Disabled by default. NOTE: This has no effect when
/// pluginConfig.barcodeConfig.fastProcessMode is true.
@property (nonatomic, nullable, strong) NSNumber *enableFlipFramesLeftRight;
/// (EXPERIMENTAL; Android-only) Turns the frame upside down (top-bottom) before it is
/// processed, equivalent to a vertical flip along the horizontal axis. The camera preview on
/// the screen is not affected. Disabled by default. NOTE: This has no effect when
/// pluginConfig.barcodeConfig.fastProcessMode is true.
@property (nonatomic, nullable, strong) NSNumber *enableFlipFramesTopBottom;
/// Allow user to tap on the preview to focus the camera on a specific area of the screen
/// (also known as tap-to-focus). Enabled by default.
@property (nonatomic, nullable, strong) NSNumber *enableTapToFocus;
/// Optional cameras to fall back if the defaultCamera is not found.
@property (nonatomic, nullable, copy) NSArray<NSString *> *fallbackCameras;
/// The focal length.
@property (nonatomic, nullable, strong) NSNumber *focalLength;
/// The maximum focal length.
@property (nonatomic, nullable, strong) NSNumber *maxFocalLength;
/// The maximum zoom ratio.
@property (nonatomic, nullable, strong) NSNumber *maxZoomRatio;
/// Deprecated - do not use! The preferred resolution for taking images (720, 720p, 1080,
/// 1080p).
@property (nonatomic, nullable, copy) NSString *pictureResolution;
/// (Note: this functionality is experimental - use at your own risk.) Duration in
/// milliseconds after which tap-to-focus automatically returns to continuous autofocus mode.
/// Range: 1000-60000ms.
@property (nonatomic, nullable, strong) NSNumber *tapToFocusTimeoutMS;
/// This flag enables or disables the zoom gesture if supported.
@property (nonatomic, nullable, strong) NSNumber *zoomGesture;
/// The zoom ratio.
@property (nonatomic, nullable, strong) NSNumber *zoomRatio;
@end

/// Schema for SDK Flash Configuration
@interface ALFlashConfig : NSObject
/// The alignment of the flash button.
@property (nonatomic, nullable, assign) ALFlashConfigAlignment *alignment;
/// The asset name of the icon to be displayed when the flash is set to auto.
@property (nonatomic, nullable, copy) NSString *imageAuto;
/// The asset name of the icon to be displayed when the flash is off.
@property (nonatomic, nullable, copy) NSString *imageOff;
/// The asset name of the icon to be displayed when the flash is on.
@property (nonatomic, nullable, copy) NSString *imageOn;
/// The flash mode.
@property (nonatomic, nullable, assign) ALMode *mode;
/// An optional offset (in dp) for the flash button.
@property (nonatomic, nullable, strong) ALOffset *offset;
@end

/// An optional offset (in dp) for the flash button.
///
/// An optional offset (in dp) for the elements.
///
/// Used in conjunction with cropPadding. This offset further adjusts the crop position after
/// the padding is applied. Define as an x-y point structure.
///
/// Amount of padding to be applied to the cutout (NOTE: use positive amounts only). A crop
/// padding truncates the visual area represented by the cutout used in optimizing scan
/// performance for some plugins. Define as an x-y point structure.
///
/// Position offset of the cutout, used in conjunction with alignment.
@interface ALOffset : NSObject
@property (nonatomic, nullable, strong) NSNumber *x;
@property (nonatomic, nullable, strong) NSNumber *y;
@end

/// Schema for SDK ViewPlugin Configuration
@interface ALViewPluginCompositeConfig : NSObject
/// The ID (name) of the workflow.
@property (nonatomic, copy) NSString *identifier;
/// The processing mode of the workflow (parallel, sequential, parallelFirstScan).
@property (nonatomic, assign) ALProcessingMode *processingMode;
/// The ordered list of viewPlugins, each as JSON object with a given viewPluginConfig.
@property (nonatomic, copy) NSArray<ALViewPlugin *> *viewPlugins;
@end

@interface ALViewPlugin : NSObject
@property (nonatomic, nullable, strong) ALViewPluginConfig *viewPluginConfig;
@end

/// Schema for SDK ViewPlugin Configuration
@interface ALViewPluginConfig : NSObject
@property (nonatomic, nullable, strong) ALCutoutConfig *cutoutConfig;
@property (nonatomic, strong)           ALPluginConfig *pluginConfig;
@property (nonatomic, nullable, strong) ALScanFeedbackConfig *scanFeedbackConfig;
@property (nonatomic, nullable, strong) ALUIFeedbackConfig *uiFeedbackConfig;
@end

/// Schema for SDK Cutout Configuration
@interface ALCutoutConfig : NSObject
/// The alignment of the cutout area.
@property (nonatomic, nullable, assign) ALCutoutConfigAlignment *alignment;
/// Animation type for the cutout when initially displayed. Values: none, fade, zoom
@property (nonatomic, nullable, assign) ALCutoutConfigAnimation *animation;
/// Radius of the corners of the cutout.
@property (nonatomic, nullable, strong) NSNumber *cornerRadius;
/// Used in conjunction with cropPadding. This offset further adjusts the crop position after
/// the padding is applied. Define as an x-y point structure.
@property (nonatomic, nullable, strong) ALOffset *cropOffset;
/// Amount of padding to be applied to the cutout (NOTE: use positive amounts only). A crop
/// padding truncates the visual area represented by the cutout used in optimizing scan
/// performance for some plugins. Define as an x-y point structure.
@property (nonatomic, nullable, strong) ALOffset *cropPadding;
/// The hex string (RRGGBB) of the stroke color for visual feedback. (e.g. 00CCFF).
@property (nonatomic, nullable, copy) NSString *feedbackStrokeColor;
/// The maximum height in percent (0-100), relating to the size of the view.
@property (nonatomic, nullable, copy) NSString *maxHeightPercent;
/// The maximum width in percent (0-100), relating to the size of the view.
@property (nonatomic, nullable, copy) NSString *maxWidthPercent;
/// Position offset of the cutout, used in conjunction with alignment.
@property (nonatomic, nullable, strong) ALOffset *offset;
/// Optional transparency factor for the outer color (0.0 - 1.0).
@property (nonatomic, nullable, strong) NSNumber *outerAlpha;
/// Background color as a 6-digit (RRGGBB) or 8-digit (AARRGGBB) hex string.
@property (nonatomic, nullable, copy) NSString *outerColor;
/// A size constraining the ratio of width / height. If set to 0, the ratio will be equal to
/// the full frame. For the optimal ratio for each technical capability have a look at the
/// Technical Capabilities section at documentation.anyline.com.
@property (nonatomic, nullable, strong) ALRatioFromSize *ratioFromSize;
/// The hex string (RRGGBB) of the stroke color. (e.g. 00CCFF).
@property (nonatomic, nullable, copy) NSString *strokeColor;
/// The stroke width of the cutout. If set to 0, the line will be invisible.
@property (nonatomic, nullable, strong) NSNumber *strokeWidth;
/// The preferred width in pixels, relating to the camera resolution. If not specified or 0,
/// the maximum possible width will be chosen.
@property (nonatomic, nullable, strong) NSNumber *width;
@end

/// A size constraining the ratio of width / height. If set to 0, the ratio will be equal to
/// the full frame. For the optimal ratio for each technical capability have a look at the
/// Technical Capabilities section at documentation.anyline.com.
@interface ALRatioFromSize : NSObject
@property (nonatomic, nullable, strong) NSNumber *height;
@property (nonatomic, nullable, strong) NSNumber *width;
@end

/// General configuration for scan plugins
@interface ALPluginConfig : NSObject
@property (nonatomic, nullable, strong) ALBarcodeConfig *barcodeConfig;
/// Sets whether or not to continue scanning once a result is found.
@property (nonatomic, nullable, strong) NSNumber *cancelOnResult;
@property (nonatomic, nullable, strong) ALCommercialTireIDConfig *commercialTireIDConfig;
/// This option allows to finetune the handling results of the same content when scanning
/// continuously. If the option is set to -1, equal results will not be reported again until
/// the scanning process is stopped. Setting this option to 0 will report equal results every
/// time it is found. Setting this option to greater than 0 indicates how much time
/// (milliseconds) must pass by not detecting the result before it will be detected again.
/// (This feature is currently only supported in Barcode scanning)
@property (nonatomic, nullable, strong) NSNumber *consecutiveEqualResultFilter;
@property (nonatomic, nullable, strong) ALContainerConfig *containerConfig;
/// Sets a name for the scan plugin.
@property (nonatomic, copy)             NSString *identifier;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionConfig *japaneseLandingPermissionConfig;
@property (nonatomic, nullable, strong) ALLicensePlateConfig *licensePlateConfig;
@property (nonatomic, nullable, strong) ALMeterConfig *meterConfig;
@property (nonatomic, nullable, strong) ALMrzConfig *mrzConfig;
@property (nonatomic, nullable, strong) ALOcrConfig *ocrConfig;
@property (nonatomic, nullable, strong) ALOdometerConfig *odometerConfig;
/// Sets an initial time period (in milliseconds) where scanned frames are not processed as
/// results.
@property (nonatomic, nullable, strong) NSNumber *startScanDelay;
/// Allows to fine-tune a list of options for plugins.
@property (nonatomic, nullable, copy)   NSArray<ALStartVariable *> *startVariables;
@property (nonatomic, nullable, strong) ALTinConfig *tinConfig;
@property (nonatomic, nullable, strong) ALTireMakeConfig *tireMakeConfig;
@property (nonatomic, nullable, strong) ALTireSizeConfig *tireSizeConfig;
@property (nonatomic, nullable, strong) ALUniversalIDConfig *universalIDConfig;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateConfig *vehicleRegistrationCertificateConfig;
@property (nonatomic, nullable, strong) ALVinConfig *vinConfig;
@end

/// Configuration for scanning barcodes
@interface ALBarcodeConfig : NSObject
/// Set this to filter which barcode formats should be scanned. Setting 'ALL' will enable
/// scanning all supported formats.
@property (nonatomic, copy) NSArray<ALBarcodeFormat *> *barcodeFormats;
/// [DEPRECATED] If this option is set, allows consecutive barcode results of the same
/// barcode when scanning continuously.
@property (nonatomic, nullable, strong) NSNumber *consecutiveEqualResults;
/// Sets whether or not to disable advanced barcode scanning even if the license supports it.
@property (nonatomic, nullable, strong) NSNumber *disableAdvancedBarcode;
/// If this option is set, uses faster image processing for barcode scanning. Note:
/// fastProcessMode is not available during composite scanning.
@property (nonatomic, nullable, strong) NSNumber *fastProcessMode;
/// Setting this to 'true' will enable reading multiple barcodes per frame.
@property (nonatomic, nullable, strong) NSNumber *multiBarcode;
/// If this option is set, barcodes parsed according to the AAMVA standard. This only works
/// for PDF417 codes on driving licenses.
@property (nonatomic, nullable, strong) NSNumber *parseAAMVA;
@end

/// Configuration for scanning commercial Tire IDs
@interface ALCommercialTireIDConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Sets whether the text shall also be scanned upside-down.
@property (nonatomic, nullable, assign) ALUpsideDownMode *upsideDownMode;
/// Sets a regular expression which the commercial tire id text needs to match in order to
/// trigger a scan result.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

/// Configuration for scanning shipping container numbers
@interface ALContainerConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Determines if container numbers shall be scanned horizontally or vertically.
@property (nonatomic, nullable, assign) ALContainerConfigScanMode *scanMode;
/// Sets a regular expression which the scanned text needs to match in order to trigger a
/// scan result.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

/// Configuration for scanning japanese landing permission tickets
@interface ALJapaneseLandingPermissionConfig : NSObject
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionConfigFieldOption *airport;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionConfigFieldOption *dateOfExpiry;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionConfigFieldOption *dateOfIssue;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionConfigFieldOption *duration;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionConfigFieldOption *status;
@end

/// Field option for JLP fields
@interface ALJapaneseLandingPermissionConfigFieldOption : NSObject
/// Set the minConfidence between 0 and 100. Otherwise, it's defaulted.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// The scanOption determines whether a field is considered optional, mandatory, disabled or
/// follows a default behavior. Default behavior is one of the other three that yields the
/// best recall results with all layouts enabled.
@property (nonatomic, nullable, assign) ALMrzScanOption *scanOption;
@end

/// Configuration for scanning license plates
@interface ALLicensePlateConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Specifies a country or location of which license plates shall be scanned.
@property (nonatomic, nullable, assign) ALLicensePlateConfigScanMode *scanMode;
/// Sets a regular expression per country. Expected format: "'country_code':^regex$,
/// 'other_country_code':^other_regex$". The country code needs to be provided in the
/// international vehicle registration code format that is visible on the license plate (for
/// example 'A' for Austria). Note: not available for the scanModes unitedstates and africa.
@property (nonatomic, nullable, copy) NSString *validationRegex;
/// Select if the visual inspection sticker should be scanned. If OPTIONAL, the visual
/// inspection sticker will only be returned if found successfully. If MANDATORY the scan
/// will only return if found successfully. Not available on africa and unitedstates.
@property (nonatomic, nullable, assign) ALVehicleInspectionSticker *vehicleInspectionSticker;
@end

/// Configuration for scanning meters
@interface ALMeterConfig : NSObject
/// Defines the maximum number of read decimal digits for values >=0. Negative values mean
/// all decimal digits are read. Currently implemented only for the
/// "auto_analog_digital_meter" scan mode.
@property (nonatomic, nullable, strong) NSNumber *maxNumDecimalDigits;
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Determines which types of meters to scan.
@property (nonatomic, assign) ALMeterConfigScanMode *scanMode;
/// Sets a regular expression which the scanned text needs to match in order to trigger a
/// scan result.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

/// Configuration for scanning machine-readable zones (MRZ) of passports and other IDs
@interface ALMrzConfig : NSObject
/// The cropAndTransformID determines whether or not the image shall be cropped and
/// transformed.
@property (nonatomic, assign) BOOL isCropAndTransformID;
/// Sets whether the face detection approach is enabled.
@property (nonatomic, nullable, strong) NSNumber *faceDetectionEnabled;
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// The fieldmrzScanOptions configure which text fields shall be captured mandatory, optional
/// or not at all.
@property (nonatomic, nullable, strong) ALMrzFieldScanOptions *mrzFieldScanOptions;
/// The minFieldConfidences configure which fields must reach which confidence thresholds in
/// order to be part of the scan result.
@property (nonatomic, nullable, strong) ALMrzMinFieldConfidences *mrzMinFieldConfidences;
/// When enabling the strictMode, a result is only returned if all the check digits on the
/// scanned document are valid.
@property (nonatomic, assign) BOOL isStrictMode;
@end

/// The fieldmrzScanOptions configure which text fields shall be captured mandatory, optional
/// or not at all.
@interface ALMrzFieldScanOptions : NSObject
@property (nonatomic, nullable, assign) ALMrzScanOption *checkDigitDateOfBirth;
@property (nonatomic, nullable, assign) ALMrzScanOption *checkDigitDateOfExpiry;
@property (nonatomic, nullable, assign) ALMrzScanOption *checkDigitDocumentNumber;
@property (nonatomic, nullable, assign) ALMrzScanOption *checkDigitFinal;
@property (nonatomic, nullable, assign) ALMrzScanOption *checkDigitPersonalNumber;
@property (nonatomic, nullable, assign) ALMrzScanOption *dateOfBirth;
@property (nonatomic, nullable, assign) ALMrzScanOption *dateOfExpiry;
@property (nonatomic, nullable, assign) ALMrzScanOption *documentNumber;
@property (nonatomic, nullable, assign) ALMrzScanOption *documentType;
@property (nonatomic, nullable, assign) ALMrzScanOption *givenNames;
@property (nonatomic, nullable, assign) ALMrzScanOption *issuingCountryCode;
@property (nonatomic, nullable, assign) ALMrzScanOption *mrzString;
@property (nonatomic, nullable, assign) ALMrzScanOption *nationalityCountryCode;
@property (nonatomic, nullable, assign) ALMrzScanOption *optionalData;
@property (nonatomic, nullable, assign) ALMrzScanOption *personalNumber;
@property (nonatomic, nullable, assign) ALMrzScanOption *sex;
@property (nonatomic, nullable, assign) ALMrzScanOption *surname;
@property (nonatomic, nullable, assign) ALMrzScanOption *vizAddress;
@property (nonatomic, nullable, assign) ALMrzScanOption *vizDateOfBirth;
@property (nonatomic, nullable, assign) ALMrzScanOption *vizDateOfExpiry;
@property (nonatomic, nullable, assign) ALMrzScanOption *vizDateOfIssue;
@property (nonatomic, nullable, assign) ALMrzScanOption *vizGivenNames;
@property (nonatomic, nullable, assign) ALMrzScanOption *vizSurname;
@end

/// The minFieldConfidences configure which fields must reach which confidence thresholds in
/// order to be part of the scan result.
@interface ALMrzMinFieldConfidences : NSObject
@property (nonatomic, nullable, strong) NSNumber *checkDigitDateOfBirth;
@property (nonatomic, nullable, strong) NSNumber *checkDigitDateOfExpiry;
@property (nonatomic, nullable, strong) NSNumber *checkDigitDocumentNumber;
@property (nonatomic, nullable, strong) NSNumber *checkDigitFinal;
@property (nonatomic, nullable, strong) NSNumber *checkDigitPersonalNumber;
@property (nonatomic, nullable, strong) NSNumber *dateOfBirth;
@property (nonatomic, nullable, strong) NSNumber *dateOfExpiry;
@property (nonatomic, nullable, strong) NSNumber *documentNumber;
@property (nonatomic, nullable, strong) NSNumber *documentType;
@property (nonatomic, nullable, strong) NSNumber *givenNames;
@property (nonatomic, nullable, strong) NSNumber *issuingCountryCode;
@property (nonatomic, nullable, strong) NSNumber *mrzString;
@property (nonatomic, nullable, strong) NSNumber *nationalityCountryCode;
@property (nonatomic, nullable, strong) NSNumber *optionalData;
@property (nonatomic, nullable, strong) NSNumber *personalNumber;
@property (nonatomic, nullable, strong) NSNumber *sex;
@property (nonatomic, nullable, strong) NSNumber *surname;
@property (nonatomic, nullable, strong) NSNumber *vizAddress;
@property (nonatomic, nullable, strong) NSNumber *vizDateOfBirth;
@property (nonatomic, nullable, strong) NSNumber *vizDateOfExpiry;
@property (nonatomic, nullable, strong) NSNumber *vizDateOfIssue;
@property (nonatomic, nullable, strong) NSNumber *vizGivenNames;
@property (nonatomic, nullable, strong) NSNumber *vizSurname;
@end

/// Configuration for general OCR scanning use-cases
@interface ALOcrConfig : NSObject
/// Sets the number of characters in each text line for 'grid' mode.
@property (nonatomic, nullable, strong) NSNumber *charCountX;
/// Sets the number of text lines for 'grid' mode.
@property (nonatomic, nullable, strong) NSNumber *charCountY;
/// Defines the average horizontal distance between two characters in 'grid' mode, measured
/// in percentage of the characters width.
@property (nonatomic, nullable, strong) NSNumber *charPaddingXFactor;
/// Defines the average vertical distance between two characters in 'grid' mode, measured in
/// percentage of the characters height.
@property (nonatomic, nullable, strong) NSNumber *charPaddingYFactor;
/// Restricts the scanner to a set of characters to be detected.
@property (nonatomic, nullable, copy) NSString *charWhitelist;
/// Sets a custom Anyline script. The file has to be located in the project and point to a
/// path relative from the project root. Please check the official documentation for more
/// details.
@property (nonatomic, nullable, copy) NSString *customCmdFile;
/// Sets a maximum character height (in pixels) to be considered in the scanning process.
@property (nonatomic, nullable, strong) NSNumber *maxCharHeight;
/// Sets a minimum character height (in pixels) to be considered in the scanning process.
@property (nonatomic, nullable, strong) NSNumber *minCharHeight;
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Sets a sharpnes factor (0-100) to rule out blurry images.
@property (nonatomic, nullable, strong) NSNumber *minSharpness;
/// Sets one or more custom Anyline models. The files have to be located in the project and
/// point to a path relative from the project root. If no customCmdFile is set, only a
/// maximum of one model is valid. If a customCmdFile is set, it depends whether or not the
/// customCmdFile requires multiple models or not. Please check the official documentation
/// for more details.
@property (nonatomic, nullable, copy) NSArray<NSString *> *models;
/// Sets whether to scan single-line texts, multi-line texts in a grid-formation or finds
/// text automatically.
@property (nonatomic, nullable, assign) ALOcrConfigScanMode *scanMode;
/// Sets a regular expression which the scanned text needs to match in order to trigger a
/// scan result.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

/// Configuration for scanning odometers
@interface ALOdometerConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.The
/// value has to be between 0 and 100. Defaults to 60.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Sets a regular expression which the scanned text needs to match in order to trigger a
/// scan result.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

/// Describes a start variable for fine-tuning plugins.
@interface ALStartVariable : NSObject
/// The key of the variable.
@property (nonatomic, copy) NSString *key;
/// The value of the variable.
@property (nonatomic, copy) id value;
@end

/// Configuration for scanning TIN numbers
@interface ALTinConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Sets the mode to scan universal TIN numbers ('UNIVERSAL') or TIN numbers of any length
/// starting with DOT ('DOT').
@property (nonatomic, nullable, assign) ALTinConfigScanMode *scanMode;
/// Sets whether the text shall also be scanned upside-down.
@property (nonatomic, nullable, assign) ALUpsideDownMode *upsideDownMode;
/// Sets whether the production date validation is enabled. If it is set to false the scan
/// result is also returned for invalid and missing dates.
@property (nonatomic, nullable, strong) NSNumber *validateProductionDate;
/// Sets a regular expression which the TIN text needs to match in order to trigger a scan
/// result.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

/// Configuration for scanning Tire Makes
@interface ALTireMakeConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Sets whether the text shall also be scanned upside-down.
@property (nonatomic, nullable, assign) ALUpsideDownMode *upsideDownMode;
/// Sets a regular expression which the tire make text needs to match in order to trigger a
/// scan result. E.g. "(Continental|Dunlop)" will only trigger on Continental or Dunlop tires.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

/// Configuration for scanning Tire Size Specifications
@interface ALTireSizeConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Sets whether the text shall also be scanned upside-down.
@property (nonatomic, nullable, assign) ALUpsideDownMode *upsideDownMode;
/// Sets a regular expression which the tire size text needs to match in order to trigger a
/// scan result.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

/// Configuration for scanning all kinds of identification documents
@interface ALUniversalIDConfig : NSObject
/// Specifies the document types to be scanned and optionally further specifies which types
/// of layout are scanned per type.
@property (nonatomic, nullable, strong) ALAllowedLayouts *allowedLayouts;
/// Sets a specific character set.
@property (nonatomic, nullable, assign) ALAlphabet *alphabet;
@property (nonatomic, nullable, strong) ALLayoutDrivingLicense *drivingLicense;
/// Sets whether the face detection approach is enabled.
@property (nonatomic, nullable, strong) NSNumber *faceDetectionEnabled;
@property (nonatomic, nullable, strong) ALLayoutIDFront *theIDFront;
@property (nonatomic, nullable, strong) ALLayoutInsuranceCard *insuranceCard;
@property (nonatomic, nullable, strong) ALLayoutMrz *mrz;
@end

/// Specifies the document types to be scanned and optionally further specifies which types
/// of layout are scanned per type.
@interface ALAllowedLayouts : NSObject
@property (nonatomic, nullable, copy) NSArray<NSString *> *drivingLicense;
@property (nonatomic, nullable, copy) NSArray<NSString *> *theIDFront;
@property (nonatomic, nullable, copy) NSArray<NSString *> *insuranceCard;
@property (nonatomic, nullable, copy) NSArray<NSString *> *mrz;
@end

/// Contains all the supported field scan options for driving licenses.
@interface ALLayoutDrivingLicense : NSObject
@property (nonatomic, nullable, strong) ALUniversalIDField *additionalInformation;
@property (nonatomic, nullable, strong) ALUniversalIDField *additionalInformation1;
@property (nonatomic, nullable, strong) ALUniversalIDField *address;
@property (nonatomic, nullable, strong) ALUniversalIDField *audit;
@property (nonatomic, nullable, strong) ALUniversalIDField *authority;
@property (nonatomic, nullable, strong) ALUniversalIDField *cardNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *categories;
@property (nonatomic, nullable, strong) ALUniversalIDField *conditions;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfIssue;
@property (nonatomic, nullable, strong) ALUniversalIDField *documentDiscriminator;
@property (nonatomic, nullable, strong) ALUniversalIDField *documentNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *duplicate;
@property (nonatomic, nullable, strong) ALUniversalIDField *duration;
@property (nonatomic, nullable, strong) ALUniversalIDField *endorsements;
@property (nonatomic, nullable, strong) ALUniversalIDField *eyes;
@property (nonatomic, nullable, strong) ALUniversalIDField *firstIssued;
@property (nonatomic, nullable, strong) ALUniversalIDField *firstName;
@property (nonatomic, nullable, strong) ALUniversalIDField *fullName;
@property (nonatomic, nullable, strong) ALUniversalIDField *givenNames;
@property (nonatomic, nullable, strong) ALUniversalIDField *hair;
@property (nonatomic, nullable, strong) ALUniversalIDField *height;
@property (nonatomic, nullable, strong) ALUniversalIDField *lastName;
@property (nonatomic, nullable, strong) ALUniversalIDField *licenceNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *licenseClass;
@property (nonatomic, nullable, strong) ALUniversalIDField *licenseNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *name;
@property (nonatomic, nullable, strong) ALUniversalIDField *office;
@property (nonatomic, nullable, strong) ALUniversalIDField *parish;
@property (nonatomic, nullable, strong) ALUniversalIDField *personalNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *placeOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *previousType;
@property (nonatomic, nullable, strong) ALUniversalIDField *restrictions;
@property (nonatomic, nullable, strong) ALUniversalIDField *revoked;
@property (nonatomic, nullable, strong) ALUniversalIDField *sex;
@property (nonatomic, nullable, strong) ALUniversalIDField *surname;
@property (nonatomic, nullable, strong) ALUniversalIDField *type;
@property (nonatomic, nullable, strong) ALUniversalIDField *version;
@property (nonatomic, nullable, strong) ALUniversalIDField *verticalNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *weight;
@end

/// Configures scanning options for ID fields in order to fine-tune the ID scanner.
@interface ALUniversalIDField : NSObject
/// Set the minConfidence which has to be reached in order to trigger a scan result. The
/// value has to be between 0 and 100. Defaults to 60.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// The scanOption determines whether a field is considered optional, mandatory, disabled or
/// follows a default behavior. Default behavior is one of the other three that yields the
/// best recall results with all layouts enabled.
@property (nonatomic, nullable, assign) ALMrzScanOption *scanOption;
@end

/// Contains all the supported field scan options for insurance cards.
@interface ALLayoutInsuranceCard : NSObject
@property (nonatomic, nullable, strong) ALUniversalIDField *authority;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDField *documentNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *firstName;
@property (nonatomic, nullable, strong) ALUniversalIDField *lastName;
@property (nonatomic, nullable, strong) ALUniversalIDField *nationality;
@property (nonatomic, nullable, strong) ALUniversalIDField *personalNumber;
@end

/// Contains all the supported field scan options for MRZ.
@interface ALLayoutMrz : NSObject
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDField *vizAddress;
@property (nonatomic, nullable, strong) ALUniversalIDField *vizDateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *vizDateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDField *vizDateOfIssue;
@property (nonatomic, nullable, strong) ALUniversalIDField *vizGivenNames;
@property (nonatomic, nullable, strong) ALUniversalIDField *vizSurname;
@end

/// Contains all the supported field scan options for ID front cards.
@interface ALLayoutIDFront : NSObject
@property (nonatomic, nullable, strong) ALUniversalIDField *additionalInformation;
@property (nonatomic, nullable, strong) ALUniversalIDField *additionalInformation1;
@property (nonatomic, nullable, strong) ALUniversalIDField *address;
@property (nonatomic, nullable, strong) ALUniversalIDField *age;
@property (nonatomic, nullable, strong) ALUniversalIDField *authority;
@property (nonatomic, nullable, strong) ALUniversalIDField *cardAccessNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *citizenship;
@property (nonatomic, nullable, strong) ALUniversalIDField *cityNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfIssue;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfRegistration;
@property (nonatomic, nullable, strong) ALUniversalIDField *divisionNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *documentNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *familyName;
@property (nonatomic, nullable, strong) ALUniversalIDField *fathersName;
@property (nonatomic, nullable, strong) ALUniversalIDField *firstName;
@property (nonatomic, nullable, strong) ALUniversalIDField *folio;
@property (nonatomic, nullable, strong) ALUniversalIDField *fullName;
@property (nonatomic, nullable, strong) ALUniversalIDField *givenNames;
@property (nonatomic, nullable, strong) ALUniversalIDField *height;
@property (nonatomic, nullable, strong) ALUniversalIDField *lastName;
@property (nonatomic, nullable, strong) ALUniversalIDField *licenseClass;
@property (nonatomic, nullable, strong) ALUniversalIDField *licenseType;
@property (nonatomic, nullable, strong) ALUniversalIDField *municipalityNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *nationalID;
@property (nonatomic, nullable, strong) ALUniversalIDField *nationality;
@property (nonatomic, nullable, strong) ALUniversalIDField *parentsGivenName;
@property (nonatomic, nullable, strong) ALUniversalIDField *personalNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *placeAndDateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *placeOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *sex;
@property (nonatomic, nullable, strong) ALUniversalIDField *stateNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *supportNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *surname;
@property (nonatomic, nullable, strong) ALUniversalIDField *voterID;
@end

/// Configuration for scanning Vehicle Registration Certificates
@interface ALVehicleRegistrationCertificateConfig : NSObject
@property (nonatomic, nullable, strong) ALLayoutVehicleRegistrationCertificate *vehicleRegistrationCertificate;
@end

/// Contains all the supported field scan options for vehicle registration certificates.
@interface ALLayoutVehicleRegistrationCertificate : NSObject
/// The Address Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *address;
/// The Brand Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *brand;
/// The Displacement Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *displacement;
/// The DocumentNumber Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *documentNumber;
/// The FirstIssued Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *firstIssued;
/// The FirstName Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *firstName;
/// The LastName Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *lastName;
/// The LicensePlate Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *licensePlate;
/// The ManufacturerCode Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *manufacturerCode;
/// The Tire Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *tire;
/// The VehicleIdentificationNumber Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *vehicleIdentificationNumber;
/// The VehicleType Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *vehicleType;
/// The VehicleTypeCode Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *vehicleTypeCode;
@end

/// The Address Field
///
/// Configures scanning options per field
///
/// The Brand Field
///
/// The Displacement Field
///
/// The DocumentNumber Field
///
/// The FirstIssued Field
///
/// The FirstName Field
///
/// The LastName Field
///
/// The LicensePlate Field
///
/// The ManufacturerCode Field
///
/// The Tire Field
///
/// The VehicleIdentificationNumber Field
///
/// The VehicleType Field
///
/// The VehicleTypeCode Field
@interface ALVehicleRegistrationCertificateField : NSObject
/// Set the minConfidence between 0 and 100. Otherwise, it's defaulted.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// The scanOption determines whether a field is considered optional, mandatory, disabled or
/// follows a default behavior. Default behavior is one of the other three that yields the
/// best recall results with all layouts enabled.
@property (nonatomic, nullable, assign) ALMrzScanOption *scanOption;
@end

/// Configuration for scanning vehicle identification numbers (VIN)
@interface ALVinConfig : NSObject
/// Restricts the scanner to a set of characters to be detected.
@property (nonatomic, nullable, copy) NSString *charWhitelist;
/// Setting this to 'true' will enforce checking the check digit and only return results if
/// it is correct.
@property (nonatomic, nullable, strong) NSNumber *validateCheckDigit;
/// Sets a regular expression which the scanned text needs to match in order to trigger a
/// scan result.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

/// Schema for SDK ScanFeedback Configuration
@interface ALScanFeedbackConfig : NSObject
/// The animation style of the feedback.
@property (nonatomic, nullable, assign) ALScanFeedbackConfigAnimation *animation;
/// The duration of the animation in milliseconds.
@property (nonatomic, nullable, strong) NSNumber *animationDuration;
/// If true, make a beep sound when a result is found.
@property (nonatomic, nullable, strong) NSNumber *beepOnResult;
/// If true, flash the view when a result is found.
@property (nonatomic, nullable, strong) NSNumber *blinkAnimationOnResult;
/// The corner radius of the visual feedback.
@property (nonatomic, nullable, strong) NSNumber *cornerRadius;
/// The fill color.
@property (nonatomic, nullable, copy) NSString *fillColor;
/// The timeout to redraw the visual feedback in milliseconds.
@property (nonatomic, nullable, strong) NSNumber *redrawTimeout;
/// The stroke color.
@property (nonatomic, nullable, copy) NSString *strokeColor;
/// The stroke width.
@property (nonatomic, nullable, strong) NSNumber *strokeWidth;
/// The style of the feedback.
@property (nonatomic, nullable, assign) ALStyle *style;
/// If true, vibrate the device when a result is found.
@property (nonatomic, nullable, strong) NSNumber *vibrateOnResult;
@end

/// General configuration for UI Feedback elements
@interface ALUIFeedbackConfig : NSObject
/// Elements inside UIFeedbackConfig.
@property (nonatomic, nullable, copy) NSArray<ALUIFeedbackElementConfig *> *elements;
/// Preset definitions inside UIFeedbackConfig.
@property (nonatomic, nullable, copy) NSArray<ALUIFeedbackPresetDefinitionConfig *> *presetDefinitions;
/// Allows to use presets.
@property (nonatomic, nullable, copy) NSArray<ALUIFeedbackPresetConfig *> *presets;
@end

/// Configuration for uiFeedback element
@interface ALUIFeedbackElementConfig : NSObject
/// Sets whether the view is clickable.
@property (nonatomic, nullable, strong) NSNumber *clickable;
@property (nonatomic, nullable, assign) ALContentTypeEnum *contentType;
@property (nonatomic, nullable, strong) ALUIFeedbackElementAttributesConfig *defaultAttributes;
@property (nonatomic, nullable, strong) ALUIFeedbackElementContentConfig *defaultContent;
/// Sets the id of the element.
@property (nonatomic, nullable, copy)   NSString *identifier;
@property (nonatomic, nullable, strong) ALOverlayConfig *overlay;
/// Allows to use element presets.
@property (nonatomic, nullable, copy) NSArray<ALUIFeedbackPresetConfig *> *presets;
/// Sets a tag for the element.
@property (nonatomic, nullable, copy)   NSString *tag;
@property (nonatomic, nullable, strong) ALUIFeedbackElementTriggerConfig *trigger;
@end

/// Configuration attributes for UI Feedback view elements
@interface ALUIFeedbackElementAttributesConfig : NSObject
/// Sets the background color.
@property (nonatomic, nullable, copy) NSString *backgroundColor;
/// Sets the image scale type.
@property (nonatomic, nullable, assign) ALImageScaleType *imageScaleType;
/// Sets the text alignment.
@property (nonatomic, nullable, assign) ALTextAlignment *textAlignment;
/// Sets the text color.
@property (nonatomic, nullable, copy) NSString *textColor;
@end

/// Configuration for UI Feedback content
@interface ALUIFeedbackElementContentConfig : NSObject
/// Sets the content of the element.
@property (nonatomic, nullable, copy) NSString *contentValue;
/// Sets the duration of the element.
@property (nonatomic, nullable, strong) NSNumber *durationMills;
/// Sets the priority of the element.
@property (nonatomic, nullable, strong) NSNumber *priorityLevel;
@end

/// Configuration for UI Feedback overlays
@interface ALOverlayConfig : NSObject
/// Sets the anchor of the overlay.
@property (nonatomic, nullable, assign) ALOverlayAnchorConfig *anchor;
/// Sets the offset dimension of the overlay.
@property (nonatomic, nullable, strong) ALOverlayDimensionConfig *offsetDimension;
/// Allows to use overlay presets.
@property (nonatomic, nullable, copy) NSArray<ALUIFeedbackPresetConfig *> *presets;
/// Sets the size dimension of the overlay.
@property (nonatomic, nullable, strong) ALOverlayDimensionConfig *sizeDimension;
/// Sets the source of the overlay.
@property (nonatomic, nullable, assign) ALOverlaySource *source;
@end

/// Sets the offset dimension of the overlay.
///
/// Sets the dimension of the overlay.
///
/// Sets the size dimension of the overlay.
@interface ALOverlayDimensionConfig : NSObject
/// Sets the scale for x axis of the overlay.
@property (nonatomic, nullable, strong) ALOverlayScaleConfig *scaleX;
/// Sets the scale for y axis of the overlay.
@property (nonatomic, nullable, strong) ALOverlayScaleConfig *scaleY;
@end

/// Sets the scale for x axis of the overlay.
///
/// Configuration for UI Feedback overlays
///
/// Sets the scale for y axis of the overlay.
@interface ALOverlayScaleConfig : NSObject
/// Sets the scale type of the overlay.
@property (nonatomic, nullable, assign) ALOverlayScaleTypeConfig *scaleType;
/// Sets the scale value of the overlay.
@property (nonatomic, nullable, strong) NSNumber *scaleValue;
@end

/// Configuration for uiFeedback preset.
@interface ALUIFeedbackPresetConfig : NSObject
/// Attributes inside preset.
@property (nonatomic, nullable, copy) NSArray<ALUIFeedbackPresetAttributeConfig *> *presetAttributes;
/// Name of the preset.
@property (nonatomic, nullable, copy) NSString *presetName;
@end

/// Configuration for uiFeedback preset attribute.
@interface ALUIFeedbackPresetAttributeConfig : NSObject
/// Name of the attribute declared in the preset definition.
@property (nonatomic, nullable, copy) NSString *attributeName;
/// Sets the value of the attribute.
@property (nonatomic, nullable, copy) NSString *attributeValue;
@end

/// Trigger configuration for UI Feedback
@interface ALUIFeedbackElementTriggerConfig : NSObject
@property (nonatomic, nullable, copy) NSArray<ALUIFeedbackPresetConfig *> *presets;
/// Allows to watch runSkipped events.
@property (nonatomic, nullable, copy) NSArray<ALUIFeedbackElementTriggerWhenRunSkippedConfig *> *runSkipped;
/// Allows to watch scanInfo events.
@property (nonatomic, nullable, copy) NSArray<ALUIFeedbackElementTriggerWhenScanInfoConfig *> *scanInfo;
@end

/// Configuration for triggering UI Feedback on RunSkipped events
@interface ALUIFeedbackElementTriggerWhenRunSkippedConfig : NSObject
@property (nonatomic, nullable, strong) ALRunSkippedWhen *when;
@end

/// Configuration for triggering UI Feedback on RunSkipped events
@interface ALRunSkippedWhen : NSObject
@property (nonatomic, nullable, strong) ALUIFeedbackElementAttributesConfig *applyAttributesInstead;
@property (nonatomic, nullable, strong) ALUIFeedbackElementContentConfig *applyContentInstead;
/// Sets whether the trigger must apply defaultAttributes.
@property (nonatomic, nullable, strong) NSNumber *applyDefaultAttributes;
/// Sets whether the trigger must apply defaultContent.
@property (nonatomic, nullable, strong) NSNumber *applyDefaultContent;
/// Sets the runSkipped code to be watched.
@property (nonatomic, nullable, strong) NSNumber *codeEquals;
@end

/// Configuration for triggering UI Feedback on ScanInfo events
@interface ALUIFeedbackElementTriggerWhenScanInfoConfig : NSObject
@property (nonatomic, nullable, strong) ALScanInfoWhen *when;
@end

/// Configuration for triggering UI Feedback on ScanInfo events
@interface ALScanInfoWhen : NSObject
@property (nonatomic, nullable, strong) ALUIFeedbackElementAttributesConfig *applyAttributesInstead;
@property (nonatomic, nullable, strong) ALUIFeedbackElementContentConfig *applyContentInstead;
/// Sets whether the trigger must apply defaultAttributes.
@property (nonatomic, nullable, strong) NSNumber *applyDefaultAttributes;
/// Sets whether the trigger must apply defaultContent.
@property (nonatomic, nullable, strong) NSNumber *applyDefaultContent;
/// Sets the ScanInfo variable name to be watched.
@property (nonatomic, nullable, copy) NSString *varNameEquals;
/// Sets the ScanInfo variable value to be watched.
@property (nonatomic, nullable, copy) NSString *varValueEquals;
@end

/// Configuration for uiFeedback preset definition.
@interface ALUIFeedbackPresetDefinitionConfig : NSObject
/// Attributes inside preset definition.
@property (nonatomic, nullable, copy) NSArray<ALUIFeedbackPresetDefinitionAttributeConfig *> *attributes;
/// Sets the name of the preset definition.
@property (nonatomic, copy) NSString *name;
/// Configuration for uiFeedback preset content definition.
@property (nonatomic, nullable, strong) ALUIFeedbackPresetContentConfig *presetContent;
/// Sets the preset definition type.
@property (nonatomic, assign) ALType *type;
@end

/// Configuration for uiFeedback preset definition attribute.
@interface ALUIFeedbackPresetDefinitionAttributeConfig : NSObject
/// Sets the name of the element of the attribute.
@property (nonatomic, nullable, copy) NSString *elementName;
/// Sets the preset definition attribute element type.
@property (nonatomic, nullable, assign) ALElementTypeEnum *elementType;
/// Sets the name of the attribute.
@property (nonatomic, nullable, copy) NSString *name;
@end

/// Configuration for uiFeedback preset content definition.
@interface ALUIFeedbackPresetContentConfig : NSObject
@property (nonatomic, nullable, strong) ALUIFeedbackElementConfig *element;
@property (nonatomic, nullable, copy)   NSArray<ALUIFeedbackElementConfig *> *elements;
@property (nonatomic, nullable, strong) ALOverlayConfig *overlay;
@property (nonatomic, nullable, copy)   NSArray<ALUIFeedbackPresetConfig *> *presets;
@property (nonatomic, nullable, strong) ALUIFeedbackElementTriggerConfig *trigger;
@end

NS_ASSUME_NONNULL_END
