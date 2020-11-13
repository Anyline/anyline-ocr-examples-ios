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
 Constructor for the MeterScanPlugin

 @param pluginID An unique pluginID
 @param licenseKey The Anyline license key
 @param delegate The delegate which receives the results
 @param error The Error object if something fails
 
 @return Boolean indicating the success / failure of the call.
 */
- (instancetype _Nullable)initWithPluginID:(NSString * _Nullable)pluginID
                                  delegate:(id<ALMeterScanPluginDelegate> _Nonnull)delegate
                                     error:(NSError *_Nullable *_Nullable)error;

- (instancetype _Nullable)init NS_UNAVAILABLE;

@property (nonatomic, strong, readonly) NSHashTable<ALMeterScanPluginDelegate> * _Nullable delegates;

/**
 *  Sets the scan mode.
 *  It has to be ALAnalogMeter, ALGasMeter, ALBarcode or ALSerialNumber
 *
 */
@property (nonatomic, assign, readonly) ALScanMode scanMode;
/**
 *  A validation regex string for the Serial scanMode.
 *  Regex has to follow the ECMAScript standard.
 *  This parameter will be ignored in the other scanModes.
 *  If you want to have no regex this property has to be set to nil.
 */
@property (nonatomic, strong) NSString * _Nullable serialNumberValidationRegex;
/**
 *  A character whitelist for the Serial scanMode.
 *  This parameter will be ignored in the other scanModes.
 *  If you want to have no regex this property has to be set to nil.
 *
 *  @warning There are only numbers and uppercase characters allowed.
 */
@property (nonatomic, strong) NSString * _Nullable serialNumberCharWhitelist;

/**
 *  Sets the scan mode and returns an NSError if something failed.
 *
 *  @param scanMode The scan mode to set.
 *  @param error The error if something goes wrong. Can be nil.
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setScanMode:(ALScanMode)scanMode error:(NSError * _Nullable * _Nullable)error;

- (void)addDelegate:(id<ALMeterScanPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALMeterScanPluginDelegate> _Nonnull)delegate;

- (ALScanMode)parseScanModeString:(NSString * _Nonnull)scanMode;

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

