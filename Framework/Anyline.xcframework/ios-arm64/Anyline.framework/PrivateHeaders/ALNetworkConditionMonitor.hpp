#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NetworkConditionMonitor <NSObject>

- (void)startNetworkMonitoring;

- (void)stopNetworkMonitoring;

@property (nonatomic, copy, nullable) void (^networkConditionChanged)(BOOL);

@end


@interface ALNetworkConditionMonitor : NSObject<NetworkConditionMonitor>

- (void)startNetworkMonitoring;

- (void)stopNetworkMonitoring;

+ (instancetype)sharedInstance;

@property (nonatomic, copy, nullable) void (^networkConditionChanged)(BOOL);

@end

NS_ASSUME_NONNULL_END
