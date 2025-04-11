#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ALCacheConfig;
@class ALWrapperConfig;

@interface ALAppEnvironment : NSObject

/// The operating system version
@property (nonatomic, readonly) NSString *osVersion;

/// The type of device detected by the SDK
@property (nonatomic, readonly) NSString *deviceType;

/// An identifier uniquely identifying the device
@property (nonatomic, readonly) NSString *uuid;

/// The Anyline SDK build number
@property (nonatomic, readonly) NSString *anylineBuildNumber;

/// The Anyline SDK release version number
@property (nonatomic, readonly) NSString *anylineVersionNumber;

/// The build number of the application
@property (nonatomic, readonly) NSString *appBuildNumber;

/// The version number of the application
@property (nonatomic, readonly) NSString *appVersionNumber;

/// The bundle ID of the application
@property (nonatomic, readonly) NSString *appBundleId;

/// The platform running the SDK. It should be "iOS"
@property (nonatomic, readonly) NSString *platform;

/// The environment path
@property (nonatomic, readonly) NSString *envPath;

/// The cache configuration
@property (nonatomic, readonly) ALCacheConfig *cacheConfig;

/// Information about the wrapper
@property (nonatomic, readonly) ALWrapperConfig *wrapperConfig;

/// Maximum number of runs information reported in a scanning session
@property (nonatomic, readonly) NSInteger maxRunMetricCollectionSize;

/// The singleton instance of this class. This is the same as
/// calling +instanceWithCacheConfig: with a null parameter.
+ (instancetype)sharedInstance;

/// Return the singleton instance of this class, or create one if not yet
/// available. If param is null, get the same instance if already present,
/// otherwise first create one with default preset. If not null, always
/// create a new one with the provided config and then return it.
///
/// - Parameter cacheConfig: the cache configuration
/// - Parameter wrapperConfig: the wrapper configuration
+ (instancetype)instanceWithCacheConfig:(ALCacheConfig * _Nullable)cacheConfig
                          wrapperConfig:(ALWrapperConfig * _Nullable)wrapperConfig;

/// Calls al::AppEnvironment::reset(). For internal uses only.
- (void)reset;

@end

NS_ASSUME_NONNULL_END
