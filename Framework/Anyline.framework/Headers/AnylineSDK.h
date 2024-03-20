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

@end

NS_ASSUME_NONNULL_END
