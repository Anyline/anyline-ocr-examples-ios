#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ALScanView;
@class ALScanViewInitializationParameters;
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

/// Create a scan view from a JSON config dictionary.
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

/// Create a scan view from a JSON config string. The delegate passed in should either
/// be an `ALScanPluginDelegate` or an `ALPluginViewCompositeDelegate`, depending on what
/// the config file defined, otherwise an error will be returned.
///
/// @param JSONString the string containing the Anyline config
/// @param delegate an `ALScanPluginDelegate`, or an `ALPluginViewCompositeDelegate`,
/// depending on the config
/// @param error  the NSError object that will contain error information if creation
/// of the Scan View is unsuccessful
+ (ALScanView * _Nullable)withJSONString:(NSString *)JSONString
                                delegate:(id)delegate
                                   error:(NSError * _Nullable * _Nullable)error;

/// Create a scan view from a JSON config whose filesystem path is defined.
/// The delegate passed in should either be an `ALScanPluginDelegate` or an
/// `ALPluginViewCompositeDelegate`, depending on what the config file defined,
/// otherwise an error will be returned.
/// @param configFilePath the filesystem path to the JSON config
/// @param initializationParams an optional object containing additional parameters to configure plugin behavior
/// @param delegate an `ALScanPluginDelegate`, or an `ALPluginViewCompositeDelegate`,
/// depending on the config
/// @param error the NSError object that will contain error information if creation
/// of the Scan View is unsuccessful
/// @return a ScanView instance, if successfully created
+ (ALScanView * _Nullable)withConfigFilePath:(NSString *)configFilePath
                        initializationParams:(ALScanViewInitializationParameters * _Nullable)initializationParams
                                    delegate:(id)delegate
                                       error:(NSError * _Nullable * _Nullable)error;

/// Create a scan view from a JSON config dictionary.
/// The delegate passed in should either be an `ALScanPluginDelegate` or an
/// `ALPluginViewCompositeDelegate`, depending on what the config file defined,
/// otherwise an error will be returned.
/// @param JSONDictionary an NSDictionary that defines the configuration
/// @param initializationParams an optional object containing additional parameters to configure plugin behavior
/// @param delegate an `ALScanPluginDelegate`, or an `ALPluginViewCompositeDelegate`,
/// depending on the config
/// @param error the NSError object that will contain error information if creation
/// of the Scan View is unsuccessful
/// @return a ScanView instance, if successfully created
+ (ALScanView * _Nullable)withJSONDictionary:(NSDictionary *)JSONDictionary
                        initializationParams:(ALScanViewInitializationParameters * _Nullable)initializationParams
                                    delegate:(id)delegate
                                       error:(NSError * _Nullable * _Nullable)error;

/// Create a scan view from a JSON config string. The delegate passed in should either
/// be an `ALScanPluginDelegate` or an `ALPluginViewCompositeDelegate`, depending on what
/// the config file defined, otherwise an error will be returned.
///
/// @param JSONString the string containing the Anyline config
/// @param initializationParams an optional object containing additional parameters to configure plugin behavior
/// @param delegate an `ALScanPluginDelegate`, or an `ALPluginViewCompositeDelegate`,
/// depending on the config
/// @param error  the NSError object that will contain error information if creation
/// of the Scan View is unsuccessful
+ (ALScanView * _Nullable)withJSONString:(NSString *)JSONString
                    initializationParams:(ALScanViewInitializationParameters * _Nullable)initializationParams
                                delegate:(id)delegate
                                   error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
