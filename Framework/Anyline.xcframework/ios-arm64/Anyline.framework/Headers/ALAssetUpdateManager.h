//
//  ALAssetUpdateManager.h
//  AnylineFramework
//
//  Created by Aldrich Co on 12/29/21.
//  Copyright © 2021 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALAssetUpdateTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALAssetUpdateManager : NSObject

@property (nonatomic, readonly) NSInteger count;

@property (nonatomic, strong) ALAssetUpdateTaskFactory *assetUpdateTaskFactory;

+ (ALAssetUpdateManager *)sharedManager;

- (instancetype)initWithAssetUpdateTaskFactory:(ALAssetUpdateTaskFactory * _Nullable)assetUpdateTaskFactory;

- (instancetype)init;

- (void)addUpdateTask:(ALAssetContext *)assetContext
             delegate:(id<ALAssetUpdateDelegate> _Nonnull)delegate;

- (ALAssetUpdateTask * _Nullable)assetUpdateTaskWithID:(NSString *)id;

- (BOOL)localAssetsFound:(NSString *)id;

- (void)checkForUpdates:(NSString *)id downloadIfOutdated:(BOOL)downloadIfOutdated;

- (void)requestAssetDownload:(NSString *)id;

- (void)resetTask:(NSString *)id;

- (ALAssetUpdateTask *)removeUpdateTask:(NSString *)id;

- (void)removeAll;

- (ALAssetController *)assetControllerForID:(NSString *)id;

@end

NS_ASSUME_NONNULL_END
