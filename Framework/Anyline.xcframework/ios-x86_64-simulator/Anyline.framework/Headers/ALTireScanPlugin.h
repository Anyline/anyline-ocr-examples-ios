//
//  ALTireScanPlugin.h
//  Anyline
//
//  Created by Renato Neves Ribeiro on 20.01.22.
//  Copyright © 2022 Anyline GmbH. All rights reserved.
//

#import "ALAbstractScanPlugin.h"
#import "ALBaseTireConfig.h"
#import "ALTireResult.h"

#import "ALTireConfig.h"
#import "ALTINConfig.h"
#import "ALTireSizeConfig.h"
#import "ALCommercialTireIdConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALTireScanPluginDelegate;
/**
 *  The ALTireScanPlugin can be used to recognize text.
 *  It can be adapted to different kinds of use cases
 *  with the {@link ALTireConfig} (settings to adapt the recognition to your use case).
 *
 */

@interface ALTireScanPlugin : ALAbstractScanPlugin

/**
 Constructor for the ALTireScanPlugin

 @param pluginID An unique pluginID
 @param delegate The delegate which receives the results
 @param tireConfig The TireConfig to configure your use-case
 @param error The Error object if something fails

 @return Boolean indicating the success / failure of the call.
 */
- (instancetype _Nullable)initWithPluginID:(NSString * _Nullable)pluginID
                                  delegate:(id<ALTireScanPluginDelegate> _Nonnull)delegate
                                 tireConfig:(ALBaseTireConfig * _Nonnull)tireConfig
                                     error:(NSError *_Nullable *_Nullable)error;

- (instancetype _Null_unspecified)init NS_UNAVAILABLE;

@property (nonatomic, strong, readonly) NSPointerArray<ALTireScanPluginDelegate> * _Nullable delegates;

/**
 *  Read-only property for the ALTireConfig
 *
 *  Use method setTireConfig:error: for setting the config.
 */
@property (nullable, nonatomic, strong, readonly) ALBaseTireConfig *tireConfig;

/**
 *  Sets a new ALBaseTireConfig and returns an Error if something failed.
 *
 *  @param tireConfig The ALTireConfig to set
 *  @param error     The Error object if something fails
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setTireConfig:(ALBaseTireConfig * _Nonnull)tireConfig error:(NSError * _Nullable * _Nullable)error;

- (void)addDelegate:(id<ALTireScanPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALTireScanPluginDelegate> _Nonnull)delegate;

@end

@protocol ALTireScanPluginDelegate <NSObject>

@required

/**
 *  Called when a result is found
 *
 *  @param anylineTireScanPlugin The ALTirecanPlugin
 *  @param result               The result object
 */
- (void)anylineTireScanPlugin:(ALTireScanPlugin * _Nonnull)anylineTireScanPlugin
               didFindResult:(ALTireResult * _Nonnull)result;

@optional

/**
 *  Called when the tireConfig has been updated/set
 *
 *  @param anylineTireScanPlugin The ALTirecanPlugin
 *  @param tireConfig            A subclass of ALBaseTireConfig
 */
- (void)anylineTireScanPlugin:(ALTireScanPlugin * _Nonnull)anylineTireScanPlugin tireConfigUpdated:(ALBaseTireConfig * _Nullable)tireConfig;

@end

NS_ASSUME_NONNULL_END
