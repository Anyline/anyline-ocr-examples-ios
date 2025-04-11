#ifndef ALLicenseUtil_Private_h
#define ALLicenseUtil_Private_h

NS_ASSUME_NONNULL_BEGIN

@class ALLicenseProvider;

@interface ALLicenseUtil ()

@property (nonatomic, strong) ALLicenseProvider *licenseProvider;

/// Indicates whether the license had expired but still within tolerance period.
/// Hence, a popup about it will be shown.
@property (nonatomic, readonly) BOOL showPopup;

- (BOOL)boolForValueNamed:(NSString *)valueName;

- (NSString *)stringForValueNamed:(NSString *)valueName;

- (NSArray *)arrayForValueNamed:(NSString *)valueName;

// unlike scopeEnabledFor:, an ALL in the license JSON scope won't give back true for a valueName not in the JSON
- (BOOL)scopeExplicitlyIncludes:(NSString *)valueName;

- (BOOL)isAdvancedBarcodeEnabled;

@end

NS_ASSUME_NONNULL_END

#endif /* ALLicenseUtil_Private_h */
