#import <Foundation/Foundation.h>
#import "ALAssetUpdateTask.h"

NS_ASSUME_NONNULL_BEGIN

@class ALAssetUpdateTaskFactory;
@class ALAssetUpdateTask;
@class ALAssetContext;
@protocol ALAssetUpdateDelegate;

/// Object handling the update of assets
@interface ALAssetUpdateManager : NSObject

/// Total number of asse update tasks
@property (nonatomic, readonly) NSInteger count;

/// An `ALAssetUpdateTaskFactory` instance
@property (nonatomic, strong) ALAssetUpdateTaskFactory *assetUpdateTaskFactory;

/// A shared (singleton) instance of this object
+ (ALAssetUpdateManager *)sharedManager;

/// Initializes an `ALAssetUpdateManager` object
/// @param assetUpdateTaskFactory assetUpdateTaskFactory
/// @return an `ALAssetUpdateManager` object
- (instancetype)initWithAssetUpdateTaskFactory:(ALAssetUpdateTaskFactory * _Nullable)assetUpdateTaskFactory;

/// Initializes an `ALAssetUpdateManager` object
/// @return an `ALAssetUpdateManager` object
- (instancetype)init;

/// Adds an update task to the update manager
/// @param assetContext the asset context for which updates are to be managed
/// @param delegate the object to be notified about events happening in the asset update manager
- (void)addUpdateTask:(ALAssetContext *)assetContext
             delegate:(id<ALAssetUpdateDelegate> _Nonnull)delegate;

/// Returns an asset update task previously added, given its ID
/// @param id the asset task ID
/// @return the `ALAssetUpdateTask` associated with the ID param
- (ALAssetUpdateTask * _Nullable)assetUpdateTaskWithID:(NSString *)id;

/// Returns whether there are local assets found for the asset task with the ID given
/// @param id the asset task ID
/// @return whether there are locally-downloaded assets on the device for the asset
- (BOOL)localAssetsFound:(NSString *)id;

/// Checks whether an asset is out of date, and with a parameter download the updated
/// asset files
/// @param id the id of the asset task
/// @param downloadIfOutdated download the files for a asset context if possible. Otherwise,
/// only inform the delegate that updates are available
- (void)checkForUpdates:(NSString *)id downloadIfOutdated:(BOOL)downloadIfOutdated;

/// Request to download files associated with the asset task id
/// @param id the id of the asset task
- (void)requestAssetDownload:(NSString *)id;

/// Restore the asset update task to initial values
/// @param id the id of the asset task
- (void)resetTask:(NSString *)id;

/// Remove the asset update task from the update manager
/// @param id the id of the asset task
- (ALAssetUpdateTask *)removeUpdateTask:(NSString *)id;

/// Remove all asset update tasks from the update manager
- (void)removeAll;

/// Obtain the asset controller associated with an asset update task ID
/// @param id the id of the asset task
- (ALAssetController *)assetControllerForID:(NSString *)id;

@end

NS_ASSUME_NONNULL_END
