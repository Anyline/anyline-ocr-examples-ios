#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Utilities that work with the Anyline license key
@interface ALLicenseUtil : NSObject

/// Indicates whether the license had been checked and is valid. 
@property (nonatomic, readonly) BOOL isLicenseValid;

/// Indicates whether the license had allowed the watermark to be shown/not shown.
@property (nonatomic, readonly) BOOL showWatermark;

/// Singleton instance for ALLicenseUtil
/// @return the shared instance of ALLicenseUtil
+ (instancetype)sharedInstance;

/// Given a scope keyword, determine if the initialized license key is valid for it
/// @param valueName string indicating the scope being queried
- (BOOL)scopeEnabledFor:(NSString *)valueName;

/// Returns a human-readable string indicating the expiry date for the Anyline license
/// key initialized. NOTE: this method can only return a date string when
/// +[AnylineSDK setupWithLicenseKey:error:] is called beforehand and returns YES.
/// @return the date string of the license key's expiry, or null if key is not yet initialized
- (NSString *)licenseExpirationDate;

@end

NS_ASSUME_NONNULL_END
