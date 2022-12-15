#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ALEventProviding;
@protocol ALImageProviding;

@class ALRect;
@class ALImageProvider;
@class ALScanViewPlugin;

/// Base interface for scan view plugins
@protocol ALScanViewPluginBase <NSObject>

/// Unique plugin ID for the scan view plugin
@property (nonatomic, readonly) NSString *pluginID;

/// List of children plugins, if composite. Otherwise, empty
@property (nonatomic, readonly) NSArray<id<ALScanViewPluginBase>> *children;

/// Object providing the images used in this scan view plugin
@property (nonatomic, strong) id<ALImageProviding> imageProvider;

/// Indicates whether or not the plugin has been started
@property (nonatomic, readonly) BOOL isStarted;

/// Object delivering visual feedback events from the scanner
@property (nonatomic, readonly) id<ALEventProviding> visualFeedbackReceived;

/// Object delivering result beep events from the scanner
@property (nonatomic, readonly) id<ALEventProviding> resultBeepTriggered;

/// Object delivering blink result events from the scanner
@property (nonatomic, readonly) id<ALEventProviding> resultBlinkTriggered;

/// Object delivering brightness events from the scanner
@property (nonatomic, readonly) id<ALEventProviding> brightnessUpdated;

/// Object delivering cutout visibility events from the scanner
@property (nonatomic, readonly) id<ALEventProviding> cutoutVisibilityChanged;

/// Object delivering vibrate feedback events from the scanner
@property (nonatomic, readonly) id<ALEventProviding> resultVibrateTriggered;

/// Starts the plugin
/// @param error if an error is encountered, this will be filled with the necessary information
/// @return a boolean indicating whether or not the plugin was started successfully
- (BOOL)startWithError:(NSError * _Nullable * _Nullable)error;

/// Stops the plugin
- (void)stop;

/// Specify the region in the frame (x,y,width,height) where the scanner should
/// attempt to detect objects while running
/// @param ROI the region of interest
- (void)setRegionOfInterest:(CGRect)ROI;

@end

NS_ASSUME_NONNULL_END
