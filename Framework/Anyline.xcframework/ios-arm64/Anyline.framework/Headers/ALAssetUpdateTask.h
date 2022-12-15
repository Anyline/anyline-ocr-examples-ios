#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ALAssetUpdateTask;
@class ALAssetController;
@class ALAssetContext;
@class ALAssetControllerFactory;

/// An interface entities outside the SDK should use, they are to be discouraged
/// from using ALAssetController directly to manage updates, even though this will still be possible.
@protocol ALAssetUpdateDelegate <NSObject>

/// Called when a request to get updates has completed
/// @param task the asset update task
/// @param updatesFound a boolean indicating whether or not there are updates to be downloaded
- (void)assetUpdateTask:(ALAssetUpdateTask *)task updatesFound:(BOOL)updatesFound;

/// Called when an update operation is completed (or has errored out)
/// @param task the asset update task
/// @param error an NSError filled with reason for the failure, if any
- (void)assetUpdateTask:(ALAssetUpdateTask *)task completedWithError:(NSError * _Nullable)error;

/// Called when a file is downloaded during the update operation
/// @param task the asset update task
/// @param fileName the name of the file downloaded
/// @param progress overall progress of the udpate operation
- (void)assetUpdateTask:(ALAssetUpdateTask *)task downloadedFile:(NSString *)fileName progress:(CGFloat)progress;

@end

/// Used to create normal ALAssetUpdateTask, same as by doing it with the class initializer
/// It's only prepared this way for dependency injection purposes, and so that subclasses can
/// be written that creates mock updatetask objects for tests.

@interface ALAssetUpdateTaskFactory: NSObject

/// Create an asset update task
/// @param assetContext the asset context
/// @param assetUpdateDelegate the asset update delegate
/// @return an ALAssetUpdateTask object
- (ALAssetUpdateTask *)makeAssetUpdateTaskWithAssetContext:(ALAssetContext *)assetContext
                                       assetUpdateDelegate:(id<ALAssetUpdateDelegate>)assetUpdateDelegate;

@end


/// An object managing the update of an asset
@interface ALAssetUpdateTask : NSObject

/// The asset update delegate
@property (nonatomic, weak) id<ALAssetUpdateDelegate> assetUpdateDelegate;

/// The asset context
@property (nonatomic, strong) ALAssetContext *assetContext;

/// The asset controller
@property (nonatomic, strong, readonly) ALAssetController *assetController;

/// ID string of the update task
@property (nonatomic, readonly) NSString *id;

/// A factor to create asset controllers
@property (nonatomic, strong) ALAssetControllerFactory *assetControllerFactory;

/// Initializes an ALAssetUpdateTask
/// @param assetContext assetContext
/// @param assetUpdateDelegate assetUpdateDelegate
/// @param assetControllerFactory assetControllerFactory
/// @return an `ALAssetUpdateTask` object
- (id)initWithAssetContext:(ALAssetContext *)assetContext
       assetUpdateDelegate:(id<ALAssetUpdateDelegate>)assetUpdateDelegate
    assetControllerFactory:(ALAssetControllerFactory * _Nullable)assetControllerFactory;

/// Initializes an `ALAssetUpdateTask`
/// @param assetContext assetContext
/// @param assetUpdateDelegate assetUpdateDelegate
/// @return an `ALAssetUpdateTask` object
- (id)initWithAssetContext:(ALAssetContext *)assetContext
       assetUpdateDelegate:(id<ALAssetUpdateDelegate>)assetUpdateDelegate;

/// Cancel an ongoing update task
- (void)cancel;

/// Issues request to check if an updated version of the asset is available
/// @param downloadIfOutdated if false and there are updates, the delegate will only report that an
/// update is available but no downloads will automatically take place
- (void)checkForUpdates:(BOOL)downloadIfOutdated;

/// Issues request to get the latest version of the asset
- (void)downloadAssets;

/// Remove locally-downloaded files associated with the asset
- (void)removeDownloads;

/// Call this check whether or not there are locally-downloaded assets on the device
/// @return whether there are locally-downloaded assets on the device
- (BOOL)hasLocalAssets;

@end

NS_ASSUME_NONNULL_END
