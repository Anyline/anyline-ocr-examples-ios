#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

/// Provides a human-readble date for when the Anyline license key expires.
/// Make sure to call this only after `setupWithLicenseKey:` had been completed
/// successfully.
/// @param licenseKey the Anyline license key for the application
/// @return the date of expiry as a string, or null if the license wasn't yet initialized
+ (NSString *)licenseExpirationDateForLicense:(NSString *)licenseKey;

/// Version number of the SDK
/// @return the version number of the SDK
+ (NSString *)versionNumber;

/// Build number of the SDK
/// @return the build number of the SDK
+ (NSString *)buildNumber;

@end

NS_ASSUME_NONNULL_END
