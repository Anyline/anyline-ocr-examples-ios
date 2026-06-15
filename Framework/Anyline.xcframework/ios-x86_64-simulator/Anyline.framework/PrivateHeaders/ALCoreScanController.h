#import <Foundation/Foundation.h>
#import "ALCorePluginCallback.h"
#import "ALGeometry.h"
#import "ALImage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALNetworkProvider;

// bad name? wrapper for the C++ al::ScanController.
@protocol ALCoreScanControlling

@property (nonatomic) ALRect *ROI;

- (void)processImage:(ALImage *)image
        synchronized:(BOOL)synchronized
         orientation:(UIInterfaceOrientation)orientation
       flipLeftRight:(BOOL)flipLeftRight
       flipTopBottom:(BOOL)flipTopBottom;

- (void)cancel;

- (void)addReportingValues:(NSString *)reportingValues;

- (BOOL)isProcessing;

@end


@interface ALCoreScanController: NSObject<ALCoreScanControlling>

- (instancetype)initWithJSONConfig:(NSString *)jsonConfig
                         assetPath:(NSString *)assetPath
                    pluginCallback:(id<ALCorePluginCallback>)pluginCallback
                             error:(NSError * _Nullable * _Nullable)error;

- (void)setAssetPath:(NSString *)assetPath;

@end

NS_ASSUME_NONNULL_END
