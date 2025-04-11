#import <Foundation/Foundation.h>

#import <Anyline/ALAssetDelegate.h>
#import "ALAssetContext.h"

NS_ASSUME_NONNULL_BEGIN

/// Manages assets used by a scan plugin
@interface ALAssetController : NSObject

/// The context used containing information about the asset
@property (nonatomic) ALAssetContext *assetContext;

/// Initialize an asset controller
/// @param context the asset context used
/// @param delegate the delegate
- (instancetype)initWithContext:(ALAssetContext *)context
                       delegate:(NSObject<ALAssetDelegate> *)delegate;

/// Initialize an asset controller
/// @param context the asset context used
- (instancetype)initWithContext:(ALAssetContext *)context;

/// Checks whether asset updates are available
- (void)checkForUpdates;

/// Values that can be reported
- (NSString * __nullable)reportingValues;

/// The asset ID
- (NSString * __nullable)assetID;

/// The project ID
- (NSString * __nullable)projectID;

/// The filesystem path of the assets
- (NSString *)path;

/// Updates the assets, only after {@link #checkForUpdates()} was successfully called
- (void)updateAssets;

/// Sets up the update process for an asset
/// @param context the asset context
/// @param delegate the delegate
- (void)setupAssetUpdateWithContext:(nonnull ALAssetContext *)context
                           delegate:(nullable NSObject<ALAssetDelegate> *)delegate;

/// Returns true if 'setupAssetUpdateWithContext:delegate:' was called.
/// Returns false if 'resetAssetUpdate' was called or setupAssetUpdateWithContext:delegate:'
/// has not been called.
- (BOOL)isActive;

/// Resets the asset update functionality. After this is called,
/// `setupAssetUpdateWithContext:delegate:` must be called again.
- (void)resetAssetUpdate;

/// Cancels the asset update process
- (void)cancel;

/// Returns true if 'cancelUpdate' was called
- (BOOL)isAssetUpdateCanceled;

/// Whether any assets have been downloaded. If this returns NO, you should either check
/// for updates and download the updates, or not use an asset context.
- (BOOL)areLocalAssetsAvailable;

/// Deletes any assets that have been downloaded. After doing this, you should either check
/// for updates and download the updates, or not use an asset context.
- (void)deleteLocalAssets;

/// Creates a back up of the assets
- (void)createBackup;

/// Restores the backup of the assets, if they exist
- (void)restoreFromBackup;

/// Deletes the backup of the assets
- (void)deleteBackup;

@end

/// Factory that creates asset controllers
@interface ALAssetControllerFactory: NSObject

/// Create an asset controller
/// @param assetContext the asset context
/// @param assetDelegate the delegate
- (ALAssetController *)makeControllerWithAssetContext:(ALAssetContext *)assetContext
                                        assetDelegate:(id<ALAssetDelegate>)assetDelegate;

@end

NS_ASSUME_NONNULL_END
