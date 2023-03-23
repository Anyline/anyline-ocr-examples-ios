// To parse this JSON:
//
//   NSError *error;
//   ALPluginConfig *pluginConfig = [ALPluginConfig fromJSON:json encoding:NSUTF8Encoding error:&error];

#import <Foundation/Foundation.h>

@class ALPluginConfig;
@class ALBarcodeConfig;
@class ALBarcodeFormat;
@class ALCommercialTireIDConfig;
@class ALUpsideDownMode;
@class ALContainerConfig;
@class ALContainerConfigScanMode;
@class ALJapaneseLandingPermissionConfig;
@class ALJapaneseLandingPermissionConfigFieldOption;
@class ALLicensePlateConfig;
@class ALLicensePlateConfigScanMode;
@class ALMeterConfig;
@class ALMeterConfigScanMode;
@class ALMrzConfig;
@class ALMrzFieldScanOptions;
@class ALMrzScanOption;
@class ALMrzMinFieldConfidences;
@class ALOcrConfig;
@class ALOcrConfigScanMode;
@class ALStartVariable;
@class ALTinConfig;
@class ALTinConfigScanMode;
@class ALTireSizeConfig;
@class ALUniversalIDConfig;
@class ALAllowedLayouts;
@class ALAlphabet;
@class ALLayoutDrivingLicense;
@class ALUniversalIDField;
@class ALLayoutInsuranceCard;
@class ALLayoutMrz;
@class ALLayoutIDFront;
@class ALVehicleRegistrationCertificateConfig;
@class ALLayoutVehicleRegistrationCertificate;
@class ALVehicleRegistrationCertificateField;
@class ALVinConfig;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Boxed enums

@interface ALBarcodeFormat : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALBarcodeFormat *)all;
+ (ALBarcodeFormat *)aztec;
+ (ALBarcodeFormat *)aztecInverse;
+ (ALBarcodeFormat *)bookland;
+ (ALBarcodeFormat *)codabar;
+ (ALBarcodeFormat *)code11;
+ (ALBarcodeFormat *)code128;
+ (ALBarcodeFormat *)code32;
+ (ALBarcodeFormat *)code39;
+ (ALBarcodeFormat *)code93;
+ (ALBarcodeFormat *)coupon;
+ (ALBarcodeFormat *)dataMatrix;
+ (ALBarcodeFormat *)databar;
+ (ALBarcodeFormat *)discrete2_5;
+ (ALBarcodeFormat *)dotCode;
+ (ALBarcodeFormat *)ean13;
+ (ALBarcodeFormat *)ean8;
+ (ALBarcodeFormat *)gs1128;
+ (ALBarcodeFormat *)gs1QrCode;
+ (ALBarcodeFormat *)isbt128;
+ (ALBarcodeFormat *)issnEan;
+ (ALBarcodeFormat *)itf;
+ (ALBarcodeFormat *)kix;
+ (ALBarcodeFormat *)matrix2_5;
+ (ALBarcodeFormat *)maxicode;
+ (ALBarcodeFormat *)microPDF;
+ (ALBarcodeFormat *)microQr;
+ (ALBarcodeFormat *)msi;
+ (ALBarcodeFormat *)oneDInverse;
+ (ALBarcodeFormat *)pdf417;
+ (ALBarcodeFormat *)postUk;
+ (ALBarcodeFormat *)qrCode;
+ (ALBarcodeFormat *)qrInverse;
+ (ALBarcodeFormat *)rss14;
+ (ALBarcodeFormat *)rssExpanded;
+ (ALBarcodeFormat *)trioptic;
+ (ALBarcodeFormat *)upcA;
+ (ALBarcodeFormat *)upcE;
+ (ALBarcodeFormat *)upcEanExtension;
+ (ALBarcodeFormat *)upuFics;
+ (ALBarcodeFormat *)usPlanet;
+ (ALBarcodeFormat *)usPostnet;
+ (ALBarcodeFormat *)usps4Cb;
@end

/// Sets whether the text shall also be scanned upside-down. By default, it is disabled.
@interface ALUpsideDownMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALUpsideDownMode *)disabled;
+ (ALUpsideDownMode *)enabled;
+ (ALUpsideDownMode *)upsideDownModeAUTO;
@end

/// Determines if container numbers shall be scanned horizontally or vertically.
@interface ALContainerConfigScanMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALContainerConfigScanMode *)horizontal;
+ (ALContainerConfigScanMode *)vertical;
@end

/// Specifies a country or location of which license plates shall be scanned.
@interface ALLicensePlateConfigScanMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALLicensePlateConfigScanMode *)africa;
+ (ALLicensePlateConfigScanMode *)albania;
+ (ALLicensePlateConfigScanMode *)andorra;
+ (ALLicensePlateConfigScanMode *)armenia;
+ (ALLicensePlateConfigScanMode *)austria;
+ (ALLicensePlateConfigScanMode *)azerbaijan;
+ (ALLicensePlateConfigScanMode *)belarus;
+ (ALLicensePlateConfigScanMode *)belgium;
+ (ALLicensePlateConfigScanMode *)bosniaandherzegovina;
+ (ALLicensePlateConfigScanMode *)bulgaria;
+ (ALLicensePlateConfigScanMode *)croatia;
+ (ALLicensePlateConfigScanMode *)cyprus;
+ (ALLicensePlateConfigScanMode *)czech;
+ (ALLicensePlateConfigScanMode *)denmark;
+ (ALLicensePlateConfigScanMode *)estonia;
+ (ALLicensePlateConfigScanMode *)finland;
+ (ALLicensePlateConfigScanMode *)france;
+ (ALLicensePlateConfigScanMode *)georgia;
+ (ALLicensePlateConfigScanMode *)germany;
+ (ALLicensePlateConfigScanMode *)greece;
+ (ALLicensePlateConfigScanMode *)hungary;
+ (ALLicensePlateConfigScanMode *)iceland;
+ (ALLicensePlateConfigScanMode *)ireland;
+ (ALLicensePlateConfigScanMode *)italy;
+ (ALLicensePlateConfigScanMode *)latvia;
+ (ALLicensePlateConfigScanMode *)liechtenstein;
+ (ALLicensePlateConfigScanMode *)lithuania;
+ (ALLicensePlateConfigScanMode *)luxembourg;
+ (ALLicensePlateConfigScanMode *)malta;
+ (ALLicensePlateConfigScanMode *)moldova;
+ (ALLicensePlateConfigScanMode *)monaco;
+ (ALLicensePlateConfigScanMode *)montenegro;
+ (ALLicensePlateConfigScanMode *)netherlands;
+ (ALLicensePlateConfigScanMode *)northmacedonia;
+ (ALLicensePlateConfigScanMode *)norway;
+ (ALLicensePlateConfigScanMode *)norwayspecial;
+ (ALLicensePlateConfigScanMode *)poland;
+ (ALLicensePlateConfigScanMode *)portugal;
+ (ALLicensePlateConfigScanMode *)romania;
+ (ALLicensePlateConfigScanMode *)russia;
+ (ALLicensePlateConfigScanMode *)scanModeAuto;
+ (ALLicensePlateConfigScanMode *)serbia;
+ (ALLicensePlateConfigScanMode *)slovakia;
+ (ALLicensePlateConfigScanMode *)slovenia;
+ (ALLicensePlateConfigScanMode *)spain;
+ (ALLicensePlateConfigScanMode *)sweden;
+ (ALLicensePlateConfigScanMode *)switzerland;
+ (ALLicensePlateConfigScanMode *)turkey;
+ (ALLicensePlateConfigScanMode *)ukraine;
+ (ALLicensePlateConfigScanMode *)unitedkingdom;
+ (ALLicensePlateConfigScanMode *)unitedstates;
@end

/// Determines which types of meters to scan.
@interface ALMeterConfigScanMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALMeterConfigScanMode *)autoAnalogDigitalMeter;
+ (ALMeterConfigScanMode *)dialMeter;
+ (ALMeterConfigScanMode *)digitalMeter2_Experimental;
+ (ALMeterConfigScanMode *)multiFieldDigitalMeter;
@end

/// The mrzScanOption determines whether a field is considered optional, mandatory, disabled
/// or follows a default behavior.
@interface ALMrzScanOption : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALMrzScanOption *)disabled;
+ (ALMrzScanOption *)mandatory;
+ (ALMrzScanOption *)mrzScanOptionDefault;
+ (ALMrzScanOption *)optional;
@end

/// Sets whether to scan single-line texts, multi-line texts in a grid-formation or finds
/// text automatically.
@interface ALOcrConfigScanMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALOcrConfigScanMode *)grid;
+ (ALOcrConfigScanMode *)line;
+ (ALOcrConfigScanMode *)scanModeAuto;
@end

/// Sets the mode to scan universal TIN numbers ('UNIVERSAL'), TIN numbers of any length
/// starting with DOT ('DOT') or fixed-length TIN numbers ('DOT_STRICT').
@interface ALTinConfigScanMode : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALTinConfigScanMode *)dot;
+ (ALTinConfigScanMode *)dotStrict;
+ (ALTinConfigScanMode *)universal;
@end

/// Sets a specific character set. Per default, only latin characters are processed.
@interface ALAlphabet : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALAlphabet *)arabic;
+ (ALAlphabet *)cyrillic;
+ (ALAlphabet *)latin;
@end

#pragma mark - Object interfaces

/// General configuration for scan plugins
@interface ALPluginConfig : NSObject
@property (nonatomic, nullable, strong) ALBarcodeConfig *barcodeConfig;
/// Sets whether or not to continue scanning once a result is found.
@property (nonatomic, nullable, strong) NSNumber *cancelOnResult;
@property (nonatomic, nullable, strong) ALCommercialTireIDConfig *commercialTireIDConfig;
@property (nonatomic, nullable, strong) ALContainerConfig *containerConfig;
/// Sets a name for the scan plugin.
@property (nonatomic, copy)             NSString *identifier;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionConfig *japaneseLandingPermissionConfig;
@property (nonatomic, nullable, strong) ALLicensePlateConfig *licensePlateConfig;
@property (nonatomic, nullable, strong) ALMeterConfig *meterConfig;
@property (nonatomic, nullable, strong) ALMrzConfig *mrzConfig;
@property (nonatomic, nullable, strong) ALOcrConfig *ocrConfig;
/// Sets an initial time period where scanned frames are not processed as results.
@property (nonatomic, nullable, strong) NSNumber *startScanDelay;
/// Allows to fine-tune a list of options for plugins.
@property (nonatomic, nullable, copy)   NSArray<ALStartVariable *> *startVariables;
@property (nonatomic, nullable, strong) ALTinConfig *tinConfig;
@property (nonatomic, nullable, strong) ALTireSizeConfig *tireSizeConfig;
@property (nonatomic, nullable, strong) ALUniversalIDConfig *universalIDConfig;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateConfig *vehicleRegistrationCertificateConfig;
@property (nonatomic, nullable, strong) ALVinConfig *vinConfig;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

/// Configuration for scanning barcodes
@interface ALBarcodeConfig : NSObject
/// Set this to filter which barcode formats should be scanned. Setting 'ALL' will enable
/// scanning all supported formats.
@property (nonatomic, copy) NSArray<ALBarcodeFormat *> *barcodeFormats;
/// If this option is set, allows consecutive barcode results of the same barcode when
/// scanning continuously.
@property (nonatomic, nullable, strong) NSNumber *consecutiveEqualResults;
/// Setting this to 'true' will enable reading multiple barcodes per frame.
@property (nonatomic, nullable, strong) NSNumber *multiBarcode;
/// If this option is set, barcodes parsed according to the AAMVA standard. This only works
/// for PDF417 codes on driving licenses.
@property (nonatomic, nullable, strong) NSNumber *parseAAMVA;
@end

/// Configuration for scanning commercial Tire IDs
@interface ALCommercialTireIDConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Sets whether the text shall also be scanned upside-down. By default, it is disabled.
@property (nonatomic, nullable, assign) ALUpsideDownMode *upsideDownMode;
@end

/// Configuration for scanning shipping container numbers
@interface ALContainerConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Determines if container numbers shall be scanned horizontally or vertically.
@property (nonatomic, nullable, assign) ALContainerConfigScanMode *scanMode;
/// Sets a regular expression which the scanned text needs to match in order to trigger a
/// scan result.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

/// Configuration for scanning japanese landing permission tickets
@interface ALJapaneseLandingPermissionConfig : NSObject
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionConfigFieldOption *airport;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionConfigFieldOption *dateOfExpiry;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionConfigFieldOption *dateOfIssue;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionConfigFieldOption *duration;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionConfigFieldOption *status;
@end

/// Field option for JLP fields
@interface ALJapaneseLandingPermissionConfigFieldOption : NSObject
/// Set the minConfidence between 0 and 100. Otherwise, it's defaulted.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Set the scanOption to one of the following: 0 = mandatory, 1 = optional, 2 = disabled.
/// Otherwise, it's defaulted.
@property (nonatomic, nullable, strong) NSNumber *scanOption;
@end

/// Configuration for scanning license plates
@interface ALLicensePlateConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Specifies a country or location of which license plates shall be scanned.
@property (nonatomic, nullable, assign) ALLicensePlateConfigScanMode *scanMode;
/// Sets a regular expression which the scanned text needs to match in order to trigger a
/// scan result.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

/// Configuration for scanning meters
@interface ALMeterConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Determines which types of meters to scan.
@property (nonatomic, assign) ALMeterConfigScanMode *scanMode;
@end

/// Configuration for scanning machine-readable zones (MRZ) of passports and other IDs
@interface ALMrzConfig : NSObject
/// The cropAndTransformID determines whether or not the image shall be cropped and
/// transformed.
@property (nonatomic, assign) BOOL isCropAndTransformID;
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// The fieldmrzScanOptions configure which text fields shall be captured mandatory, optional
/// or not at all.
@property (nonatomic, nullable, strong) ALMrzFieldScanOptions *mrzFieldScanOptions;
/// The minFieldConfidences configure which fields must reach which confidence thresholds in
/// order to be part of the scan result.
@property (nonatomic, nullable, strong) ALMrzMinFieldConfidences *mrzMinFieldConfidences;
/// The strictMode determines whether or not the MRZ must follow the ICAO standard.
@property (nonatomic, assign) BOOL isStrictMode;
@end

/// The fieldmrzScanOptions configure which text fields shall be captured mandatory, optional
/// or not at all.
@interface ALMrzFieldScanOptions : NSObject
@property (nonatomic, nullable, assign) ALMrzScanOption *checkDigitDateOfBirth;
@property (nonatomic, nullable, assign) ALMrzScanOption *checkDigitDateOfExpiry;
@property (nonatomic, nullable, assign) ALMrzScanOption *checkDigitDocumentNumber;
@property (nonatomic, nullable, assign) ALMrzScanOption *checkDigitFinal;
@property (nonatomic, nullable, assign) ALMrzScanOption *checkDigitPersonalNumber;
@property (nonatomic, nullable, assign) ALMrzScanOption *dateOfBirth;
@property (nonatomic, nullable, assign) ALMrzScanOption *dateOfExpiry;
@property (nonatomic, nullable, assign) ALMrzScanOption *documentNumber;
@property (nonatomic, nullable, assign) ALMrzScanOption *documentType;
@property (nonatomic, nullable, assign) ALMrzScanOption *givenNames;
@property (nonatomic, nullable, assign) ALMrzScanOption *issuingCountryCode;
@property (nonatomic, nullable, assign) ALMrzScanOption *mrzString;
@property (nonatomic, nullable, assign) ALMrzScanOption *nationalityCountryCode;
@property (nonatomic, nullable, assign) ALMrzScanOption *optionalData;
@property (nonatomic, nullable, assign) ALMrzScanOption *personalNumber;
@property (nonatomic, nullable, assign) ALMrzScanOption *sex;
@property (nonatomic, nullable, assign) ALMrzScanOption *surname;
@property (nonatomic, nullable, assign) ALMrzScanOption *vizAddress;
@property (nonatomic, nullable, assign) ALMrzScanOption *vizDateOfBirth;
@property (nonatomic, nullable, assign) ALMrzScanOption *vizDateOfExpiry;
@property (nonatomic, nullable, assign) ALMrzScanOption *vizDateOfIssue;
@property (nonatomic, nullable, assign) ALMrzScanOption *vizGivenNames;
@property (nonatomic, nullable, assign) ALMrzScanOption *vizSurname;
@end

/// The minFieldConfidences configure which fields must reach which confidence thresholds in
/// order to be part of the scan result.
@interface ALMrzMinFieldConfidences : NSObject
@property (nonatomic, nullable, strong) NSNumber *checkDigitDateOfBirth;
@property (nonatomic, nullable, strong) NSNumber *checkDigitDateOfExpiry;
@property (nonatomic, nullable, strong) NSNumber *checkDigitDocumentNumber;
@property (nonatomic, nullable, strong) NSNumber *checkDigitFinal;
@property (nonatomic, nullable, strong) NSNumber *checkDigitPersonalNumber;
@property (nonatomic, nullable, strong) NSNumber *dateOfBirth;
@property (nonatomic, nullable, strong) NSNumber *dateOfExpiry;
@property (nonatomic, nullable, strong) NSNumber *documentNumber;
@property (nonatomic, nullable, strong) NSNumber *documentType;
@property (nonatomic, nullable, strong) NSNumber *givenNames;
@property (nonatomic, nullable, strong) NSNumber *issuingCountryCode;
@property (nonatomic, nullable, strong) NSNumber *mrzString;
@property (nonatomic, nullable, strong) NSNumber *nationalityCountryCode;
@property (nonatomic, nullable, strong) NSNumber *optionalData;
@property (nonatomic, nullable, strong) NSNumber *personalNumber;
@property (nonatomic, nullable, strong) NSNumber *sex;
@property (nonatomic, nullable, strong) NSNumber *surname;
@property (nonatomic, nullable, strong) NSNumber *vizAddress;
@property (nonatomic, nullable, strong) NSNumber *vizDateOfBirth;
@property (nonatomic, nullable, strong) NSNumber *vizDateOfExpiry;
@property (nonatomic, nullable, strong) NSNumber *vizDateOfIssue;
@property (nonatomic, nullable, strong) NSNumber *vizGivenNames;
@property (nonatomic, nullable, strong) NSNumber *vizSurname;
@end

/// Configuration for general OCR scanning use-cases
@interface ALOcrConfig : NSObject
/// Sets the number of characters in each text line for 'grid' mode.
@property (nonatomic, nullable, strong) NSNumber *charCountX;
/// Sets the number of text lines for 'grid' mode.
@property (nonatomic, nullable, strong) NSNumber *charCountY;
/// Defines the average horizontal distance between two characters in 'grid' mode, measured
/// in percentage of the characters width.
@property (nonatomic, nullable, strong) NSNumber *charPaddingXFactor;
/// Defines the average vertical distance between two characters in 'grid' mode, measured in
/// percentage of the characters height.
@property (nonatomic, nullable, strong) NSNumber *charPaddingYFactor;
/// Restricts the scanner to a set of characters to be detected.
@property (nonatomic, nullable, copy) NSString *charWhitelist;
/// Sets a custom Anyline script. The file has to be located in the project and point to a
/// path relative from the project root.
@property (nonatomic, nullable, copy) NSString *customCmdFile;
/// Sets a maximum character height (in pixels) to be considered in the scanning process.
@property (nonatomic, nullable, strong) NSNumber *maxCharHeight;
/// Sets a minimum character height (in pixels) to be considered in the scanning process.
@property (nonatomic, nullable, strong) NSNumber *minCharHeight;
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Sets a sharpnes factor (0-100) to rule out blurry images.
@property (nonatomic, nullable, strong) NSNumber *minSharpness;
/// Sets a custom Anyline model. The file has to be located in the project and point to a
/// path relative from the project root.
@property (nonatomic, nullable, copy) NSString *model;
/// Sets whether to scan single-line texts, multi-line texts in a grid-formation or finds
/// text automatically.
@property (nonatomic, nullable, assign) ALOcrConfigScanMode *scanMode;
/// Sets a regular expression which the scanned text needs to match in order to trigger a
/// scan result.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

/// Describes a start variable for fine-tuning plugins.
@interface ALStartVariable : NSObject
/// The key of the variable.
@property (nonatomic, copy) NSString *key;
/// The value of the variable.
@property (nonatomic, copy) id value;
@end

/// Configuration for scanning TIN numbers
@interface ALTinConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Sets the mode to scan universal TIN numbers ('UNIVERSAL'), TIN numbers of any length
/// starting with DOT ('DOT') or fixed-length TIN numbers ('DOT_STRICT').
@property (nonatomic, nullable, assign) ALTinConfigScanMode *scanMode;
/// Sets whether the text shall also be scanned upside-down. By default, it is disabled.
@property (nonatomic, nullable, assign) ALUpsideDownMode *upsideDownMode;
/// Sets wether the production date validation is enabled. If it is set to false the scan
/// result is also returned for invalid and missing dates. Defaults to true.
@property (nonatomic, nullable, strong) NSNumber *validateProductionDate;
@end

/// Configuration for scanning Tire Size Specifications
@interface ALTireSizeConfig : NSObject
/// Sets a minimum confidence which has to be reached in order to trigger a scan result.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Sets whether the text shall also be scanned upside-down. By default, it is disabled.
@property (nonatomic, nullable, assign) ALUpsideDownMode *upsideDownMode;
@end

/// Configuration for scanning all kinds of identification documents
@interface ALUniversalIDConfig : NSObject
/// Specifies the document types to be scanned and optionally further specifies which types
/// of layout are scanned per type.
@property (nonatomic, nullable, strong) ALAllowedLayouts *allowedLayouts;
/// Sets a specific character set. Per default, only latin characters are processed.
@property (nonatomic, nullable, assign) ALAlphabet *alphabet;
@property (nonatomic, nullable, strong) ALLayoutDrivingLicense *drivingLicense;
@property (nonatomic, nullable, strong) ALLayoutIDFront *theIDFront;
@property (nonatomic, nullable, strong) ALLayoutInsuranceCard *insuranceCard;
@property (nonatomic, nullable, strong) ALLayoutMrz *mrz;
@end

/// Specifies the document types to be scanned and optionally further specifies which types
/// of layout are scanned per type.
@interface ALAllowedLayouts : NSObject
@property (nonatomic, nullable, copy) NSArray<NSString *> *drivingLicense;
@property (nonatomic, nullable, copy) NSArray<NSString *> *theIDFront;
@property (nonatomic, nullable, copy) NSArray<NSString *> *insuranceCard;
@property (nonatomic, nullable, copy) NSArray<NSString *> *mrz;
@end

/// Contains all the supported field scan options for driving licenses.
@interface ALLayoutDrivingLicense : NSObject
@property (nonatomic, nullable, strong) ALUniversalIDField *additionalInformation;
@property (nonatomic, nullable, strong) ALUniversalIDField *additionalInformation1;
@property (nonatomic, nullable, strong) ALUniversalIDField *address;
@property (nonatomic, nullable, strong) ALUniversalIDField *audit;
@property (nonatomic, nullable, strong) ALUniversalIDField *authority;
@property (nonatomic, nullable, strong) ALUniversalIDField *cardNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *categories;
@property (nonatomic, nullable, strong) ALUniversalIDField *conditions;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfIssue;
@property (nonatomic, nullable, strong) ALUniversalIDField *documentDiscriminator;
@property (nonatomic, nullable, strong) ALUniversalIDField *documentNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *duplicate;
@property (nonatomic, nullable, strong) ALUniversalIDField *duration;
@property (nonatomic, nullable, strong) ALUniversalIDField *endorsements;
@property (nonatomic, nullable, strong) ALUniversalIDField *eyes;
@property (nonatomic, nullable, strong) ALUniversalIDField *firstIssued;
@property (nonatomic, nullable, strong) ALUniversalIDField *firstName;
@property (nonatomic, nullable, strong) ALUniversalIDField *fullName;
@property (nonatomic, nullable, strong) ALUniversalIDField *givenNames;
@property (nonatomic, nullable, strong) ALUniversalIDField *hair;
@property (nonatomic, nullable, strong) ALUniversalIDField *height;
@property (nonatomic, nullable, strong) ALUniversalIDField *lastName;
@property (nonatomic, nullable, strong) ALUniversalIDField *licenceNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *licenseClass;
@property (nonatomic, nullable, strong) ALUniversalIDField *licenseNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *name;
@property (nonatomic, nullable, strong) ALUniversalIDField *office;
@property (nonatomic, nullable, strong) ALUniversalIDField *parish;
@property (nonatomic, nullable, strong) ALUniversalIDField *personalNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *placeOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *previousType;
@property (nonatomic, nullable, strong) ALUniversalIDField *restrictions;
@property (nonatomic, nullable, strong) ALUniversalIDField *revoked;
@property (nonatomic, nullable, strong) ALUniversalIDField *sex;
@property (nonatomic, nullable, strong) ALUniversalIDField *surname;
@property (nonatomic, nullable, strong) ALUniversalIDField *type;
@property (nonatomic, nullable, strong) ALUniversalIDField *version;
@property (nonatomic, nullable, strong) ALUniversalIDField *verticalNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *weight;
@end

/// Configures scanning options for ID fields in order to fine-tune the ID scanner.
@interface ALUniversalIDField : NSObject
/// Set the minConfidence between 0 and 100. Otherwise, it's defaulted.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Set the scanOption to one of the following: 0 = mandatory, 1 = optional, 2 = disabled.
/// Otherwise, it's defaulted.
@property (nonatomic, nullable, strong) NSNumber *scanOption;
@end

/// Contains all the supported field scan options for insurance cards.
@interface ALLayoutInsuranceCard : NSObject
@property (nonatomic, nullable, strong) ALUniversalIDField *authority;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDField *documentNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *firstName;
@property (nonatomic, nullable, strong) ALUniversalIDField *lastName;
@property (nonatomic, nullable, strong) ALUniversalIDField *nationality;
@property (nonatomic, nullable, strong) ALUniversalIDField *personalNumber;
@end

/// Contains all the supported field scan options for MRZ.
@interface ALLayoutMrz : NSObject
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDField *vizAddress;
@property (nonatomic, nullable, strong) ALUniversalIDField *vizDateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *vizDateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDField *vizDateOfIssue;
@property (nonatomic, nullable, strong) ALUniversalIDField *vizGivenNames;
@property (nonatomic, nullable, strong) ALUniversalIDField *vizSurname;
@end

/// Contains all the supported field scan options for ID front cards.
@interface ALLayoutIDFront : NSObject
@property (nonatomic, nullable, strong) ALUniversalIDField *additionalInformation;
@property (nonatomic, nullable, strong) ALUniversalIDField *additionalInformation1;
@property (nonatomic, nullable, strong) ALUniversalIDField *address;
@property (nonatomic, nullable, strong) ALUniversalIDField *age;
@property (nonatomic, nullable, strong) ALUniversalIDField *authority;
@property (nonatomic, nullable, strong) ALUniversalIDField *cardAccessNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *citizenship;
@property (nonatomic, nullable, strong) ALUniversalIDField *cityNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfIssue;
@property (nonatomic, nullable, strong) ALUniversalIDField *dateOfRegistration;
@property (nonatomic, nullable, strong) ALUniversalIDField *divisionNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *documentNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *familyName;
@property (nonatomic, nullable, strong) ALUniversalIDField *fathersName;
@property (nonatomic, nullable, strong) ALUniversalIDField *firstName;
@property (nonatomic, nullable, strong) ALUniversalIDField *folio;
@property (nonatomic, nullable, strong) ALUniversalIDField *fullName;
@property (nonatomic, nullable, strong) ALUniversalIDField *givenNames;
@property (nonatomic, nullable, strong) ALUniversalIDField *height;
@property (nonatomic, nullable, strong) ALUniversalIDField *lastName;
@property (nonatomic, nullable, strong) ALUniversalIDField *licenseClass;
@property (nonatomic, nullable, strong) ALUniversalIDField *licenseType;
@property (nonatomic, nullable, strong) ALUniversalIDField *municipalityNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *nationalID;
@property (nonatomic, nullable, strong) ALUniversalIDField *nationality;
@property (nonatomic, nullable, strong) ALUniversalIDField *parentsGivenName;
@property (nonatomic, nullable, strong) ALUniversalIDField *personalNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *placeAndDateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *placeOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDField *sex;
@property (nonatomic, nullable, strong) ALUniversalIDField *stateNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *supportNumber;
@property (nonatomic, nullable, strong) ALUniversalIDField *surname;
@property (nonatomic, nullable, strong) ALUniversalIDField *voterID;
@end

/// Configuration for scanning Vehicle Registration Certificates
@interface ALVehicleRegistrationCertificateConfig : NSObject
@property (nonatomic, nullable, strong) ALLayoutVehicleRegistrationCertificate *vehicleRegistrationCertificate;
@end

/// Contains all the supported field scan options for vehicle registration certificates.
@interface ALLayoutVehicleRegistrationCertificate : NSObject
/// The Address Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *address;
/// The Brand Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *brand;
/// The Displacement Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *displacement;
/// The DocumentNumber Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *documentNumber;
/// The FirstIssued Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *firstIssued;
/// The FirstName Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *firstName;
/// The LastName Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *lastName;
/// The LicensePlate Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *licensePlate;
/// The ManufacturerCode Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *manufacturerCode;
/// The Tire Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *tire;
/// The VehicleIdentificationNumber Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *vehicleIdentificationNumber;
/// The VehicleType Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *vehicleType;
/// The VehicleTypeCode Field
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateField *vehicleTypeCode;
@end

/// The Address Field
///
/// Configures scanning options per field
///
/// The Brand Field
///
/// The Displacement Field
///
/// The DocumentNumber Field
///
/// The FirstIssued Field
///
/// The FirstName Field
///
/// The LastName Field
///
/// The LicensePlate Field
///
/// The ManufacturerCode Field
///
/// The Tire Field
///
/// The VehicleIdentificationNumber Field
///
/// The VehicleType Field
///
/// The VehicleTypeCode Field
@interface ALVehicleRegistrationCertificateField : NSObject
/// Set the minConfidence between 0 and 100. Otherwise, it's defaulted.
@property (nonatomic, nullable, strong) NSNumber *minConfidence;
/// Set the scanOption to one of the following: 0 = mandatory, 1 = optional, 2 = disabled.
/// Otherwise, it's defaulted.
@property (nonatomic, nullable, strong) NSNumber *scanOption;
@end

/// Configuration for scanning vehicle identification numbers (VIN)
@interface ALVinConfig : NSObject
/// Restricts the scanner to a set of characters to be detected.
@property (nonatomic, nullable, copy) NSString *charWhitelist;
/// Sets a regular expression which the scanned text needs to match in order to trigger a
/// scan result.
@property (nonatomic, nullable, copy) NSString *validationRegex;
@end

NS_ASSUME_NONNULL_END
