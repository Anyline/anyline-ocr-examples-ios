#import <Foundation/Foundation.h>
#import "ALCorePluginCallback.h"
#import "ALGeometry.h"
#import "ALImage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALNetworkProvider;

// bad name? wrapper for the C++ al::ScanController.
@protocol ALCoreScanControlling

@property (nonatomic) ALRect *ROI;

@property (nonatomic, strong) ALImage *lastImageProcessed;

- (void)processImage:(ALImage *)image orientation:(UIInterfaceOrientation)orientation
       isFrontCamera:(BOOL)isFrontCamera;

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
