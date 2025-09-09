#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ALWrapperSessionSDKInitializationRequest;
@class ALWrapperSessionScanStartRequest;
@class ALWrapperSessionUCRReportRequest;
@class ALWrapperSessionUCRReportResponseFail;
@class ALExportedScanResult;
@class ALExportedScanResultImageContainer;
@class ALExportedScanResultImageParameters;
@class ALWrapperSessionScanResultCleanStrategyConfig;
@class ALViewPluginType;
@class ALScanViewInitializationParameters;
@class ALWrapperSessionScanResultCallbackConfig;

@interface ALLegacyPluginHelper : NSObject

/**
 * Creates a JSON object for SDK initialization request
 * @param licenseKey The license key for SDK initialization
 * @param enableOfflineCache Whether to enable offline license caching
 * @param assetPathPrefix Optional asset path prefix
 * @return JSON object representing the SDK initialization request
 */
+ (NSDictionary *)sdkInitializationRequestJsonWithLicenseKey:(NSString *)licenseKey
                                           enableOfflineCache:(BOOL)enableOfflineCache
                                              assetPathPrefix:(NSString * _Nullable)assetPathPrefix;

/**
 * Creates a default scan result image container
 * @param shouldReturnImages Whether images should be returned
 * @return Default image container configuration
 */
+ (ALExportedScanResultImageContainer *)defaultScanResultImageContainerWithShouldReturnImages:(BOOL)shouldReturnImages;

/**
 * Creates default scan result image parameters
 * @return Default image parameters with PNG format and 100% quality
 */
+ (ALExportedScanResultImageParameters *)defaultScanResultImageParameters;

/**
 * Gets the default clean strategy for scan results
 * @return Default clean strategy (CLEAN_FOLDER_ON_START)
 */
+ (ALWrapperSessionScanResultCleanStrategyConfig *)defaultScanResultCleanStrategy;

/**
 * Creates a wrapper session scan start request
 * @param scanViewConfigContentString The scan view configuration content string
 * @param scanViewInitializationParametersString Optional scan view initialization parameters string
 * @param scanViewConfigPath Optional scan view configuration path
 * @param scanResultCallbackConfigString Optional scan result callback configuration string
 * @param shouldReturnImages Whether images should be returned (default: YES)
 * @param error Error object if creation fails
 * @return Wrapper session scan start request or nil if creation fails
 */
+ (ALWrapperSessionScanStartRequest * _Nullable)scanStartRequestWithScanViewConfigContentString:(NSString *)scanViewConfigContentString
                                                         scanViewInitializationParametersString:(NSString * _Nullable)scanViewInitializationParametersString
                                                                             scanViewConfigPath:(NSString * _Nullable)scanViewConfigPath
                                                                 scanResultCallbackConfigString:(NSString * _Nullable)scanResultCallbackConfigString
                                                                             shouldReturnImages:(BOOL)shouldReturnImages
                                                                                          error:(NSError **)error;

/**
 * Converts exported scan results to JSON string with image paths
 * @param exportedScanResults Array of exported scan results
 * @param viewPluginType The ViewPlugin type
 * @param error Error object if conversion fails
 * @return JSON string representation of scan results with image paths
 */
+ (NSString * _Nullable)scanResultsWithImagePathFromExportedScanResults:(NSArray<ALExportedScanResult *> *)exportedScanResults
                                                         viewPluginType:(ALViewPluginType *)viewPluginType
                                                                  error:(NSError **)error;

/**
 * Creates a wrapper session UCR report request
 * @param blobKey The blob key from plugin result
 * @param correctedResult The corrected result to report
 * @return Wrapper session UCR report request
 */
+ (ALWrapperSessionUCRReportRequest *)ucrReportRequestWithBlobKey:(NSString *)blobKey
                                                  correctedResult:(NSString *)correctedResult;

/**
 * Gets the error message from UCR report response failure
 * @param wrapperSessionUCRReportResponseFail The UCR report response failure object
 * @return Error message string
 */
+ (NSString * _Nullable)ucrReportResponseFailMessage:(ALWrapperSessionUCRReportResponseFail *)wrapperSessionUCRReportResponseFail;

@end

NS_ASSUME_NONNULL_END
