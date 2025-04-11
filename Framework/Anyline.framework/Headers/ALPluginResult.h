// To parse this JSON:
//
//   NSError *error;
//   ALPluginResult *pluginResult = [ALPluginResult fromJSON:json encoding:NSUTF8Encoding error:&error];

#import <Foundation/Foundation.h>

@class ALPluginResult;
@class ALBarcodeResult;
@class ALBarcode;
@class ALAamva;
@class ALBodyPart;
@class ALCommercialTireIDResult;
@class ALContainerResult;
@class ALCropRect;
@class ALJapaneseLandingPermissionResult;
@class ALJlpResult;
@class ALJapaneseLandingPermissionResultField;
@class ALLicensePlateResult;
@class ALArea;
@class ALMeterResult;
@class ALMrzResult;
@class ALFieldConfidences;
@class ALOcrResult;
@class ALOdometerResult;
@class ALTinResult;
@class ALTireMakeResult;
@class ALTireSizeResult;
@class ALTireSizeResultField;
@class ALUniversalIDResult;
@class ALIDResult;
@class ALUniversalIDResultField;
@class ALDateValue;
@class ALTextValues;
@class ALArabic;
@class ALCyrillic;
@class ALLatin;
@class ALVisualization;
@class ALVehicleRegistrationCertificateResult;
@class ALVrcResult;
@class ALVehicleRegistrationCertificateResultField;
@class ALVinResult;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Boxed enums

/// The area information
@interface ALArea : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALArea *)alabama;
+ (ALArea *)alaska;
+ (ALArea *)alberta;
+ (ALArea *)americanSamoa;
+ (ALArea *)arizona;
+ (ALArea *)arkansas;
+ (ALArea *)britishColumbia;
+ (ALArea *)california;
+ (ALArea *)colorado;
+ (ALArea *)connecticut;
+ (ALArea *)delaware;
+ (ALArea *)districtOfColumbia;
+ (ALArea *)florida;
+ (ALArea *)georgia;
+ (ALArea *)guam;
+ (ALArea *)hawaii;
+ (ALArea *)idaho;
+ (ALArea *)illinois;
+ (ALArea *)indiana;
+ (ALArea *)iowa;
+ (ALArea *)kansas;
+ (ALArea *)kentucky;
+ (ALArea *)louisiana;
+ (ALArea *)maine;
+ (ALArea *)manitoba;
+ (ALArea *)maryland;
+ (ALArea *)massachusetts;
+ (ALArea *)michigan;
+ (ALArea *)minnesota;
+ (ALArea *)mississippi;
+ (ALArea *)missouri;
+ (ALArea *)montana;
+ (ALArea *)nebraska;
+ (ALArea *)nevada;
+ (ALArea *)newBrunswick;
+ (ALArea *)newHampshire;
+ (ALArea *)newJersey;
+ (ALArea *)newMexico;
+ (ALArea *)newYork;
+ (ALArea *)northCarolina;
+ (ALArea *)northDakota;
+ (ALArea *)novaScotia;
+ (ALArea *)ohio;
+ (ALArea *)oklahoma;
+ (ALArea *)ontario;
+ (ALArea *)oregon;
+ (ALArea *)pennsylvania;
+ (ALArea *)puertoRico;
+ (ALArea *)quebec;
+ (ALArea *)rhodeIsland;
+ (ALArea *)saskatchewan;
+ (ALArea *)southCarolina;
+ (ALArea *)southDakota;
+ (ALArea *)tennessee;
+ (ALArea *)texas;
+ (ALArea *)utah;
+ (ALArea *)vermont;
+ (ALArea *)virginia;
+ (ALArea *)washington;
+ (ALArea *)westVirginia;
+ (ALArea *)wisconsin;
+ (ALArea *)wyoming;
@end

#pragma mark - Object interfaces

/// Describes all kinds of scan results
@interface ALPluginResult : NSObject
@property (nonatomic, nullable, strong) ALBarcodeResult *barcodeResult;
/// The blobKey (provided optionally, depending on the Anyline license settings)
@property (nonatomic, nullable, copy)   NSString *blobKey;
@property (nonatomic, nullable, strong) ALCommercialTireIDResult *commercialTireIDResult;
/// Provides a general confidence value between 0 and 100 if applicable. -1 if no confidence
/// was calculated
@property (nonatomic, assign)           NSInteger confidence;
@property (nonatomic, nullable, strong) ALContainerResult *containerResult;
/// The rect information of the region that was processed within the image
@property (nonatomic, nullable, strong) ALCropRect *cropRect;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionResult *japaneseLandingPermissionResult;
@property (nonatomic, nullable, strong) ALLicensePlateResult *licensePlateResult;
@property (nonatomic, nullable, strong) ALMeterResult *meterResult;
@property (nonatomic, nullable, strong) ALMrzResult *mrzResult;
@property (nonatomic, nullable, strong) ALOcrResult *ocrResult;
@property (nonatomic, nullable, strong) ALOdometerResult *odometerResult;
/// The ID of the ScanPlugin that processed the result
@property (nonatomic, copy)             NSString *pluginID;
@property (nonatomic, nullable, strong) ALTinResult *tinResult;
@property (nonatomic, nullable, strong) ALTireMakeResult *tireMakeResult;
@property (nonatomic, nullable, strong) ALTireSizeResult *tireSizeResult;
/// A unique UUIDv4 generated for each scan controller process run.
@property (nonatomic, copy)             NSString *transactionID;
@property (nonatomic, nullable, strong) ALUniversalIDResult *universalIDResult;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResult *vehicleRegistrationCertificateResult;
@property (nonatomic, nullable, strong) ALVinResult *vinResult;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

/// Describes result information of scanning barcodes
@interface ALBarcodeResult : NSObject
/// Contains a list of one or more barcodes found on the processed image
@property (nonatomic, copy) NSArray<ALBarcode *> *barcodes;
@end

/// Describes barcode information
@interface ALBarcode : NSObject
@property (nonatomic, nullable, strong) ALAamva *aamva;
/// Contains the base64-encoded value
@property (nonatomic, nullable, copy) NSString *base64Value;
/// Corner points of a polygon surrounding the discovered barcode, starting from the
/// bottom-left coordinate going counter-clockwise. The coordinates are in reference to the
/// image of the plugin result.
@property (nonatomic, nullable, copy) NSArray<NSNumber *> *coordinates;
/// The barcode format
@property (nonatomic, copy) NSString *format;
/// The value of the barcode
@property (nonatomic, copy) NSString *value;
@end

/// Holds all encoded barcode information according to the AAMVA standard
@interface ALAamva : NSObject
@property (nonatomic, nullable, strong) NSNumber *aamvaVersion;
@property (nonatomic, nullable, strong) ALBodyPart *bodyPart;
@end

@interface ALBodyPart : NSObject
@property (nonatomic, nullable, copy) NSString *auditInformation;
@property (nonatomic, nullable, copy) NSString *cardRevisionDate;
@property (nonatomic, nullable, copy) NSString *city;
@property (nonatomic, nullable, copy) NSString *complianceType;
@property (nonatomic, nullable, copy) NSString *countryID;
@property (nonatomic, nullable, copy) NSString *customerIDNumber;
@property (nonatomic, nullable, copy) NSString *dateOfBirth;
@property (nonatomic, nullable, copy) NSString *dateOfExpiry;
@property (nonatomic, nullable, copy) NSString *dateOfIssue;
@property (nonatomic, nullable, copy) NSString *documentDiscriminator;
@property (nonatomic, nullable, copy) NSString *drivingPrivilege;
@property (nonatomic, nullable, copy) NSString *endorsementCode;
@property (nonatomic, nullable, copy) NSString *eyes;
@property (nonatomic, nullable, copy) NSString *firstName;
@property (nonatomic, nullable, copy) NSString *firstNameTruncated;
@property (nonatomic, nullable, copy) NSString *hair;
@property (nonatomic, nullable, copy) NSString *height;
@property (nonatomic, nullable, copy) NSString *inventoryControlNumber;
@property (nonatomic, nullable, copy) NSString *jurisdictionCode;
@property (nonatomic, nullable, copy) NSString *lastName;
@property (nonatomic, nullable, copy) NSString *lastNameTruncated;
@property (nonatomic, nullable, copy) NSString *licenseClass;
@property (nonatomic, nullable, copy) NSString *middleName;
@property (nonatomic, nullable, copy) NSString *middleNameTruncated;
@property (nonatomic, nullable, copy) NSString *postalCode;
@property (nonatomic, nullable, copy) NSString *sex;
@property (nonatomic, nullable, copy) NSString *street;
@end

/// Describes result information of scanning commercial tire IDs
@interface ALCommercialTireIDResult : NSObject
/// The text value of the commercial tire ID
@property (nonatomic, nullable, copy) NSString *text;
@end

/// Describes result information of scanning shipping containers
@interface ALContainerResult : NSObject
/// The text value of the shipping container
@property (nonatomic, nullable, copy) NSString *text;
@end

/// The rect information of the region that was processed within the image
@interface ALCropRect : NSObject
/// The height
@property (nonatomic, assign) NSInteger height;
/// The width
@property (nonatomic, assign) NSInteger width;
/// The X value
@property (nonatomic, assign) NSInteger x;
/// The Y value
@property (nonatomic, assign) NSInteger y;
@end

/// Describes result information of scanning japanese landing permission tickets
@interface ALJapaneseLandingPermissionResult : NSObject
/// Yields field information of a japanese landing permission ticket
@property (nonatomic, strong) ALJlpResult *result;
@end

/// Yields field information of a japanese landing permission ticket
@interface ALJlpResult : NSObject
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionResultField *airport;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionResultField *dateOfExpiry;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionResultField *dateOfIssue;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionResultField *duration;
@property (nonatomic, nullable, strong) ALJapaneseLandingPermissionResultField *status;
@end

/// Provides result information for japanese landing permission fields
@interface ALJapaneseLandingPermissionResultField : NSObject
/// The confidence information of the field
@property (nonatomic, assign) NSInteger confidence;
/// The text information of the field
@property (nonatomic, copy) NSString *text;
@end

/// Describes result information of scanning license plates
@interface ALLicensePlateResult : NSObject
/// The area information
@property (nonatomic, nullable, assign) ALArea *area;
/// The country information
@property (nonatomic, copy) NSString *country;
/// The plate text
@property (nonatomic, copy) NSString *plateText;
/// (Optional) If vehicleInspectionSticker config is OPTIONAL, this is true if a Visual
/// Inspection Sticker was found, false otherwise. If the config is MANDATORY, this field is
/// always true.
@property (nonatomic, nullable, strong) NSNumber *vehicleInspectionFound;
/// (Optional) The month depicted on the Visual Inspection Sticker.
@property (nonatomic, nullable, copy) NSString *vehicleInspectionMonth;
/// (Optional) This is true, if the Visual Inspection Sticker depicts a date in the future.
@property (nonatomic, nullable, strong) NSNumber *vehicleInspectionValid;
/// (Optional) The year depicted on the Visual Inspection Sticker.
@property (nonatomic, nullable, copy) NSString *vehicleInspectionYear;
@end

/// Describes result information of scanning meters
@interface ALMeterResult : NSObject
/// The position. Only applicable for OBIS meters - see https://onemeter.com/docs/device/obis/
@property (nonatomic, nullable, copy) NSString *position;
/// The unit value. Only applicable for multi-field meter scanning.
@property (nonatomic, nullable, copy) NSString *unit;
/// The meter value.
@property (nonatomic, copy) NSString *value;
@end

/// Describes result information of scanning MRZ
@interface ALMrzResult : NSObject
/// True if all check digits are valid
@property (nonatomic, assign) BOOL allCheckDigitsValid;
/// The CheckDigitDateOfBirth
@property (nonatomic, copy) NSString *checkDigitDateOfBirth;
/// The CheckDigitDateOfExpiry
@property (nonatomic, copy) NSString *checkDigitDateOfExpiry;
/// The CheckDigitDocumentNumber
@property (nonatomic, copy) NSString *checkDigitDocumentNumber;
/// The CheckDigitFinal
@property (nonatomic, copy) NSString *checkDigitFinal;
/// The CheckDigitPersonalNumber
@property (nonatomic, copy) NSString *checkDigitPersonalNumber;
/// The DateOfBirth
@property (nonatomic, copy) NSString *dateOfBirth;
/// The DateOfBirthObject
@property (nonatomic, copy) NSString *dateOfBirthObject;
/// The DateOfExpiry
@property (nonatomic, copy) NSString *dateOfExpiry;
/// The DateOfExpiryObject
@property (nonatomic, copy) NSString *dateOfExpiryObject;
/// The DocumentNumber
@property (nonatomic, copy) NSString *documentNumber;
/// The DocumentType
@property (nonatomic, copy) NSString *documentType;
/// The confidence values of each field
@property (nonatomic, nullable, strong) ALFieldConfidences *fieldConfidences;
/// The FirstName
@property (nonatomic, nullable, copy) NSString *firstName;
/// The GivenNames
@property (nonatomic, nullable, copy) NSString *givenNames;
/// The IssuingCountryCode
@property (nonatomic, copy) NSString *issuingCountryCode;
/// The LastName
@property (nonatomic, nullable, copy) NSString *lastName;
/// The MRZString
@property (nonatomic, copy) NSString *mrzString;
/// The NationalityCountryCode
@property (nonatomic, copy) NSString *nationalityCountryCode;
/// The OptionalData
@property (nonatomic, nullable, copy) NSString *optionalData;
/// The PersonalNumber
@property (nonatomic, copy) NSString *personalNumber;
/// The Sex
@property (nonatomic, copy) NSString *sex;
/// The Surname
@property (nonatomic, nullable, copy) NSString *surname;
/// The Adress of the Visual Inspection Zone
@property (nonatomic, nullable, copy) NSString *vizAddress;
/// The DateOfBirth of the Visual Inspection Zone
@property (nonatomic, nullable, copy) NSString *vizDateOfBirth;
/// The DateOfBirthObject of the Visual Inspection Zone
@property (nonatomic, nullable, copy) NSString *vizDateOfBirthObject;
/// The DateOfExpiry of the Visual Inspection Zone
@property (nonatomic, nullable, copy) NSString *vizDateOfExpiry;
/// The DateOfExpiryObject of the Visual Inspection Zone
@property (nonatomic, nullable, copy) NSString *vizDateOfExpiryObject;
/// The DateOfIssue of the Visual Inspection Zone
@property (nonatomic, nullable, copy) NSString *vizDateOfIssue;
/// The DateOfIssueObject of the Visual Inspection Zone
@property (nonatomic, nullable, copy) NSString *vizDateOfIssueObject;
/// The GivenNames of the Visual Inspection Zone
@property (nonatomic, nullable, copy) NSString *vizGivenNames;
/// The Surname of the Visual Inspection Zone
@property (nonatomic, nullable, copy) NSString *vizSurname;
@end

/// The confidence values of each field
@interface ALFieldConfidences : NSObject
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

/// Describes result information of scanning general OCR
@interface ALOcrResult : NSObject
/// The OCR text value.
@property (nonatomic, nullable, copy) NSString *text;
@end

/// Describes result information of scanning odometers
@interface ALOdometerResult : NSObject
/// The odometer value.
@property (nonatomic, copy) NSString *value;
@end

/// Describes result information of scanning tire identification numbers (TIN)
@interface ALTinResult : NSObject
/// The production date on the TIN reformatted to YYYY/MM.
@property (nonatomic, nullable, copy) NSString *productionDate;
/// The TIN text split by context with spaces as delimiter.
@property (nonatomic, nullable, copy) NSString *resultPrettified;
/// The TIN text value.
@property (nonatomic, copy) NSString *text;
/// The computed tire age in years rounded down.
@property (nonatomic, nullable, strong) NSNumber *tireAgeInYearsRoundedDown;
@end

/// Describes result information of scanning tire makes
@interface ALTireMakeResult : NSObject
/// The text value of the tire make
@property (nonatomic, nullable, copy) NSString *text;
@end

/// Describes result information of scanning tire size specifications
@interface ALTireSizeResult : NSObject
@property (nonatomic, nullable, strong) ALTireSizeResultField *commercialTire;
@property (nonatomic, nullable, strong) ALTireSizeResultField *construction;
@property (nonatomic, nullable, strong) ALTireSizeResultField *diameter;
@property (nonatomic, nullable, strong) ALTireSizeResultField *extraLoad;
@property (nonatomic, nullable, strong) ALTireSizeResultField *loadIndex;
@property (nonatomic, nullable, strong) ALTireSizeResultField *prettifiedString;
@property (nonatomic, nullable, strong) ALTireSizeResultField *prettifiedStringWithMeta;
@property (nonatomic, nullable, strong) ALTireSizeResultField *ratio;
@property (nonatomic, nullable, strong) ALTireSizeResultField *speedRating;
@property (nonatomic, nullable, strong) ALTireSizeResultField *text;
@property (nonatomic, nullable, strong) ALTireSizeResultField *vehicleType;
@property (nonatomic, nullable, strong) ALTireSizeResultField *width;
@property (nonatomic, nullable, strong) ALTireSizeResultField *winter;
@end

@interface ALTireSizeResultField : NSObject
/// The confidence value of the tire size field.
@property (nonatomic, nullable, strong) NSNumber *confidence;
/// The text value of the tire size field.
@property (nonatomic, nullable, copy) NSString *text;
@end

/// Describes result information of scanning different kinds of IDs
@interface ALUniversalIDResult : NSObject
/// Yields field information of the ID
@property (nonatomic, strong)           ALIDResult *result;
@property (nonatomic, nullable, strong) ALVisualization *visualization;
@end

/// Yields field information of the ID
@interface ALIDResult : NSObject
@property (nonatomic, nullable, strong) ALUniversalIDResultField *additionalInformation;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *additionalInformation1;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *additionalInformation2;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *additionalInformation3;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *address;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *age;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *airport;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *allCheckDigitsValid;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *audit;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *authority;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *barcode;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *bloodType;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *cardAccessNumber;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *checkDigitDateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *checkDigitDateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *checkDigitDocumentNumber;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *checkDigitFinal;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *checkDigitPersonalNumber;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *cityNumber;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *conditions;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *country;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *dateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *dateOfBirthObject;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *dateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *dateOfExpiryObject;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *dateOfIssue;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *dateOfRegistration;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *degreeOfDisability;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *divisionNumber;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *documentCategoryDefinition;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *documentDiscriminator;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *documentNumber;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *documentRegionDefinition;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *documentSideDefinition;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *documentType;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *documentTypeDefinition;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *documentVersionsDefinition;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *duplicate;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *duration;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *educationalInstitution;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *employer;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *endorsements;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *eyes;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *face;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *familyNumber;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *familyRelation;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *fathersName;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *firstIssued;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *firstName;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *folio;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *formattedDateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *formattedDateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *formattedDateOfIssue;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *fullName;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *givenNames;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *hair;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *headOfFamily;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *height;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *hologram;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *initials;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *initialsAndDateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *issuingCountryCode;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *lastName;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *licenseClass;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *licenseType;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *maidenName;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *militaryRank;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *mirrorNumber;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *mothersName;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *mrz;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *mrzString;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *municipalityNumber;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *nationality;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *nationalityCountryCode;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *occupation;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *office;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *optionalData;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *parentsFirstName;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *parish;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *personalNumber;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *placeAndDateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *placeOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *previousType;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *pseudonym;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *religion;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *restrictions;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *sex;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *signature;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *socialSecurityNumber;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *state;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *stateNumber;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *status;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *surname;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *vizAddress;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *vizDateOfBirth;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *vizDateOfBirthObject;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *vizDateOfExpiry;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *vizDateOfExpiryObject;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *vizDateOfIssue;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *vizDateOfIssueObject;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *vizGivenNames;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *vizSurname;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *voterID;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *weight;
@property (nonatomic, nullable, strong) ALUniversalIDResultField *workPermitNumber;
@end

/// Describes scanned parameters of an ID field
@interface ALUniversalIDResultField : NSObject
/// Describes the date value of an ID field
@property (nonatomic, nullable, strong) ALDateValue *dateValue;
/// Describes the text values of an ID field
@property (nonatomic, strong) ALTextValues *textValues;
@end

/// Describes the date value of an ID field
@interface ALDateValue : NSObject
/// The confidence value
@property (nonatomic, assign) NSInteger confidence;
/// The day
@property (nonatomic, assign) NSInteger day;
/// The formatted text value
@property (nonatomic, copy) NSString *formattedText;
/// The month
@property (nonatomic, assign) NSInteger month;
/// The text value
@property (nonatomic, copy) NSString *text;
/// The year
@property (nonatomic, assign) NSInteger year;
@end

/// Describes the text values of an ID field
@interface ALTextValues : NSObject
/// The text parameters
@property (nonatomic, nullable, strong) ALArabic *arabic;
/// The text parameters
@property (nonatomic, nullable, strong) ALCyrillic *cyrillic;
/// The text parameters
@property (nonatomic, nullable, strong) ALLatin *latin;
@end

/// The text parameters
@interface ALArabic : NSObject
/// The confidence value
@property (nonatomic, assign) NSInteger confidence;
/// The text value
@property (nonatomic, copy) NSString *text;
@end

/// The text parameters
@interface ALCyrillic : NSObject
/// The confidence value
@property (nonatomic, assign) NSInteger confidence;
/// The text value
@property (nonatomic, copy) NSString *text;
@end

/// The text parameters
@interface ALLatin : NSObject
/// The confidence value
@property (nonatomic, assign) NSInteger confidence;
/// The text value
@property (nonatomic, copy) NSString *text;
@end

/// Information about the visualization data of the scanned ID
@interface ALVisualization : NSObject
/// The found contour points of the fields on the ID
@property (nonatomic, nullable, copy) NSArray<NSArray<NSArray<NSNumber *> *> *> *contourPoints;
/// The found contours of the fields on the ID
@property (nonatomic, copy) NSArray<NSArray<NSNumber *> *> *contours;
/// The found bounding rect of the text fields on the ID
@property (nonatomic, copy) NSArray<NSNumber *> *textRect;
@end

/// Describes result information of scanning vehicle registration certificates
@interface ALVehicleRegistrationCertificateResult : NSObject
/// Yields field information of the vehicle registration certificate
@property (nonatomic, strong) ALVrcResult *result;
@property (nonatomic, strong) ALVisualization *visualization;
@end

/// Yields field information of the vehicle registration certificate
@interface ALVrcResult : NSObject
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *address;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *brand;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *displacement;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *documentCategoryDefinition;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *documentNumber;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *documentRegionDefinition;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *documentSideDefinition;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *documentTypeDefinition;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *documentVersionsDefinition;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *firstIssued;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *firstName;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *formattedFirstIssued;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *lastName;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *licensePlate;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *manufacturerCode;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *tire;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *vehicleIdentificationNumber;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *vehicleType;
@property (nonatomic, nullable, strong) ALVehicleRegistrationCertificateResultField *vehicleTypeCode;
@end

/// Describes scanned parameters of a vehicle registration certificate field
@interface ALVehicleRegistrationCertificateResultField : NSObject
/// The confidence value
@property (nonatomic, assign) NSInteger confidence;
/// The text value
@property (nonatomic, copy) NSString *text;
@end

/// Describes result information of scanning vehicle identification numbers (VIN)
@interface ALVinResult : NSObject
/// The VIN text value
@property (nonatomic, nullable, copy) NSString *text;
@end

NS_ASSUME_NONNULL_END
