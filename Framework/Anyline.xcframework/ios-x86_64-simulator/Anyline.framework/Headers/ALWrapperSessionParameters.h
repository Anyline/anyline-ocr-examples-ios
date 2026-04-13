// To parse this JSON:
//
//   NSError *error;
//   ALWrapperSessionParameters *wrapperSessionParameters = [ALWrapperSessionParameters fromJSON:json encoding:NSUTF8Encoding error:&error];

#import <Foundation/Foundation.h>

@class ALAndroidScanViewAttributesConfig;
@class ALExportedScanResult;
@class ALExportedScanResultImageContainer;
@class ALExportedScanResultImageParameters;
@class ALFillType;
@class ALPositionXAlignment;
@class ALPositionYAlignment;
@class ALScanViewInitializationParameters;
@class ALViewPluginType;
@class ALWrapperSessionExportCachedEventsResponse;
@class ALWrapperSessionExportCachedEventsResponseFail;
@class ALWrapperSessionExportCachedEventsResponseStatus;
@class ALWrapperSessionExportCachedEventsResponseSucceed;
@class ALWrapperSessionParameters;
@class ALWrapperSessionScanResponse;
@class ALWrapperSessionScanResponseAbort;
@class ALWrapperSessionScanResponseFail;
@class ALWrapperSessionScanResponseStatus;
@class ALWrapperSessionScanResponseSucceed;
@class ALWrapperSessionScanResultCallbackConfig;
@class ALWrapperSessionScanResultCleanStrategyConfig;
@class ALWrapperSessionScanResultConfig;
@class ALWrapperSessionScanResultExtraInfo;
@class ALWrapperSessionScanResultsResponse;
@class ALWrapperSessionScanStartPlatformOptions;
@class ALWrapperSessionScanStartRequest;
@class ALWrapperSessionScanStopRequest;
@class ALWrapperSessionScanViewConfigOptionDefaultOrientation;
@class ALWrapperSessionScanViewConfigOptionDoneButton;
@class ALWrapperSessionScanViewConfigOptionElementAlignment;
@class ALWrapperSessionScanViewConfigOptionElementOffset;
@class ALWrapperSessionScanViewConfigOptionLabel;
@class ALWrapperSessionScanViewConfigOptionRotateButton;
@class ALWrapperSessionScanViewConfigOptions;
@class ALWrapperSessionScanViewConfigOptionSegmentConfig;
@class ALWrapperSessionSDKInitializationCacheConfig;
@class ALWrapperSessionSDKInitializationRequest;
@class ALWrapperSessionSDKInitializationResponse;
@class ALWrapperSessionSDKInitializationResponseInitialized;
@class ALWrapperSessionSDKInitializationResponseNotInitialized;
@class ALWrapperSessionUCRReportRequest;
@class ALWrapperSessionUCRReportResponse;
@class ALWrapperSessionUCRReportResponseFail;
@class ALWrapperSessionUCRReportResponseStatus;
@class ALWrapperSessionUCRReportResponseSucceed;

NS_ASSUME_NONNULL_BEGIN


#pragma mark - Boxed enums

/// The final status of the export operation.
///
/// Final status of a cached events export operation.
@interface ALWrapperSessionExportCachedEventsResponseStatus : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALWrapperSessionExportCachedEventsResponseStatus *)exportFailed;
+ (ALWrapperSessionExportCachedEventsResponseStatus *)exportSucceeded;
@end

/// Controls when previously generated result files are removed from storage.
@interface ALWrapperSessionScanResultCleanStrategyConfig : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALWrapperSessionScanResultCleanStrategyConfig *)cleanFolderOnStartScanning;
+ (ALWrapperSessionScanResultCleanStrategyConfig *)deleteResultFilesOnFinishScanning;
+ (ALWrapperSessionScanResultCleanStrategyConfig *)keepResultFiles;
@end

/// The final status of the scan session.
///
/// Final status of a scan session.
@interface ALWrapperSessionScanResponseStatus : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALWrapperSessionScanResponseStatus *)scanAborted;
+ (ALWrapperSessionScanResponseStatus *)scanFailed;
+ (ALWrapperSessionScanResponseStatus *)scanSucceeded;
@end

/// The type of the source ViewPlugin that generated result(s).
@interface ALViewPluginType : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALViewPluginType *)viewPlugin;
+ (ALViewPluginType *)viewPluginComposite;
@end

/// Initial screen orientation when the scan view is presented.
///
/// Initial screen orientation when scanning starts.
@interface ALWrapperSessionScanViewConfigOptionDefaultOrientation : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALWrapperSessionScanViewConfigOptionDefaultOrientation *)landscape;
+ (ALWrapperSessionScanViewConfigOptionDefaultOrientation *)portrait;
@end

/// The preset used for width fill.
@interface ALFillType : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALFillType *)fullwidth;
+ (ALFillType *)rect;
@end

/// The preset locations for the button along the x-axis.
@interface ALPositionXAlignment : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALPositionXAlignment *)center;
+ (ALPositionXAlignment *)left;
+ (ALPositionXAlignment *)right;
@end

/// The preset locations for the button along the y-axis.
@interface ALPositionYAlignment : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALPositionYAlignment *)bottom;
+ (ALPositionYAlignment *)center;
+ (ALPositionYAlignment *)top;
@end

/// Corner of the screen where the rotate button is positioned.
///
/// Screen corner where the UI element will be positioned. Element will align to the
/// specified corner before applying any offset.
@interface ALWrapperSessionScanViewConfigOptionElementAlignment : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALWrapperSessionScanViewConfigOptionElementAlignment *)bottomLeft;
+ (ALWrapperSessionScanViewConfigOptionElementAlignment *)bottomRight;
+ (ALWrapperSessionScanViewConfigOptionElementAlignment *)topLeft;
+ (ALWrapperSessionScanViewConfigOptionElementAlignment *)topRight;
@end

/// The final status of the UCR report submission.
///
/// Final status of a UCR report submission.
@interface ALWrapperSessionUCRReportResponseStatus : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALWrapperSessionUCRReportResponseStatus *)ucrReportFailed;
+ (ALWrapperSessionUCRReportResponseStatus *)ucrReportSucceeded;
@end

#pragma mark - Object interfaces

/// Top-level schema encompassing all request and response types exchanged between the
/// wrapper plugin and the Anyline SDK during a scanning session.
@interface ALWrapperSessionParameters : NSObject
@property (nonatomic, nullable, strong) ALWrapperSessionExportCachedEventsResponse *exportCachedEventsResponse;
@property (nonatomic, nullable, strong) ALWrapperSessionScanResponse *scanResponse;
@property (nonatomic, nullable, strong) ALWrapperSessionScanResultsResponse *scanResultsResponse;
@property (nonatomic, nullable, strong) ALWrapperSessionScanStartRequest *scanStartRequest;
@property (nonatomic, nullable, strong) ALWrapperSessionScanStopRequest *scanStopRequest;
@property (nonatomic, nullable, strong) ALWrapperSessionScanViewConfigOptions *scanViewConfigOptions;
@property (nonatomic, nullable, strong) ALWrapperSessionSDKInitializationRequest *sdkInitializationRequest;
@property (nonatomic, nullable, strong) ALWrapperSessionSDKInitializationResponse *sdkInitializationResponse;
@property (nonatomic, nullable, strong) ALWrapperSessionUCRReportRequest *ucrReportRequest;
@property (nonatomic, nullable, strong) ALWrapperSessionUCRReportResponse *ucrReportResponse;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

/// Response from cached events export operation. Includes either failInfo (if export failed)
/// or succeedInfo (if successful), corresponding to the status field.
@interface ALWrapperSessionExportCachedEventsResponse : NSObject
/// Populated when status is exportFailed. Contains the error that caused the failure.
@property (nonatomic, nullable, strong) ALWrapperSessionExportCachedEventsResponseFail *failInfo;
/// The final status of the export operation.
@property (nonatomic, nullable, assign) ALWrapperSessionExportCachedEventsResponseStatus *status;
/// Populated when status is exportSucceeded. Contains the path to the exported file.
@property (nonatomic, nullable, strong) ALWrapperSessionExportCachedEventsResponseSucceed *succeedInfo;
@end

/// Populated when status is exportFailed. Contains the error that caused the failure.
///
/// Details about a failed cached events export.
@interface ALWrapperSessionExportCachedEventsResponseFail : NSObject
/// The last error received while exporting cached events.
@property (nonatomic, nullable, copy) NSString *lastError;
@end

/// Populated when status is exportSucceeded. Contains the path to the exported file.
///
/// Details about a successful cached events export.
@interface ALWrapperSessionExportCachedEventsResponseSucceed : NSObject
/// Path to the generated file containing the exported cached events.
@property (nonatomic, nullable, copy) NSString *exportedFile;
@end

/// Response indicating scan session completion status. Includes exactly one info object
/// (failInfo, abortInfo, or succeedInfo) corresponding to the status field value.
@interface ALWrapperSessionScanResponse : NSObject
/// Populated when status is scanAborted. Contains the reason for the abort.
@property (nonatomic, nullable, strong) ALWrapperSessionScanResponseAbort *abortInfo;
/// Populated when status is scanFailed. Contains the error that caused the failure.
@property (nonatomic, nullable, strong) ALWrapperSessionScanResponseFail *failInfo;
/// The result configuration that was active during the completed scan session.
@property (nonatomic, nullable, strong) ALWrapperSessionScanResultConfig *scanResultConfig;
/// The final status of the scan session.
@property (nonatomic, nullable, assign) ALWrapperSessionScanResponseStatus *status;
/// Populated when status is scanSucceeded. Contains an optional completion message.
@property (nonatomic, nullable, strong) ALWrapperSessionScanResponseSucceed *succeedInfo;
@end

/// Populated when status is scanAborted. Contains the reason for the abort.
///
/// Details about an aborted scan session.
@interface ALWrapperSessionScanResponseAbort : NSObject
/// Optional message provided when the scan session was aborted.
@property (nonatomic, nullable, copy) NSString *message;
@end

/// Populated when status is scanFailed. Contains the error that caused the failure.
///
/// Details about a failed scan session.
@interface ALWrapperSessionScanResponseFail : NSObject
/// The last error received while trying to scan.
@property (nonatomic, nullable, copy) NSString *lastError;
@end

/// The result configuration that was active during the completed scan session.
///
/// Configuration for how scan results are returned and stored during a scanning session.
///
/// The result configuration that was active when these results were produced.
///
/// Configuration for how scan results are returned and stored during the session.
@interface ALWrapperSessionScanResultConfig : NSObject
/// Deprecated. Used only by the legacy plugin. Custom callback method names for scan result
/// and UI element click events.
@property (nonatomic, nullable, strong) ALWrapperSessionScanResultCallbackConfig *callbackConfig;
/// Controls when previously generated result files are removed from storage.
@property (nonatomic, nullable, assign) ALWrapperSessionScanResultCleanStrategyConfig *cleanStrategy;
/// See ALExportedScanResultImageContainer.h
@property (nonatomic, nullable, copy) NSDictionary<NSString *, id> *imageContainer;
/// See ALExportedScanResultImageParameters.h
@property (nonatomic, nullable, copy) NSDictionary<NSString *, id> *imageParameters;
@end

/// Deprecated. Used only by the legacy plugin. Custom callback method names for scan result
/// and UI element click events.
///
/// Deprecated. Used only by the legacy plugin. Configuration for callback method names
/// invoked during scanning events.
@interface ALWrapperSessionScanResultCallbackConfig : NSObject
/// Name of the callback method to invoke when scan results are available. Method will
/// receive a list of ExportedScanResult as parameter.
@property (nonatomic, nullable, copy) NSString *onResultEventName;
/// Name of the callback method to invoke when user taps a UI feedback element during
/// scanning. Method receives a UIFeedbackElementConfig as parameter.
@property (nonatomic, nullable, copy) NSString *onUIElementClickedEventName;
@end

/// Populated when status is scanSucceeded. Contains an optional completion message.
///
/// Details about a successfully completed scan session.
@interface ALWrapperSessionScanResponseSucceed : NSObject
/// Optional informational message from the completed scan session.
@property (nonatomic, nullable, copy) NSString *message;
@end

/// Information about the results collected during the scanning process.
@interface ALWrapperSessionScanResultsResponse : NSObject
/// List of scan results produced in this scanning event, one per detected item.
@property (nonatomic, nullable, copy) NSArray<NSDictionary<NSString *, id> *> *exportedScanResults;
/// The result configuration that was active when these results were produced.
@property (nonatomic, nullable, strong) ALWrapperSessionScanResultConfig *scanResultConfig;
/// Additional metadata about the source plugin that produced these results.
@property (nonatomic, nullable, strong) ALWrapperSessionScanResultExtraInfo *scanResultExtraInfo;
@end

/// Additional metadata about the source plugin that produced these results.
///
/// Extra information returned by a scanning session.
@interface ALWrapperSessionScanResultExtraInfo : NSObject
/// The type of the source ViewPlugin that generated result(s).
@property (nonatomic, nullable, assign) ALViewPluginType *viewPluginType;
@end

/// Request to start a scanning session. Requires both scanViewConfigContentString (defining
/// what to scan) and scanResultConfig (defining how to handle results). Optional
/// scanViewInitializationParameters for workflow correlation.
@interface ALWrapperSessionScanStartRequest : NSObject
/// Platform-specific options applied when starting a scan session.
@property (nonatomic, nullable, strong) ALWrapperSessionScanStartPlatformOptions *platformOptions;
/// Configuration for how scan results are returned and stored during the session.
@property (nonatomic, strong) ALWrapperSessionScanResultConfig *scanResultConfig;
/// ScanViewConfig JSON string defining the scanner configuration.
@property (nonatomic, copy) NSString *scanViewConfigContentString;
/// Path relative to the assets folder used to resolve ScanViewConfig JSON files when a
/// SegmentControl references them by filename.
@property (nonatomic, nullable, copy) NSString *scanViewConfigPath;
/// See ALScanViewInitializationParameters.h
@property (nonatomic, nullable, copy) NSDictionary<NSString *, id> *scanViewInitializationParameters;
@end

/// Platform-specific options applied when starting a scan session.
@interface ALWrapperSessionScanStartPlatformOptions : NSObject
/// Android-specific ScanView attributes for layout and behavior customization.
@property (nonatomic, nullable, strong) ALAndroidScanViewAttributesConfig *androidScanViewAttributes;
@end

/// Android-specific ScanView attributes for layout and behavior customization.
///
/// Android ScanView attributes config
@interface ALAndroidScanViewAttributesConfig : NSObject
/// Enable or disable camera permission handling from ScanView loading process.
@property (nonatomic, nullable, strong) NSNumber *enableCameraPermissionHandling;
/// Enable or disable usage of CameraX API instead of Camera1 API. Default is true.
@property (nonatomic, nullable, strong) NSNumber *useCameraX;
@end

/// Request to stop the current scanning session with optional message explaining the reason
/// for termination.
@interface ALWrapperSessionScanStopRequest : NSObject
/// Optional message describing the reason for stopping the scan session.
@property (nonatomic, nullable, copy) NSString *message;
@end

/// UI configuration options for the scan view, controlling optional controls, orientation,
/// and overlays.
@interface ALWrapperSessionScanViewConfigOptions : NSObject
/// Initial screen orientation when the scan view is presented.
@property (nonatomic, nullable, assign) ALWrapperSessionScanViewConfigOptionDefaultOrientation *defaultOrientation;
/// Deprecated. iOS only. Button that dismisses the scan view. Use toolbarTitle instead.
@property (nonatomic, nullable, strong) ALWrapperSessionScanViewConfigOptionDoneButton *doneButtonConfig;
/// Deprecated. iOS only. Static text label on the scan view. Use the Simple Instruction
/// Label UI Feedback preset instead.
@property (nonatomic, nullable, strong) ALWrapperSessionScanViewConfigOptionLabel *label;
/// Optional button that lets users toggle between portrait and landscape orientations.
@property (nonatomic, nullable, strong) ALWrapperSessionScanViewConfigOptionRotateButton *rotateButton;
/// Optional multi-mode segment control for switching between scanning configurations.
@property (nonatomic, nullable, strong) ALWrapperSessionScanViewConfigOptionSegmentConfig *segmentConfig;
/// Title shown on the toolbar with a back button. Fullscreen scanning only; ignored when
/// using a ContainerView.
@property (nonatomic, nullable, copy) NSString *toolbarTitle;
@end

/// Deprecated. iOS only. Button that dismisses the scan view. Use toolbarTitle instead.
///
/// Deprecated. iOS only. A button that dismisses the scan view screen when pressed. Use
/// toolbarTitle instead.
@interface ALWrapperSessionScanViewConfigOptionDoneButton : NSObject
/// A color, denoted by a hex string of the button background. The default is empty (clear
/// color).
@property (nonatomic, nullable, copy) NSString *backgroundColor;
/// A Float value indicating the corner rounding of the Done button.
@property (nonatomic, nullable, strong) NSNumber *cornerRadius;
/// The preset used for width fill.
@property (nonatomic, nullable, assign) ALFillType *fillType;
/// The name of the font (note: the font must be available for the device).
@property (nonatomic, nullable, copy) NSString *fontName;
/// Button title font size in points (typically 8-72).
@property (nonatomic, nullable, strong) NSNumber *fontSize;
@property (nonatomic, nullable, strong) NSNumber *offsetX;
@property (nonatomic, nullable, strong) NSNumber *offsetY;
/// The preset locations for the button along the x-axis.
@property (nonatomic, nullable, assign) ALPositionXAlignment *positionXAlignment;
/// The preset locations for the button along the y-axis.
@property (nonatomic, nullable, assign) ALPositionYAlignment *positionYAlignment;
/// A color, denoted by a hex string of the button title.
@property (nonatomic, nullable, copy) NSString *textColor;
/// A color, denoted by a hex string used by the button title when pressed.
@property (nonatomic, nullable, copy) NSString *textColorHighlighted;
/// The text displayed for the button.
@property (nonatomic, nullable, copy) NSString *title;
@end

/// Deprecated. iOS only. Static text label on the scan view. Use the Simple Instruction
/// Label UI Feedback preset instead.
///
/// Deprecated. iOS only. A static text label displayed on the scan view. Use the Simple
/// Instruction Label UI Feedback preset instead.
@interface ALWrapperSessionScanViewConfigOptionLabel : NSObject
/// Hex color string for the label text.
@property (nonatomic, nullable, copy)   NSString *color;
@property (nonatomic, nullable, strong) NSNumber *offsetX;
@property (nonatomic, nullable, strong) NSNumber *offsetY;
/// The font size of the label.
@property (nonatomic, nullable, strong) NSNumber *size;
/// The text to display.
@property (nonatomic, nullable, copy) NSString *text;
@end

/// Optional button that lets users toggle between portrait and landscape orientations.
///
/// Button that toggles between portrait and landscape orientations when tapped. Positioned
/// according to alignment and optional offset settings.
@interface ALWrapperSessionScanViewConfigOptionRotateButton : NSObject
/// Corner of the screen where the rotate button is positioned.
@property (nonatomic, assign) ALWrapperSessionScanViewConfigOptionElementAlignment *alignment;
/// Optional pixel offset from the aligned corner position.
@property (nonatomic, nullable, strong) ALWrapperSessionScanViewConfigOptionElementOffset *offset;
@end

/// Optional pixel offset from the aligned corner position.
///
/// Optional pixel offset from the element's aligned position. Use positive/negative values
/// to fine-tune positioning.
@interface ALWrapperSessionScanViewConfigOptionElementOffset : NSObject
/// Horizontal offset in pixels. Positive values move the element right, negative values move
/// it left.
@property (nonatomic, nullable, strong) NSNumber *x;
/// Vertical offset in pixels. Positive values move the element down, negative values move it
/// up.
@property (nonatomic, nullable, strong) NSNumber *y;
@end

/// Optional multi-mode segment control for switching between scanning configurations.
///
/// Multi-mode segment control allowing users to switch between different scanning
/// configurations (e.g., MRZ, Barcode, License Plate modes). Requires equal numbers of
/// titles and viewConfigs.
@interface ALWrapperSessionScanViewConfigOptionSegmentConfig : NSObject
@property (nonatomic, nullable, strong) NSNumber *offsetX;
@property (nonatomic, nullable, strong) NSNumber *offsetY;
/// Hex color code (e.g., 'FF0000' for red) applied to the selected segment and control
/// tinting.
@property (nonatomic, nullable, copy) NSString *tintColor;
/// Zero-based index indicating which segment should be initially selected. Must be within
/// the bounds of the titles array.
@property (nonatomic, nullable, strong) NSNumber *titleIndex;
/// Array of display names for each scanning mode shown to users in the segment control.
@property (nonatomic, nullable, copy) NSArray<NSString *> *titles;
/// Array of ScanView configuration filenames located in the assets folder. Each file defines
/// a complete scanning mode configuration.
@property (nonatomic, nullable, copy) NSArray<NSString *> *viewConfigs;
@end

/// General information to be used for SDK initialization.
@interface ALWrapperSessionSDKInitializationRequest : NSObject
/// Root folder path the SDK uses when resolving asset files. Leave empty to use the default
/// asset location.
@property (nonatomic, nullable, copy) NSString *assetPathPrefix;
/// Optional cache settings applied during initialization.
@property (nonatomic, nullable, strong) ALWrapperSessionSDKInitializationCacheConfig *cacheConfig;
/// Anyline license key to be used for SDK initialization.
@property (nonatomic, copy) NSString *licenseKey;
@end

/// Optional cache settings applied during initialization.
///
/// Cache configuration to be applied on SDK initialization.
@interface ALWrapperSessionSDKInitializationCacheConfig : NSObject
/// Whether offline license caching is enabled.
@property (nonatomic, nullable, strong) NSNumber *offlineLicenseCachingEnabled;
@end

/// Response containing SDK initialization result. Must include either failInfo (if
/// initialization failed) or succeedInfo (if successful). The 'initialized' boolean
/// indicates the overall status.
@interface ALWrapperSessionSDKInitializationResponse : NSObject
/// Populated when initialized is false. Contains the error that prevented SDK initialization.
@property (nonatomic, nullable, strong) ALWrapperSessionSDKInitializationResponseNotInitialized *failInfo;
/// True if SDK initialization succeeded and scanning is available, false if initialization
/// failed.
@property (nonatomic, nullable, strong) NSNumber *initialized;
/// Populated when initialized is true. Contains license details from the successful
/// initialization.
@property (nonatomic, nullable, strong) ALWrapperSessionSDKInitializationResponseInitialized *succeedInfo;
@end

/// Populated when initialized is false. Contains the error that prevented SDK
/// initialization.
///
/// Details about a failed SDK initialization attempt.
@interface ALWrapperSessionSDKInitializationResponseNotInitialized : NSObject
/// The last error received while trying to initialize the SDK.
@property (nonatomic, nullable, copy) NSString *lastError;
@end

/// Populated when initialized is true. Contains license details from the successful
/// initialization.
///
/// Details about a successful SDK initialization.
@interface ALWrapperSessionSDKInitializationResponseInitialized : NSObject
/// License expiry date in ISO 8601 format (YYYY-MM-DD).
@property (nonatomic, nullable, copy) NSString *expiryDate;
@end

/// Request to submit a User Corrected Result (UCR) for a previously scanned item.
@interface ALWrapperSessionUCRReportRequest : NSObject
/// Unique identifier for the scan event, taken from PluginResult.blobKey. Used to correlate
/// the correction with the original scan on the server.
@property (nonatomic, copy) NSString *blobKey;
/// The corrected result value to report.
@property (nonatomic, copy) NSString *correctedResult;
@end

/// Response from UCR (User Corrected Result) reporting. Must include either failInfo (if
/// reporting failed) or succeedInfo (if successful), corresponding to the status field.
@interface ALWrapperSessionUCRReportResponse : NSObject
/// Populated when status is ucrReportFailed. Contains the error details.
@property (nonatomic, nullable, strong) ALWrapperSessionUCRReportResponseFail *failInfo;
/// The final status of the UCR report submission.
@property (nonatomic, nullable, assign) ALWrapperSessionUCRReportResponseStatus *status;
/// Populated when status is ucrReportSucceeded. Contains the server confirmation message.
@property (nonatomic, nullable, strong) ALWrapperSessionUCRReportResponseSucceed *succeedInfo;
@end

/// Populated when status is ucrReportFailed. Contains the error details.
///
/// Details about a failed UCR report submission.
@interface ALWrapperSessionUCRReportResponseFail : NSObject
/// The last error received while reporting UCR.
@property (nonatomic, nullable, copy) NSString *lastError;
/// The error code received while connecting to server.
@property (nonatomic, nullable, strong) NSNumber *responseErrorCode;
/// The error message received while connecting to server.
@property (nonatomic, nullable, copy) NSString *responseErrorMessage;
@end

/// Populated when status is ucrReportSucceeded. Contains the server confirmation message.
///
/// Details about a successful UCR report submission.
@interface ALWrapperSessionUCRReportResponseSucceed : NSObject
/// The confirmation message returned from the server.
@property (nonatomic, nullable, copy) NSString *message;
@end

NS_ASSUME_NONNULL_END
