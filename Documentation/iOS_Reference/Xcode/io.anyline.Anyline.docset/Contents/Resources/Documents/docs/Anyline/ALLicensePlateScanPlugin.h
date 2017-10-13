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
 *  Sets the license key and delegate.
 *
 *  @param licenseKey   The Anyline license key for this application bundle
 *  @param delegate     The delegate that will receive the Anyline results (hast to conform to <ALLicensePlateScanPluginDelegate>)
 *  @param error        The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setupWithLicenseKey:(NSString * _Nonnull)licenseKey
                   delegate:(id<ALLicensePlateScanPluginDelegate> _Nonnull)delegate
                      error:(NSError * _Nullable * _Nullable)error;

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
                        didFindResult:(ALLicensePlateResult * _Nonnull)result;

@end
