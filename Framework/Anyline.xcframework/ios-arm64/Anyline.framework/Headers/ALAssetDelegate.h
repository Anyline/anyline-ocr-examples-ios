//
//  ALAssetDelegate.h
//  Anyline
//
//  Created by Angela Brett on 22.01.20.
//  Copyright © 2020 Anyline GmbH. All rights reserved.
//

#ifndef ALAssetDelegate_h
#define ALAssetDelegate_h
 
@protocol ALAssetDelegate <NSObject>

/**
 * Callback for checking whether new updates are available
 * @param updateAvailable Returns status whether updates are available
 */
- (void)assetUpdateAvailable:(BOOL)updateAvailable;

/**
 * Callback which gives a progress of the asset downlaod
 * @param assetName Name of the asset downloaded
 * @param progress  Progress of the download
 */
- (void)assetDownloadProgressWithAssetName:(NSString *)assetName progress:(float)progress;

/**
 * Callback when there was an error downloading the assets
 * @param error Error message
 */
- (void)assetUpdateError:(NSString *)error;

/**
 * Callback after finishing downloading assets
 * @param assetsUpdated Returns true if the assets were updated successfully
 */
- (void)assetUpdateFinished:(BOOL)assetsUpdated;


@end

#endif /* ALAssetDelegate_h */
