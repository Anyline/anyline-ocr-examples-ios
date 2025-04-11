#include <memory>
#include "Trainer/asset_delegate.h"
#include "gtest/gtest.h"
#include "ALAssetDelegate.h"

namespace al {
    class AssetDelegateWrapper : public AssetDelegate {
    private:
        NSObject<ALAssetDelegate> *objcDelegate;
    public:
        AssetDelegateWrapper(NSObject<ALAssetDelegate> *objcDelegate);
        
        void onAssetUpdateAvailable(bool updateAvailable);
        void onAssetDownloadProgress(const std::string &assetName, float progress);
        void onAssetUpdateError(const std::string &error);
        void onAssetUpdateFinished();

        bool assetUpdateAvailableCalled_ = false;
        bool assetDownloadProgressCalled_ = false;
        std::string assetUpdateErrorCalled_ = "";
        bool assetUpdateFinishedCalled_ = false;
        
        bool updateCalled_ = false;
    };
}
