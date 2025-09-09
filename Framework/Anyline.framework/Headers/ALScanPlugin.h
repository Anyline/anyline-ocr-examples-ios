#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ALScanPluginDelegate;

@class ALPluginConfig;
@class ALRect;
@class ALAssetController;
@class ALImageProvider;
@class ALScanResult;
@class ALEvent;
@class ALImage;

/// Object which takes image frames and scans them with the configured plugin
@interface ALScanPlugin : NSObject

/// The object to be notified when events of interest can be reported
@property (nonatomic, weak) id<ALScanPluginDelegate> delegate;

/// An object providing access to the assets that the plugin runs on
@property (nonatomic, strong) ALAssetController *assetController;

/// Configuration object for the scan plugin
@property (nonatomic, strong, readonly) ALPluginConfig *pluginConfig;

/// The unique identifier string for the plugin
@property (nonatomic, readonly) NSString *pluginID;

/// Indicates whether or not the plugin has been started
@property (nonatomic, readonly) BOOL isStarted;

/// Indicates whether or not the plugin is running
@property (nonatomic, readonly) BOOL isRunning;

/// The "region of interest" within the image frame where the plugin is to be
/// told to look for objects to be scanned
@property (nonatomic, assign) CGRect ROI;

/// The last image processed from Core, if any. Can be null, if no image was processed.
@property (nonatomic, strong, nullable) ALImage *lastProcessedImage;

/// Initializes a scan plugin given a JSON config data
/// object (which encodes the string form of the config).
/// May lead to an error when config is invalid, if so the `error` param is filled
/// @param pluginConfig an `ALPluginConfig` config object
/// @param error set with the error details if there's an error encountered during initialization
/// @return the `ALScanPlugin` object
- (id _Nullable)initWithConfig:(ALPluginConfig * _Nonnull)pluginConfig
                         error:(NSError * _Nullable * _Nullable)error;

/// Initializes a scan plugin given a JSON config data
/// object (which encodes the string form of the config)
/// @param jsonConfig Configuration data in JSON.
/// @param error set with the error details if there's an error encountered during initialization
/// @return the `ALScanPlugin` object
- (id _Nullable)initWithJSONDictionary:(NSDictionary * _Nonnull)jsonConfig
                                 error:(NSError * _Nullable * _Nullable)error;

/// Starts the plugin
- (void)start;

/// Stops the plugin
- (void)stop;

@end

/// Object that is notified when there are 
@protocol ALScanPluginDelegate <NSObject>
@optional

/// Called when the scan plugin encounters an error
/// @param scanPlugin the scan plugin making the call
/// @param event the `ALEvent` object containing the error
- (void)scanPlugin:(ALScanPlugin *)scanPlugin errorReceived:(ALEvent *)event;

/// Called when the scan plugin encounters an error
/// @param scanPlugin the scan plugin making the call
/// @param event the `ALEvent` object containing the error
- (void)scanPlugin:(ALScanPlugin *)scanPlugin visualFeedbackReceived:(ALEvent *)event;

/// Called when the scan plugin would report any useful scanning information
/// @param scanPlugin the scan plugin making the call
/// @param event the `ALEvent` object containing the scanning information
- (void)scanPlugin:(ALScanPlugin *)scanPlugin scanInfoReceived:(ALEvent *)event;

/// Called when the scan plugin encounters a "run skipped" event
/// @param scanPlugin the scan plugin making the call
/// @param event the `ALEvent` object containing the run skipped details
- (void)scanPlugin:(ALScanPlugin *)scanPlugin scanRunSkipped:(ALEvent *)event;

/// Called when the scan plugin encounters an error
/// @param scanPlugin the scan plugin making the call
/// @param scanResult the scan result object
- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult;

@end

NS_ASSUME_NONNULL_END
