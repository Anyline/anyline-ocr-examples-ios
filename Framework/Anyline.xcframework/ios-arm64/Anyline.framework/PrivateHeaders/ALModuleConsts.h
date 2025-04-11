/**
 *  MARK: Common Constants
 */
extern NSString * const kFileTypeJSon;
extern NSString * const kFileTypeTraineddata;

extern NSString * const kScriptReportImageKey;
extern NSString * const kScriptReportIsValidKey;

extern NSString * const kScriptReportBrightnessKey;

extern NSString * const kFileTypeWav;
extern NSString * const kFolderSounds;

extern NSString * const kBeepFilename;

/**
 *  MARK: Meter Scanning Constants
 */
extern NSString * const kScriptMeterMinDigitsKey;
extern NSString * const kScriptMeterMaxDigitsKey;
extern NSString * const kScriptMeterHasWhiteBackKey;
extern NSString * const kScriptMeterFilterSettingsKey;
extern NSString * const kScriptMeterFilterSettingsDefaultKey;
extern NSString * const kScriptMeterFilterSettingsGasKey;

extern NSString * const kScriptMeterTypeKey;
extern NSString * const kScriptResultKey;

extern NSString * const kMeterScanAnalogFilename;
extern NSString * const kEnergySerialScriptFilename;
extern NSString * const kWaterMeterWhiteBackgroundScriptFilename;
extern NSString * const kWaterMeterBlackBackgroundScriptFilename;
extern NSString * const kMeterScanScriptFilename;
extern NSString * const kMeterSelectScanScriptFilename;
extern NSString * const kDigitalMeterScriptFilename;
extern NSString * const kAutoAnalogDigitalMeterScriptFilename;
extern NSString * const kDigitalMeterExperimentalScriptFilename;
extern NSString * const kHeatMeterScriptFilename;
extern NSString * const kDialMeterScriptFilename;
extern NSString * const kDotMatrixMeterScriptFilename;

extern NSString * const kAnalogUIConfigFilename;
extern NSString * const kGasUIConfigFilename;
extern NSString * const kPowerUIConfigFilename;
extern NSString * const kPower4UIConfigFilename;
extern NSString * const kWaterBlackBackgroundUIConfigFilename;
extern NSString * const kWaterWhiteBackgroundUIConfigFilename;
extern NSString * const kSerialUIConfigFilename;
extern NSString * const kDigitalUIConfigFilename;
extern NSString * const kHeatUIConfigFilename;
extern NSString * const kAutoAnalogDigitalUIConfigFilename;
extern NSString * const kDialMeterUIConfigFilename;
extern NSString * const kDotMatrixMeterUIConfigFilename;

extern NSString * const kAnylineMeterScanningResources;

/**
 *  MARK: Barcode Constants
 */
extern NSString * const kBarcodeStringKey;
extern NSString * const kBarcodeFormatKey;
extern NSString * const kBarcodeBase64Key;
extern NSString * const kBarcodeCoordinatesKey;
extern NSString * const kBarcodePDF417ParsedKey;

extern NSString * const kBarcodeScriptFilename;
extern NSString * const kAdvancedBarcodeScriptFilename;
extern NSString * const kBarcodeUIConfigFilename;

extern NSString * const kAnylineBarcodeScanningResources;

extern NSString * const kBarcodeCoordinates;

/**
 *  MARK: SimpleOCR Constants
 */
extern NSString * const kSimpleOCRScriptLineFilename;
extern NSString * const kSimpleOCRScriptGridFilename;
extern NSString * const kSimpleOCRScriptAutoFilename;
extern NSString * const kSimpleOCRUIConfigFilename;

extern NSString * const kAnylineSimpleOCRScanningResources;

extern NSString * const kScriptOCRResultKey;
//Use Case specific File names (VIN, Container, CattleTag)
extern NSString * const kVINScriptFilename;
extern NSString * const kVINModelFilename;
extern NSString * const kContainerScriptFilename;
extern NSString * const kContainerVerticalScriptFilename;
extern NSString * const kCattleTagScriptFilename;

//OCR Config JSON keys
extern NSString * const kCharWhitelist;
extern NSString * const kValidationRegex;


/**
 *  MARK: SimpleTire Constants
 */

extern NSString * const kAnylineSimpleTireScanningResources;
extern NSString * const kTINScriptFilename;
extern NSString * const kUniversalTINScriptFilename;
extern NSString * const kTireSizeScriptFilename;
extern NSString * const kCommercialTireIdScriptFilename;

/**
 *  MARK: ID Constants
 */
extern NSString * const kAnylineIDScanningResources;


//ID File Name Constants
extern NSString * const kMRZScriptFilename;
extern NSString * const kTemplateScriptFilename;
extern NSString * const kTemplateArabicScriptFilename;
extern NSString * const kJapaneseLandingPermissionFilename;
extern NSString * const kVehicleRegistrationCertificateFilename;

//MRZ Constants
extern NSString * const kMRZSurnameKey;
extern NSString * const kMRZGivenNamesKey;
extern NSString * const kMRZDateOfBirthKey;
extern NSString * const kMRZDateOfExpiryKey;
extern NSString * const kMRZDocumentNumberKey;
extern NSString * const kMRZDocumentTypeKey;
extern NSString * const kMRZIssuingCountryCodeKey;
extern NSString * const kMRZNationalityCountryCodeKey;
extern NSString * const kMRZSexKey;
extern NSString * const kMRZPersonalNumberKey;
extern NSString * const kMRZOptionalDataKey;
extern NSString * const kMRZCheckDigitDateOfExpiryKey;
extern NSString * const kMRZCheckDigitDocumentNumberKey;
extern NSString * const kMRZCheckDigitDateOfBirthKey;
extern NSString * const kMRZCheckDigitFinalKey;
extern NSString * const kMRZtringKey;
extern NSString * const kMRZCheckDigitPersonalNumberKey;
extern NSString * const kMRZAllCheckDigitsValidKey;
//Formated Date Fields
extern NSString * const kMRZFormattedDateOfBirthKey;
extern NSString * const kMRZFormattedDateOfExpiryKey;
extern NSString * const kMRZFormattedVizDateOfIssueKey;
extern NSString * const kMRZFormattedVizDateOfBirthKey;
extern NSString * const kMRZFormattedVizDateOfExpiryKey;

//MRZ+ / VIZ Fields
extern NSString * const kMRZVizAddressKey;
extern NSString * const kMRZVizDateOfIssueKey;
extern NSString * const kMRZVizSurnameKey;
extern NSString * const kMRZVizGivenNamesKey;
extern NSString * const kMRZVizDateOfBirthKey;
extern NSString * const kMRZVizDateOfExpiryKey;

/**
 * MARK: License Plate Costants
 */
extern NSString * const kAnylineLicensePlateScanningResources;
extern NSString * const kLicensePlateScriptFilename;
extern NSString * const kLicensePlateAfricaScriptFilename;
extern NSString * const kLicensePlateUnitedStatesScriptFilename;

extern NSString * const kLicensePlateString;
extern NSString * const kLicensePlateCountryString;
extern NSString * const kLicensePlateAreaString;

extern NSString * const kLicensePlateUIConfigFilename;

/**
 *  MARK: Debitcard Constants
 */
extern NSString * const kDebitcardScriptFilename;
extern NSString * const kDebitcardUIConfigFilename;

extern NSString * const kAnylineDebitcardScanningResources;

extern NSString * const kDebitcardUseContrastThresholdKey;
extern NSString * const kDebitcardResultCountKey;

extern NSString * const kDebitcardCardholderNameKey;
extern NSString * const kDebitcardIbanKey;
extern NSString * const kDebitcardBicKey;



/**
 *  MARK: Document Constants
 */

extern NSString * const kAnylineDocumentUIConfigFilename;
extern NSString * const kAnylineDocumentScanningResources;
extern NSString * const kDocumentScriptFilename;
extern NSString * const kDocumentResizeWidth;
extern NSString * const kDocumentContourBorder;
extern NSString * const kDocumentShapeAndBrightnessValid;
extern NSString * const kDocumentScanFullResolution;
extern NSString * const kDocumentFullResizeWidth;
extern NSString * const kDocumentIsSharp;
extern NSString * const kDocumentResult;
extern NSString * const kDocumentIsSharpKey;
extern NSString * const kDocumentOutline;
extern NSString * const kDocumentTransformedImage;
extern NSString * const kDocumentAnglesValid;
extern NSString * const kDocumentAnglesValidKey;
extern NSString * const kDocumentPictureImage;
extern NSString * const kDocumentImage;
extern NSString * const kDocumentPreviewImageCropped;
extern NSString * const kDocumentBrightnessValid;
extern NSString * const kDocumentSquare;


/**
 * MARK: product names
 */

extern NSString * const kProductBarcode;
extern NSString * const kProductMeter;
extern NSString * const kProductDialMeter;
extern NSString * const kProductUniversalId;
extern NSString * const kProductJapaneseLandingPermission;
extern NSString * const kProductVehicleRegistrationCertificate;
extern NSString * const kProductMrz;
extern NSString * const kProductDrivingLicense;
extern NSString * const kProductVin;
extern NSString * const kProductContainerHorizontal;
extern NSString * const kProductContainerVertical;
extern NSString * const kProductLicensePlate;
extern NSString * const kProductDocument;
extern NSString * const kProductOcr;
extern NSString * const kProductTin;
extern NSString * const kProductTireSize;
extern NSString * const kProductCommercialTireId;

/**
 *  MARK: UI Constrants
 */
extern NSString * const kAnylineUiResources;


extern NSString * const kImageProvider;
extern NSString * const kCustomUI;
extern NSString * const kParallelScanning;
extern NSString * const kSerialScanning;

extern NSString * const kEnergyPlugin;
extern NSString * const kAnalog;
extern NSString * const kDigital;
extern NSString * const kParallelBarcode;
extern NSString * const kAnalogDigitalAuto;
extern NSString * const kDotMatrix;
extern NSString * const kSerialNumber;

extern NSString * const kIDPlugin;
extern NSString * const kMRZ;
extern NSString * const kDrivingLicense;
extern NSString * const kNationalID;
extern NSString * const kIdRectification;

extern NSString * const kDocumentPlugin;
extern NSString * const kLPTPlugin;
extern NSString * const kLicensePlate;
extern NSString * const kTwoLines;

extern NSString * const kOCRPlugin;
extern NSString * const kTirePlugin;
extern NSString * const kConfig;
extern NSString * const kOCRConfig;
extern NSString * const kVINConfig;
extern NSString * const kTINConfig;
extern NSString * const kContainerConfig;
extern NSString * const kCattleTagConfig;
extern NSString * const kECARDConfig;

extern NSString * const kEUIdentifier;
extern NSString * const kContainerIdentifier;

