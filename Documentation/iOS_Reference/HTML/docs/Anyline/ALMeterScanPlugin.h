//
//  ALMeterScanPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 21/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALAbstractScanPlugin.h"
#import "ALMeterResult.h"

@protocol ALMeterScanPluginDelegate;
/**
 * The ALMeterScanPlugin class declares the programmatic interface for an object that manages easy access to Anylines energy meter scanning mode.
 *
 * Communication with the host application is managed with a delegate that conforms to ALMeterScanPluginDelegate.
 *
 * ALMeterScanPlugin is able to scan the most common energy meters. The scan mode is set with setScanMode:error.
 */
@interface ALMeterScanPlugin : ALAbstractScanPlugin

/**
 *  Sets the scan mode.
 *  It has to be ALElectricMeter, ALGasMeter, ALBarcode or ALSerialNumber
 *
 */
@property (nonatomic, assign, readonly) ALScanMode scanMode;

/**
 *  Sets the scan mode and returns an NSError if something failed.
 *
 *  @param scanMode The scan mode to set.
 *  @param error The error if something goes wrong. Can be nil.
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setScanMode:(ALScanMode)scanMode error:(NSError * _Nullable * _Nullable)error;

/**
 *  Sets the license key and delegate.
 *
 *  @param licenseKey The Anyline license key for this application bundle
 *  @param delegate The delegate that will receive the Anyline results (hast to conform to <ALMeterScanPluginDelegate>)
 *  @param error The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setupWithLicenseKey:(NSString * _Nonnull)licenseKey
                   delegate:(id<ALMeterScanPluginDelegate> _Nonnull)delegate
                      error:(NSError * _Nullable * _Nullable)error;

- (void)addDelegate:(id<ALMeterScanPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALMeterScanPluginDelegate> _Nonnull)delegate;

@end

@protocol ALMeterScanPluginDelegate <NSObject>

@required
/**
 *  Returns the scanned value
 *
 *  @param anylineMeterScanPlugin The Plugin
 *  @param scanResult The scanned result object
 *
 */
- (void)anylineMeterScanPlugin:(ALMeterScanPlugin * _Nonnull)anylineMeterScanPlugin
                 didFindResult:(ALMeterResult * _Nonnull)scanResult;

@end

