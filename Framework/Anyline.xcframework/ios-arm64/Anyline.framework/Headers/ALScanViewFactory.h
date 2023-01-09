#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ALScanView;
@protocol ALScanPluginDelegate;

@interface ALScanViewFactory : NSObject

/// Create a scan view from a JSON config whose filesystem path is defined.
/// The delegate passed in should either be an `ALScanPluginDelegate` or an
/// `ALPluginViewCompositeDelegate`, depending on what the config file defined,
/// otherwise an error will be returned.
/// @param configFilePath the filesystem path to the JSON config
/// @param delegate an `ALScanPluginDelegate`, or an `ALPluginViewCompositeDelegate`,
/// depending on the config
/// @param error the NSError object that will contain error information if creation
/// of the Scan View is unsuccessful
/// @return a ScanView instance, if successfully created
+ (ALScanView * _Nullable)withConfigFilePath:(NSString *)configFilePath
                                    delegate:(id)delegate
                                       error:(NSError * _Nullable * _Nullable)error;

/// Create a scan view from a JSON config whose filesystem path is defined.
/// The delegate passed in should either be an `ALScanPluginDelegate` or an
/// `ALPluginViewCompositeDelegate`, depending on what the config file defined,
/// otherwise an error will be returned.
/// @param JSONDictionary an NSDictionary that defines the configuration
/// @param delegate an `ALScanPluginDelegate`, or an `ALPluginViewCompositeDelegate`,
/// depending on the config
/// @param error the NSError object that will contain error information if creation
/// of the Scan View is unsuccessful
/// @return a ScanView instance, if successfully created
+ (ALScanView * _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary
                                    delegate:(id)delegate
                                       error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
