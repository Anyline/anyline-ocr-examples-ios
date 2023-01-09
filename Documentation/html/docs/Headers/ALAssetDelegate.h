#ifndef ALAssetDelegate_h
#define ALAssetDelegate_h

/// The object set to be notified when asset update events can be reported
@protocol ALAssetDelegate <NSObject>

/// Callback for checking whether new updates are available
/// @param updateAvailable Returns status whether updates are available
- (void)assetUpdateAvailable:(BOOL)updateAvailable;

/// Callback which gives a progress of the asset downlaod
/// @param assetName Name of the asset downloaded
/// @param progress  Progress of the download
- (void)assetDownloadProgressWithAssetName:(NSString *)assetName
                                  progress:(float)progress;

/// Callback when there was an error downloading the assets
/// @param error Error message
- (void)assetUpdateError:(NSString *)error;

/// Callback after finishing downloading assets
- (void)assetUpdateFinished;

@end

#endif /* ALAssetDelegate_h */
