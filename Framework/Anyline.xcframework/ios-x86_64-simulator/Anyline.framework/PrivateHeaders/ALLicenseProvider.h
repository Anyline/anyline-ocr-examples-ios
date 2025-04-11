#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// This class merely packages all static methods provided by the AnylineCore C++ method
/// al::license::PublicLicense (used in ALLicenseUtil), to present them as non-static methods
@interface ALLicenseProvider : NSObject

- (BOOL)showWatermark;

- (BOOL)isLicenseValid;

- (BOOL)showPopup;

- (NSString *)licenseJSONString;

@end

NS_ASSUME_NONNULL_END
