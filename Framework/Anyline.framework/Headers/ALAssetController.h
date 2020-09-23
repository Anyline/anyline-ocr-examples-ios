//
//  ALAssetController.h
//  Anyline
//
//  Created by Angela Brett on 30.04.20.
//  Copyright © 2020 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALAssetDelegate.h"
#import "ALAssetContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALAssetController : NSObject

- (NSString *)path;
- (instancetype)initWithContext:(ALAssetContext *)context delegate:(NSObject<ALAssetDelegate> *)delegate;
/**
* Checks whether asset updates are available
*/
- (void)checkForUpdates;

/**
* Updates the assets, only after {@link #checkForUpdates()} was successfully called
*/
- (void)updateAssets;

- (void)setupAssetUpdateWithContext:(ALAssetContext *)context delegate:(NSObject<ALAssetDelegate> *)delegate;

/**
 Returns true if 'setupAssetUpdateWithContext:delegate:' was called.
 Returns false if 'resetAssetUpdate' was called or setupAssetUpdateWithContext:delegate:' has not been called.
 */
- (BOOL)isActive;

/**
* Resets the asset update functionality. After this is called,
* {@link #setupAssetUpdate(AssetContext, AssetDelegate)} must be called again
*/
- (void)resetAssetUpdate;

@property (nonatomic) ALAssetContext *assetContext;

- (NSString * __nullable)reportingValues;

@end

NS_ASSUME_NONNULL_END
