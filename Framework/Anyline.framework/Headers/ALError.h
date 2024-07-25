#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ALError(ERR_MSG,CODE,DOMAIN) [NSError errorWithDomain:(DOMAIN) code:(CODE) userInfo:@{ NSLocalizedDescriptionKey : (ERR_MSG) }]

#define NSLicenseViolationError(func) [NSError errorWithDomain:ALLicenseViolationDomain code:ALLicenseNotValidForFeature userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"The following feature is not available with your license: %@",(func)]}];

static NSString * const ALBadLicenseErrorMsg = @"It seems like there is an issue with your license! Did you call the setup method with a valid license key?";

/**
 *  The Error Domain used by the Anyline SDK
 */
static NSString * const ALSchemaValidationDomain = @"ALSchemaValidationDomain";
static NSString * const ALParserDomain = @"ALParserDomain";
static NSString * const ALRunDomain = @"ALRunDomain";
static NSString * const ALErrorDomain = @"ALErrorDomain";
static NSString * const ALCameraSetupDomain = @"ALCameraSetupDomain";
static NSString * const ALWatermarkViolationDomain = @"ALWatermarkViolationDomain";
static NSString * const ALModuleSetupDomain = @"ALModuleSetupDomain";
static NSString * const ALLicenseViolationDomain = @"ALLicenseViolationDomain";
static NSString * const ALNFCDomain = @"ALNFCDomain";

static NSString *const ALParserErrorLineNumber = @"ALParserErrorLineNumber";
static NSString *const ALParserErrorLineString = @"ALParserErrorLineString";
static NSString *const ALParserErrorParameterName = @"ALParserErrorParameterName";

typedef NS_ENUM(NSInteger, ALErrorCode) {

    /// An error indicating that the type / object created is internally inconsistent
    ALTypeError = 2002,

    /// An invalid parameter was passed to a method
    ALParameterInvalid = 2003,

    /// The license key supplied to Anyline during initialization was not valid
    ALLicenseKeyInvalid = 3001,

    /// The license key supplied was not valid for the function being used
    ALLicenseNotValidForFunction = 3002,

    /// The image used to display the watermark is not found
    ALWatermarkImageNotFound = 3003,

    /// Watermark not on window
    ALWatermarkNotOnWindow = 3004,

    /// Watermark not installed correctly in the view hierarchy
    ALWatermarkNotCorrectInViewHierarchy = 3005,

    /// Watermark was hidden
    ALWatermarkHidden = 3006,

    /// Watermark was positioned outside the application frame
    ALWatermarkOutsideApplicationFrame = 3007,

    /// Watermark is placed too far from the cutout
    ALWatermarkNotNearCutout = 3008,

    /// Watermark view bounds is out of sync
    ALWatermarkViewBoundsOutOfSnyc = 3009,

    /// Watermark view is too small
    ALWatermarkViewTooSmall = 3010,

    /// Watermark view has subviews
    ALWatermarkViewNoSubviewsAllowed = 3011,

    /// Watermark has modified alpha value
    ALWatermarkViewAlphaViolation = 3012,

    /// Watermark view count violation
    ALWatermarkViewCountViolation = 3013,

    /// Watermark view has subviews on top
    ALWatermarkViewSubviewOnTopViolation = 3014,

    /// Watermark image had been modified
    ALWatermarkImageModified = 3015,

    /// The license key supplied is not valid for the Anyline feature being used
    ALLicenseNotValidForFeature = 3018,

    /// Using an Anyline feature before having initialized the license successfully
    ALLicenseNotYetInitialized = 3019,

    /// The requested camera resolution was not supported by the device
    ALCameraResolutionNotSupportedByDevice = 8001,

    /// User denied camera usage access when prompted
    ALCameraAccessDenied = 8002,

    /// Flash not supported by device
    ALFlashNotAvailable = 8003,

    /// Camera native barcode was enabled too early (try initializing it when the scan view is running)
    ALCameraNativeBarcodeEnabledTooEarly = 8006,

    /// Unsupported format requested while using native barcode reader
    ALCameraNativeBarcodeUnsupportedFormat = 8007,

    /// The ScanView's `viewPlugin` object is nil
    ALViewPluginNotInitialized = 9001,

    /// Error on the NFC tag reader response
    ALNFCTagErrorResponseError = 10001,

    /// Invalid response received from the NFC Tag Reading session
    ALNFCTagErrorInvalidResponse = 10002,

    /// Unexpected error using the NFC tag reader
    ALNFCTagErrorUnexpectedError = 10003,

    /// Device does not support NFC tag reading
    ALNFCTagErrorNFCNotSupported = 10004,

    /// Unable to initialize tag reader for NFC connection
    ALNFCTagErrorNoConnectedTag = 10005,

    /// NFC: D087 is malformed
    ALNFCTagErrorD087Malformed = 10006,

    /// NFC: Invalid checksum
    ALNFCTagErrorInvalidResponseChecksum = 10007,

    /// NFC: Missing mandatory fields
    ALNFCTagErrorMissingMandatoryFields = 10008,

    /// NFC: Cannot decode ASN1 length
    ALNFCTagErrorCannotDecodeASN1Length = 10009,

    /// NFC: ASN1 value is invalid
    ALNFCTagErrorInvalidASN1Value = 10010,

    /// NFC: unable to protect APDU
    ALNFCTagErrorUnableToProtectAPDU = 10011,

    /// NFC: unable to unprotect APDU
    ALNFCTagErrorUnableToUnprotectAPDU = 10012,

    /// NFC: unsupported data group
    ALNFCTagErrorUnsupportedDataGroup = 10013,

    /// NFC: data group not read
    ALNFCTagErrorDataGroupNotRead = 10014,

    /// NFC tag not recognized
    ALNFCTagErrorUnknownTag = 10015,

    /// NFC: the image format being read is unknown
    ALNFCTagErrorUnknownImageFormat = 10016,

    /// NFC: Not implemented error
    ALNFCTagErrorNotImplemented = 10017,

    /// Timeout encountered while waiting for a time consuming operation
    ALTimeoutError = 11001,

    /// Error serializing or deserializing JSON object
    ALJSONError = 12001,

    /// Filesystem error
    ALFileSystemError = 13001,

    /// Cache error: no logs available
    ALCacheErrorNoLogsFound = 14001,

    /// Cache error: unable to create the zip archive
    ALCacheErrorZipCreationFailed = 14002,

    /// UIFeedback: JSON parsing error
    ALUIFeedbackJSONError = 15001
};

NS_ASSUME_NONNULL_END
