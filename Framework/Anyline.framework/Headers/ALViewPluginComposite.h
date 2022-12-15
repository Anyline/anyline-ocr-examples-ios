#import <UIKit/UIKit.h>
#import "ALScanViewPluginBase.h"

NS_ASSUME_NONNULL_BEGIN

@class ALScanViewPluginConfig;
@class ALScanResult;

@protocol ALViewPluginCompositeDelegate;

/// The processing mode of the view plugin composite
typedef NS_ENUM(NSUInteger, ALCompositeProcessingMode) {
    /// The children plugins are run one at a time.
    ALCompositeProcessingModeSequential,
    /// The children plugins are run simultaneously, with each showing a cutout on the scan view.
    ALCompositeProcessingModeParallel
};

/// A plugin composite holds children scan view plugins to run them simultaneously or in sequence.
/// Once all results for children plugins have been reported, its delegate would be called to
/// find the aggregated scan results.
@interface ALViewPluginComposite : NSObject<ALScanViewPluginBase>

/// Delegate informing the user when the scanning has concluded for all of the children, or if there
/// is an error encountered.
@property (nonatomic, weak) id<ALViewPluginCompositeDelegate> delegate;

/// The object providing the image to the composite
@property (nonatomic, strong) id<ALImageProviding> imageProvider;

/// The processing mode of the composite
@property (nonatomic, readonly) ALCompositeProcessingMode processingMode;

/// Indicates whether the plugin composite has started or not
@property (nonatomic, readonly) BOOL isStarted;

/// The unique ID of the composite (note: each child plugin should have unique IDs as well)
@property (nonatomic, readonly) NSString *pluginID;

/// A list of the children plugins added to this composite
@property (nonatomic, readonly) NSArray<id<ALScanViewPluginBase>> *children;

/// The child ScanViewPlugin currently running
@property (nonatomic, readonly, nullable) ALScanViewPlugin *activeChild;

/// A map of the scan view plugin configs of each child
@property (nonatomic, readonly) NSDictionary<NSString *, ALScanViewPluginConfig *> *pluginConfigs;

/// An `NSDictionary` representation of the composite, that can be used to initialize another
@property (nonatomic, readonly) NSDictionary *JSONDictionary;

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
                                mode:(ALCompositeProcessingMode)mode
                            children:(NSArray<id<ALScanViewPluginBase>> *)children
                               error:(NSError **)error;

/// Returns a child scan view plugin given its ID, or null
/// @param pluginID the ID of the child scan view plugin
/// @return the ScanViewPlugin of the child when found, otherwise null
- (id<ALScanViewPluginBase> _Nullable)pluginWithID:(NSString *)pluginID;

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
