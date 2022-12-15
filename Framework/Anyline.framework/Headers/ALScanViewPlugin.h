#import <Foundation/Foundation.h>
#import "ALScanViewPluginBase.h"
#import "ALScanPlugin.h"
#import "ALScanViewPluginConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALScanViewPluginDelegate;

/// Object connecting the ScanPlugin to the ScanView
@interface ALScanViewPlugin : NSObject<ALScanViewPluginBase>

/// The scan plugin object associated with the scan view plugin
@property (nonatomic, readonly) ALScanPlugin *scanPlugin;

/// The object being notified of any events encountered during scanning
@property (nonatomic, weak) id<ALScanViewPluginDelegate> delegate;

/// The region within the image frame the scanner would specifically try to search
/// for detectable objects
@property (nonatomic, assign) CGRect regionOfInterest;

/// Children of the scan view plugin, if any
@property (nonatomic, readonly) NSArray<ALScanViewPlugin *> *children;

/// The configuration object for the scan view plugin
@property (nonatomic, readonly) ALScanViewPluginConfig *scanViewPluginConfig;

/// The object delivering the image frames for the scanning process
@property (nonatomic, strong) id<ALImageProviding> imageProvider;


/// Initializes an `ALScanViewPlugin` object with a configuration object
/// @param config an `ALScanViewPluginConfig` object
/// @param error if initialization fails, this object would be set with the reason for the failure
/// @return the `ALScanViewPlugin` object, or null
- (instancetype _Nullable)initWithConfig:(ALScanViewPluginConfig * _Nonnull)config error:(NSError * _Nullable * _Nullable)error;

/// Initializes an `ALScanViewPlugin` object with a configuration object
/// @param JSONDictionary a dictionary that encodes an `ALScanViewPluginConfig` object
/// @param error if initialization fails, this object would be set with the reason for the failure
/// @return the `ALScanViewPlugin` object
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary * _Nonnull)JSONDictionary error:(NSError * _Nullable * _Nullable)error;

@end

/// Object that is notified when an `ALScanViewPlugin` reports events of interest
@protocol ALScanViewPluginDelegate <NSObject>

@optional

/// Method called when the scan view plugin has detected objects that can be drawn as visual feedback
/// @param scanViewPlugin the scan view plugin calling this method
/// @param event the event containing details about the visual feedback
- (void)scanViewPlugin:(ALScanViewPlugin *)scanViewPlugin visualFeedbackReceived:(ALEvent *)event;

/// Method called when the scan view plugin has found and scanned an object, and that a beep has been requested
/// @param scanViewPlugin the scan view plugin calling this method
- (void)scanViewPluginResultBeepTriggered:(ALScanViewPlugin *)scanViewPlugin;

/// Method called when the scan view plugin has found and scanned an object, and that a visual blink on the screen has been requested
/// @param scanViewPlugin the scan view plugin calling this method
- (void)scanViewPluginResultBlinkTriggered:(ALScanViewPlugin *)scanViewPlugin;

/// Method called when the scan view plugin has found and scanned an object, and that a vibration has been requested
/// @param scanViewPlugin the scan view plugin calling this method
- (void)scanViewPluginResultVibrateTriggered:(ALScanViewPlugin *)scanViewPlugin;

/// Method called when the scan view plugin has detected objects that can be drawn as visual feedback
/// @param scanViewPlugin the scan view plugin calling this method
/// @param event the event containing details about the visual feedback
- (void)scanViewPlugin:(ALScanViewPlugin *)scanViewPlugin brightnessUpdated:(ALEvent *)event;

/// Method called when the scan view plugin has detected objects that can be drawn as visual feedback
/// @param scanViewPlugin the scan view plugin calling this method
/// @param event the event containing details about the visual feedback
- (void)scanViewPlugin:(ALScanViewPlugin *)scanViewPlugin cutoutVisibilityChanged:(ALEvent *)event;

@end

NS_ASSUME_NONNULL_END
