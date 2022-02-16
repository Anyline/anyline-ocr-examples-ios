//
//  ALAssetUpdateTask.h
//  Anyline
//
//  Created by Aldrich Co on 12/29/21.
//  Copyright © 2021 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Anyline/ALAssetContext.h>
#import <Anyline/ALAssetController.h>

NS_ASSUME_NONNULL_BEGIN

@class ALAssetUpdateTask;
@class ALAssetController;

// This is an interface entities outside the SDK should use, they are to be discouraged
// from using ALAssetController directly to manage updates, even though this will still be possible.
@protocol ALAssetUpdateDelegate <NSObject>

- (void)assetUpdateTask:(ALAssetUpdateTask *)task updatesFound:(BOOL)updatesFound;

- (void)assetUpdateTask:(ALAssetUpdateTask *)task completedWithError:(NSError * _Nullable)error;

- (void)assetUpdateTask:(ALAssetUpdateTask *)task downloadedFile:(NSString *)fileName progress:(CGFloat)progress;

@end

@interface ALAssetUpdateTaskFactory: NSObject
/// Merely creates a normal ALAssetUpdateTask, same as by doing it with the class initializer
/// It's only prepared this way for dependency injection purposes, and so that subclasses can
/// be written that creates mock updatetask objects for tests.
- (ALAssetUpdateTask *)makeAssetUpdateTaskWithAssetContext:(ALAssetContext *)assetContext
                                       assetUpdateDelegate:(id<ALAssetUpdateDelegate>)assetUpdateDelegate;

@end


@interface ALAssetUpdateTask : NSObject

@property (nonatomic, weak) id<ALAssetUpdateDelegate> assetUpdateDelegate;

@property (nonatomic, strong) ALAssetContext *assetContext;

@property (nonatomic, strong, readonly) ALAssetController *assetController;

@property (nonatomic, readonly) NSString *id;

@property (nonatomic, strong) ALAssetControllerFactory *assetControllerFactory;

- (id)initWithAssetContext:(ALAssetContext *)assetContext
       assetUpdateDelegate:(id<ALAssetUpdateDelegate>)assetUpdateDelegate
    assetControllerFactory:(ALAssetControllerFactory * _Nullable)assetControllerFactory;

- (id)initWithAssetContext:(ALAssetContext *)assetContext
       assetUpdateDelegate:(id<ALAssetUpdateDelegate>)assetUpdateDelegate;

- (void)cancel;

- (void)checkForUpdates:(BOOL)downloadIfOutdated;

- (void)downloadAssets;

- (void)removeDownloads;

- (BOOL)hasLocalAssets;

@end

NS_ASSUME_NONNULL_END
