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
    ALLicensePlateUnitedKingdom = 12,
    ALLicensePlateFrance = 13,
    ALLicensePlateAlbania = 14,
    ALLicensePlateArmenia = 15,
    ALLicensePlateAzerbaijan = 16,
    ALLicensePlateBelarus = 17,
    ALLicensePlateBelgium = 18,
    ALLicensePlateBosniaAndHerzegovina = 19,
    ALLicensePlateBulgaria = 20,
    ALLicensePlateCyprus = 21,
    ALLicensePlateDenmark = 22,
    ALLicensePlateEstonia = 23,
    ALLicensePlateGeorgia = 24,
    ALLicensePlateGreece = 25,
    ALLicensePlateHungary = 26,
    ALLicensePlateIceland = 27,
    ALLicensePlateItaly = 28,
    ALLicensePlateLatvia = 29,
    ALLicensePlateLiechtenstein = 30,
    ALLicensePlateLithuania = 31,
    ALLicensePlateLuxembourg = 32,
    ALLicensePlateMalta = 33,
    ALLicensePlateMoldova = 34,
    ALLicensePlateMonaco = 35,
    ALLicensePlateMontenegro = 36,
    ALLicensePlateNetherlands = 37,
    ALLicensePlateNorthMacedonia = 38,
    ALLicensePlatePortugal = 39,
    ALLicensePlateRomania = 40,
    ALLicensePlateRussia = 41,
    ALLicensePlateSerbia = 42,
    ALLicensePlateSpain = 43,
    ALLicensePlateSweden = 44,
    ALLicensePlateTurkey = 45,
    ALLicensePlateUkraine = 46,
    ALLicensePlateSwitzerland = 47,
    ALLicensePlateAndorra = 48,
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
 *  @param scanMode The scan mode to set.
 *  @param error The error if something goes wrong. Can be nil.
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setScanMode:(ALLicensePlateScanMode)scanMode error:(NSError * _Nullable * _Nullable)error;

- (void)addDelegate:(id<ALLicensePlateScanPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALLicensePlateScanPluginDelegate> _Nonnull)delegate;

- (ALLicensePlateScanMode)parseScanModeString:(NSString * _Nonnull)scanModeString;

/**
 *  The validationRegex map can be used to set specific a validationRegex for a country (scanMode).
 *  E.g.: Set a specific valdiationRegex for austrian licenseplates (ALLicensePlateAustria)
 *
 *  @param validationRegex a string value that will be used as valdiationRegex
 *  @param scanMode the scanMode in which the validationRegex will be applied.
 */
- (void)addValidationRegexEntry:(NSString * _Nullable)validationRegex forCountry:(ALLicensePlateScanMode)scanMode;
/**
 * Remove the validationRegex for a specific country (scanMode).
 *
 * @param scanMode the scanMode in which the validationRegex will be applied.
 */
- (void)removeValidationRegexEntryForCountry:(ALLicensePlateScanMode)scanMode;
/**
 *  The validationRegex map can be used to set specific a validationRegex for a country (scanMode).
 *  E.g.: Set a specific valdiationRegex for austrian licenseplates (ALLicensePlateAustria)
 *
 *  @return dicionary of the current validationRegex map.
*/
- (NSMutableDictionary <NSString *, NSString *> * _Nullable)validationRegex;

/**
 *  The characterWhiteList map can be used to set specific a characterWhitelist for a country (scanMode).
 *  E.g.: Set a specific characterWhitelist for austrian licenseplates (ALLicensePlateAustria)
 *
 *  @param characterWhiteList a string value that will be used as characterWhitelist
 *  @param scanMode the scanMode in which the characterWhitelist will be applied.
*/
- (void)addCharacterWhiteListEntry:(NSString * _Nullable)characterWhiteList forCountry:(ALLicensePlateScanMode)scanMode;
/**
 *  The characterWhitelist map can be used to set specific a characterWhitelist for a country (scanMode).
 *  E.g.: Set a specific characterWhitelist for austrian licenseplates (ALLicensePlateAustria)
 *
*/
- (void)removeCharacterWhiteListEntryForCountry:(ALLicensePlateScanMode)scanMode;
/**
 *  The characterWhitelist map can be used to set specific a characterWhitelist for a country (scanMode).
 *  E.g.: Set a specific characterWhitelist for austrian licenseplates (ALLicensePlateAustria)
 *
 *  @return dicionary of the current characterWhitelist map.
*/
- (NSMutableDictionary <NSString *, NSString *> * _Nullable)characterWhitelist;

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
 *  @param scanResult                           The result object
 */
- (void)anylineLicensePlateScanPlugin:(ALLicensePlateScanPlugin * _Nonnull)anylineLicensePlateScanPlugin
                        didFindResult:(ALLicensePlateResult * _Nonnull)scanResult;

@end
