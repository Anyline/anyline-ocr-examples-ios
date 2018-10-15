//
//  ALLicensePlateScanPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 02/10/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALLicensePlateResult.h"
#import "ALAbstractScanPlugin.h"

@protocol ALLicensePlateScanPluginDelegate;

@interface ALLicensePlateScanPlugin : ALAbstractScanPlugin
/**
 Constructor for the LicensePlateScanPlugin
 
 @param pluginID An unique pluginID
 @param licenseKey The Anyline license key
 @param delegate The delegate which receives the results
 @param error The Error object if something fails
 
 @return Boolean indicating the success / failure of the call.
 */
- (instancetype _Nullable)initWithPluginID:(NSString * _Nullable)pluginID
                                licenseKey:(NSString * _Nonnull)licenseKey
                                  delegate:(id<ALLicensePlateScanPluginDelegate> _Nonnull)delegate
                                     error:(NSError *_Nullable *_Nullable)error NS_DESIGNATED_INITIALIZER;

- (instancetype _Nullable)init NS_UNAVAILABLE;

- (void)addDelegate:(id<ALLicensePlateScanPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALLicensePlateScanPluginDelegate> _Nonnull)delegate;

@end

/**
 *  The delegate for the ALLicensePlateScanPlugin.
 */
@protocol ALLicensePlateScanPluginDelegate <NSObject>

@required

/**
 *  Called when a result is found
 *
 *  @param anylineLicensePlateScanPlugin    The ALLicensePlateScanPlugin
 *  @param result                           The result object
 */
- (void)anylineLicensePlateScanPlugin:(ALLicensePlateScanPlugin * _Nonnull)anylineLicensePlateScanPlugin
                        didFindResult:(ALLicensePlateResult * _Nonnull)scanResult;

@end
