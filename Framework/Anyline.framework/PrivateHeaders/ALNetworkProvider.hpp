#import <Foundation/Foundation.h>
#import "network_interface.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALNetworkProvider <NSObject>

- (std::shared_ptr<al::network::NetworkInterface>)implementation;

@end


@interface ALStandardNetworkProvider: NSObject<ALNetworkProvider>

+ (std::shared_ptr<al::network::NetworkInterface>)makeNetworkProvider;

@end

NS_ASSUME_NONNULL_END
