#ifndef ALScanPlugin_Private_h
#define ALScanPlugin_Private_h

#import "ALScanPlugin.h"
#import "ALCorePluginCallback.h"
#import "ALAssetUpdateManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALEventProviding;
@protocol ALImageProviding;
@protocol ALNetworkProvider;

@class ALPluginConfig;
@class ALCoreScanController;

typedef NS_ENUM(NSInteger, ScanPluginState) {
    ScanPluginStateStopped,
    ScanPluginStateStarted,
    ScanPluginStatePaused
};

@interface ALScanPlugin ()

@property (nonatomic, readonly) id<ALCorePluginCallback> _Nullable corePluginCallback;

@property (nonatomic, readonly) NSString * _Nullable assetPath;

@property (nonatomic, readonly) ScanPluginState currentState;

/// Object delivering the images to be processed by the scanner
@property (nonatomic, strong) id<ALImageProviding> imageProvider;

@property (nonatomic, strong) id<ALEventProviding> errorReceived;

@property (nonatomic, strong) id<ALEventProviding> visualFeedbackReceived;

@property (nonatomic, strong) id<ALEventProviding> scanInfoReceived;

@property (nonatomic, strong) id<ALEventProviding> scanRunSkipped;

@property (nonatomic, strong) id<ALEventProviding> resultReceived;

@property (nonatomic, strong) id<ALEventProviding> scanStarted;

@property (nonatomic, strong) id<ALEventProviding> scanStopped;

/// tracking the reporting values added to this scan plugin since it was created
@property (nonatomic, readonly) NSMutableArray<NSString *> *reportingValues;

- (id _Nullable)initWithConfig:(ALPluginConfig * _Nonnull)pluginConfig
                scanController:(ALCoreScanController * _Nullable)scanController
                         error:(NSError * _Nullable * _Nullable)error;

- (id _Nullable)initWithJSONDictionary:(NSDictionary * _Nonnull)configDict
                        scanController:(ALCoreScanController * _Nullable)scanController
                                 error:(NSError * _Nullable * _Nullable)error;

/// Checks a JSON string if a valid `ALPluginConfig` object can be constructed
/// from it. If not, or if the Anyline SDK has not yet been initialized, it
/// will also throw an error object.
///
/// - Parameters:
///   - pluginConfigJSON: JSON string describing the plugin config
///   - error: error object containing a reason as to why the operation
///   failed
+ (BOOL)validatePluginConfigJSONStr:(NSString *)pluginConfigJSON
                              error:(NSError * _Nullable * _Nullable)error;


- (void)addReportingValues:(NSString * _Nullable)reportingValues;

- (void)pause;

- (void)resume;

@end

#endif /* ALScanPlugin_Private_h */

NS_ASSUME_NONNULL_END
