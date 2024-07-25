#import <UIKit/UIKit.h>
#import "ALViewPluginBase.h"

NS_ASSUME_NONNULL_BEGIN

@class ALViewPluginConfig;
@class ALProcessingMode;
@class ALScanResult;
@class ALScanViewPlugin;
@class ALViewPluginCompositeConfig;
@protocol ALViewPluginCompositeDelegate;

/// A plugin composite holds children scan view plugins to run them simultaneously or in sequence.
/// Once all results for children plugins have been reported, its delegate would be called to
/// find the aggregated scan results.
@interface ALViewPluginComposite : NSObject<ALViewPluginBase>

/// Delegate informing the user when the scanning has concluded for all of the children, or if there
/// is an error encountered.
@property (nonatomic, weak) id<ALViewPluginCompositeDelegate> delegate;

/// The processing mode of the composite
@property (nonatomic, readonly) ALProcessingMode *processingMode;

/// Indicates whether the plugin composite has started or not
@property (nonatomic, readonly) BOOL isStarted;

/// The unique ID of the composite (note: each child plugin should have unique IDs as well)
@property (nonatomic, readonly) NSString *pluginID;

/// A list of the children plugins added to this composite
@property (nonatomic, readonly) NSArray<NSObject<ALViewPluginBase> *> *children;

/// The child ScanViewPlugin currently running
@property (nonatomic, readonly, nullable) ALScanViewPlugin *activeChild __deprecated_msg("this property will be removed in a future version of Anyline");

/// A map of the scan view plugin configs of each child
@property (nonatomic, readonly) NSDictionary<NSString *, ALViewPluginConfig *> *pluginConfigs;

/// An `NSDictionary` representation of the composite, that can be used to initialize another
@property (nonatomic, readonly) NSDictionary *JSONDictionary __deprecated_msg("this property will be removed in a future version of Anyline");

@property (nonatomic, readonly) ALViewPluginCompositeConfig *config;

/// Initializes an `ALViewPluginComposite` with a suitably-structured dictionary
/// @param JSONDictionary a dictionary holding a representation of the composite, including child scan view plugins
/// @param error an error object that is filled if the initialization fails
/// @return the `ALViewPluginComposite` object
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary * _Nonnull)JSONDictionary
                                           error:(NSError * _Nullable * _Nullable)error;

/// Initializes an `ALViewPluginComposite`
/// @param ID the ID of the composite
/// @param mode the processing mode of the composite
/// @param children a list of the children scan view plugins
/// @param error an error object that is filled if the initialization fails
/// @return the `ALViewPluginComposite` object
- (instancetype _Nullable)initWithID:(NSString *)ID
                                mode:(ALProcessingMode *)mode
                            children:(NSArray<NSObject<ALViewPluginBase> *> *)children
                               error:(NSError **)error;

/// Initializes an `ALViewPluginComposite` with an `ALViewPluginCompositeConfig` object.
/// @param config the ALViewPluginCompositeConfig object
/// @param error an error object that is filled if the initialization fails
- (instancetype _Nullable)initWithConfig:(ALViewPluginCompositeConfig *)config
                                   error:(NSError * _Nullable * _Nullable)error;

/// Returns a child scan view plugin given its ID, or null
/// @param pluginID the ID of the child scan view plugin
/// @return the ScanViewPlugin of the child when found, otherwise null
- (NSObject<ALViewPluginBase> * _Nullable)pluginWithID:(NSString *)pluginID;

/// Starts the plugin
/// @param error if an error is encountered, this will be filled with the necessary information
/// @return a boolean indicating whether or not the plugin was started successfully
- (BOOL)startWithError:(NSError * _Nullable * _Nullable)error;

/// Stops the plugin
- (void)stop;

@end


/// A delegate object that the `ALViewPluginComposite` communicates with to
/// inform it of important events that occurred while running the composite
@protocol ALViewPluginCompositeDelegate <NSObject>
@optional

/// Called when all child plugins have completed scanning
/// @param viewPluginComposite the view plugin composite object making the call
/// @param scanResults a list of scan results collected from the child plugin scans,
/// in order of scanning.=
- (void)viewPluginComposite:(ALViewPluginComposite *)viewPluginComposite
         allResultsReceived:(NSArray<ALScanResult *> *)scanResults;

/// Called when there is an error found during scanning
/// @param viewPluginComposite the view plugin composite object making the call
/// @param error filled with the details of the error encountered while running
/// the composite
- (void)viewPluginComposite:(ALViewPluginComposite *)viewPluginComposite
                 errorFound:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
