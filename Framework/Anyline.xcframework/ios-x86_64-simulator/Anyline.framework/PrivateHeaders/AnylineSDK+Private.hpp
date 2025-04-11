#import "AnylineSDK.h"
#import "network_interface.h"
#import "ALNetworkConditionMonitor.hpp"

NS_ASSUME_NONNULL_BEGIN

@interface AnylineSDK (Private)

+ (void)reset;

+ (void)setNetworkReachable:(BOOL)isReachable;

+ (BOOL)isNetworkReachable;

+ (BOOL)setupWithLicenseKey:(NSString *)licenseKey
                cacheConfig:(ALCacheConfig * _Nullable)cacheConfig
              wrapperConfig:(ALWrapperConfig * _Nullable)wrapperConfig
             networkForInit:(std::shared_ptr<al::network::NetworkInterface>)networkForInit
        networkForReporting:(std::shared_ptr<al::network::NetworkInterface>)networkForReporting
    networkConditionMonitor:(NSObject<NetworkConditionMonitor> * _Nullable)networkConditionMonitor
                      error:(NSError * _Nullable *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
