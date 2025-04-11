#ifndef ALNetworkImplementation_hpp
#define ALNetworkImplementation_hpp

#import "network_interface.h"

namespace al {
namespace network {

class ALNetworkImplementation: public NetworkInterface {
public:
    
    NetworkResult get(const URL& url,
                      const Headers& headers = {});
    
    NetworkResult post(const URL& url,
                       const std::string& body, const Headers& headers = {});
    
    
    ALNetworkImplementation(ALNetworkImplementation const&) = delete;
    
    void operator=(ALNetworkImplementation const&) = delete;
    
    ALNetworkImplementation() {}
private:
    
    NetworkResult request(const std::string& method,
                          const URL& url,
                          const std::string& body = "",
                          const Headers& headers = {});
};

}
}

#endif /* ALNetworkImplementation_hpp */
