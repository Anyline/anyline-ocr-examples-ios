#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ALWrapperConfig;
@class ALCacheConfig;

/// The Anyline SDK
@interface AnylineSDK : NSObject

/// Initializes the Anyline SDK using the license key for your application.
/// This call must be made and should complete successfully before any Anyline
/// component could be used. If there is an error with the initialization, the
/// method returns false and the error parameter is filled with the reason.
///
/// @param licenseKey license key string for the application
/// @param error error information set if initialization fails
/// @return boolean indicating whether or not the operation succeeded
+ (BOOL)setupWithLicenseKey:(NSString *)licenseKey error:(NSError **)error;

/// Initializes the Anyline SDK using the license key for your application,
/// as well as a `cacheConfig` parameter.
///
/// This call must be made and should complete successfully before any Anyline
/// component could be used. If there is an error with the initialization, the
/// method returns false and the error parameter is filled with the reason.
///
/// @param licenseKey license key string for the application
/// @param error error information set if initialization fails
/// @param cacheConfig the caching behavior
/// @param wrapperConfig information, if any, about the wrapper using Anyline
/// @return boolean indicating whether or not the operation succeeded
+ (BOOL)setupWithLicenseKey:(NSString *)licenseKey
                cacheConfig:(ALCacheConfig * _Nullable)cacheConfig
              wrapperConfig:(ALWrapperConfig * _Nullable)wrapperConfig
                      error:(NSError **)error;

/// Provides a human-readble date for when the Anyline license key expires.
/// Make sure to call this only after `setupWithLicenseKey:` had been completed
/// successfully.
/// @return the date of expiry as a string, or null if the license wasn't yet initialized
+ (NSString *)licenseExpirationDate;

/// Version number of the SDK
/// @return the version number of the SDK
+ (NSString *)versionNumber;

/// Build number of the SDK
/// @return the build number of the SDK
+ (NSString *)buildNumber;

+ (NSString * _Nullable)exportCachedEvents:(NSError * _Nullable * _Nullable)error;

/// Takes a string containing the Anyline config and runs it with the schema validator. The return
/// value is true if and only if the string validates correctly. Otherwise, the error object will
/// contain indicate the issues found causing the validation error(s).
///
/// @param JSONString the config string
/// @param error if there are errors during validation, the error object will indicate the likely
/// reason. Use `localizedDescription` to get a quick overview of the immediate cause of the error.
/// In addition, `userInfo[NSLocalizedFailureReasonErrorKey]` provides a more detailed description
/// of the validation error.
+ (BOOL)validateJSONConfigString:(NSString *)JSONString error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
