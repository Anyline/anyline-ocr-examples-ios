//#import "ALNetworkImplementation.hpp"
#import "ALNetworkProvider.hpp"
#import "network_interface.h"
#import <Foundation/Foundation.h>
#import <regex>

@protocol ALStagingNetworkProvider <NSObject>

- (std::shared_ptr<al::network::NetworkInterface>)implementation;

@end


@interface ALStagingNetworkProvider: NSObject<ALNetworkProvider>

+ (std::shared_ptr<al::network::NetworkInterface>)getImpl;

@end
