//
//  ALOCRScanPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 15/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALAbstractScanPlugin.h"
#import "ALBaseOCRConfig.h"
#import "ALOCRResult.h"

#import "ALOCRConfig.h"
#import "ALVINConfig.h"
#import "ALContainerConfig.h"
#import "ALCattleTagConfig.h"
#import "ALTINConfig.h"

@protocol ALOCRScanPluginDelegate;
/**
 *  The ALOCRScanPlugin can be used to recognize text.
 *  It can be adapted to different kinds of use cases
 *  with the {@link ALOOCRConfig} (settings to adapt the recognition to your use case).
 *
 */
@interface ALOCRScanPlugin : ALAbstractScanPlugin

/**
 Constructor for the ALOCRScanPlugin

 @param pluginID An unique pluginID
 @param licenseKey The Anyline license key
 @param delegate The delegate which receives the results
 @param ocrConfig The OCRConfig to configure your use-case
 @param error The Error object if something fails

 @return Boolean indicating the success / failure of the call.
 */
- (instancetype _Nullable)initWithPluginID:(NSString * _Nullable)pluginID
                                  delegate:(id<ALOCRScanPluginDelegate> _Nonnull)delegate
                                 ocrConfig:(ALBaseOCRConfig * _Nonnull)ocrConfig
                                     error:(NSError *_Nullable *_Nullable)error;

- (instancetype _Nullable)init NS_UNAVAILABLE;

@property (nonatomic, strong, readonly) NSHashTable<ALOCRScanPluginDelegate> * _Nullable delegates;

/**
 *  Read-only property for the ALOCRConfig
 *
 *  Use method setOCRConfig:error: for setting the config.
 */
@property (nullable, nonatomic, strong, readonly) ALBaseOCRConfig *ocrConfig;

/**
 *  Sets a new ALBaseOCRConfig and returns an Error if something failed.
 *
 *  @param ocrConfig The ALOCRConfig to set
 *  @param error     The Error object if something fails
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setOCRConfig:(ALBaseOCRConfig * _Nonnull)ocrConfig error:(NSError * _Nullable * _Nullable)error;

- (void)addDelegate:(id<ALOCRScanPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALOCRScanPluginDelegate> _Nonnull)delegate;

@end

/**
 *  The delegate for the ALOCRScanPluginDelegate.
 */
@protocol ALOCRScanPluginDelegate <NSObject>

@required

/**
 *  Called when a result is found
 *
 *  @param anylineOCRScanPlugin The ALOCRScanPlugin
 *  @param result               The result object
 */
- (void)anylineOCRScanPlugin:(ALOCRScanPlugin * _Nonnull)anylineOCRScanPlugin
               didFindResult:(ALOCRResult * _Nonnull)result;

@optional

/**
 *  Called when the ocrConfig has been updated/set
 *
 *  @param anylineOCRScanPlugin The ALOCRScanPlugin
 *  @param ocrConfig            A subclass of ALBaseOCRConfig
 */
- (void)anylineOCRScanPlugin:(ALOCRScanPlugin * _Nonnull)anylineOCRScanPlugin ocrConfigUpdated:(ALBaseOCRConfig * _Nullable)ocrConfig;

@end
