#import <Foundation/Foundation.h>

@class ALWrapperSessionSDKInitializationCacheConfig;

NS_ASSUME_NONNULL_BEGIN

/// Controls report log caching behavior. This object is passed to
/// +[AnylineSDK setupWithLicenseKey:cacheConfig:error:].
@interface ALCacheConfig : NSObject

/// Indicates whether special caching is enabled for offline licenses
@property (nonatomic, readonly) BOOL offlineLicenseCachingEnabled;

/// The default configuration, which instructs the core to use the
/// standard report caching behavior. If not specified in
/// `+[AnylineSDK setupWithLicenseKey:cacheConfig:error:]`, this config
/// will used.
+ (ALCacheConfig *)default;

/// Used for the benefit of integrators running Anyline with offline license
/// keys. It allows `+[AnylineSDK exportCachedEvents:]` to work as intended.
+ (ALCacheConfig *)offlineLicenseCachingEnabled;

/// Creates a cache config from wrapper session initialization parameters.
/// Returns nil if the input is nil.
+ (ALCacheConfig * _Nullable)cacheConfigWithWrapperSessionConfig:(ALWrapperSessionSDKInitializationCacheConfig * _Nullable)wrapperConfig;

@end

NS_ASSUME_NONNULL_END
