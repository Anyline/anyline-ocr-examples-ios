#ifndef ALStagingNetworkImplementation_h
#define ALStagingNetworkImplementation_h

#import "ALNetworkImplementation.hpp"

namespace al {
namespace network {

// replaces "reporting.anyline.com" in calls to with "reporting-staging.anyline.com"
class ALStagingNetworkImplementation: public ALNetworkImplementation {
public:

    NetworkResult get(const URL& url,
                      const Headers& headers = {});

    NetworkResult post(const URL& url,
                       const std::string& body, const Headers& headers = {});

    ALStagingNetworkImplementation() {}

};

}
}


#endif /* ALStagingNetworkImplementation_h */
