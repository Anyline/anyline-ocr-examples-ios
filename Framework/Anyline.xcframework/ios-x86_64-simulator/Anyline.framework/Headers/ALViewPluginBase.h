#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Base interface for scan view plugins. At the moment, this includes `ALScanViewPlugin` and `ALViewPluginComposite`.
@protocol ALViewPluginBase <NSObject>

/// Unique plugin ID for the scan view plugin
@property (nonatomic, readonly) NSString *pluginID;

/// List of children plugins, if composite. Otherwise, empty
@property (nonatomic, readonly) NSArray<NSObject<ALViewPluginBase> *> *children;

/// Indicates whether or not the plugin has been started
@property (nonatomic, readonly) BOOL isStarted;

/// Starts the plugin
/// @param error if an error is encountered, this will be filled with the necessary information
/// @return a boolean indicating whether or not the plugin was started successfully
- (BOOL)startWithError:(NSError * _Nullable * _Nullable)error;

/// Stops the plugin
- (void)stop;

/// Stops sending the input frames for processing, when running. Call `-resume` or `-start` to
/// resume sending frames. Note that when paused, `isStarted` will still be true.
- (void)pause;

/// Resumes sending frames for processing, when previously paused. Otherwise, calling this does not do
/// anything.
- (void)resume;

@end

NS_ASSUME_NONNULL_END
