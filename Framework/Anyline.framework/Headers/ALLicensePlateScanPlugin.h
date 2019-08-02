//
//  ALLicensePlateScanPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 02/10/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALLicensePlateResult.h"
#import "ALAbstractScanPlugin.h"

typedef NS_ENUM(NSInteger, ALLicensePlateScanMode) {
    ALLicensePlateAuto = 0,
    ALLicensePlateNorway = 1,
    ALLicensePlateNorwaySpecial = 2,
    ALLicensePlateAustria = 3,
    ALLicensePlateGermany = 4,
    ALLicensePlateCzech = 5,
    ALLicensePlateFinland = 6,
    ALLicensePlateIreland = 7,
    ALLicensePlateCroatia = 8,
    ALLicensePlatePoland = 9,
    ALLicensePlateSlovakia = 10,
    ALLicensePlateSlovenia = 11,
    ALLicensePlateGreatBritain = 12,
    ALLicensePlateFrance = 13,
};

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

/**
 *  Sets the license plate scan mode.
 *  It has to be of type ALLicensePlateScanMode (e.g. ALLicensePlateAuto, ALLicensePlateNorway, etc.)
 *
 */
@property (nonatomic, assign, readonly) ALLicensePlateScanMode scanMode;

/**
 *  Sets the scan mode and returns an NSError if something failed.
 *
 *  @param license plate scanMode The scan mode to set.
 *  @param error The error if something goes wrong. Can be nil.
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setScanMode:(ALLicensePlateScanMode)scanMode error:(NSError * _Nullable * _Nullable)error;

- (void)addDelegate:(id<ALLicensePlateScanPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALLicensePlateScanPluginDelegate> _Nonnull)delegate;

- (ALLicensePlateScanMode)parseScanModeString:(NSString * _Nonnull)scanModeString;

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
