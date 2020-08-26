//
//  ALMRZIdentification.h
//  Anyline
//
//  Created by Daniel Albertini on 20.07.18.
//  Copyright © 2018 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMRZConfig.h"

NS_ASSUME_NONNULL_BEGIN



/// The result passed to anylineIDScanPlugin:didFindResult:) from an MRZ ALIDScanPlugin
@interface ALMRZIdentification : NSObject

@property (nullable, nonatomic, strong, readonly) NSString *surname;
@property (nullable, nonatomic, strong, readonly) NSString *givenNames;
@property (nullable, nonatomic, strong, readonly) NSString *dateOfBirth;
@property (nullable, nonatomic, strong, readonly) NSString *dateOfExpiry;
@property (nullable, nonatomic, strong, readonly) NSString *documentNumber;
@property (nullable, nonatomic, strong, readonly) NSString *documentType;
@property (nullable, nonatomic, strong, readonly) NSString *issuingCountryCode;
@property (nullable, nonatomic, strong, readonly) NSString *nationalityCountryCode;
@property (nullable, nonatomic, strong, readonly) NSString *sex;
@property (nullable, nonatomic, strong, readonly) NSString *personalNumber;
@property (nullable, nonatomic, strong, readonly) NSString *optionalData;

@property (nullable, nonatomic, strong, readonly) NSString *mrzString;

@property (nullable, nonatomic, strong, readonly) NSString *vizAddress;
@property (nullable, nonatomic, strong, readonly) NSString *vizDateOfIssue;
@property (nullable, nonatomic, strong, readonly) NSString *vizSurname;
@property (nullable, nonatomic, strong, readonly) NSString *vizGivenNames;
@property (nullable, nonatomic, strong, readonly) NSString *vizDateOfBirth;
@property (nullable, nonatomic, strong, readonly) NSString *vizDateOfExpiry;

@property (nullable, nonatomic, strong) UIImage *faceImage;

//Check Digits
@property (nullable, nonatomic, strong, readonly) NSString *checkDigitDateOfExpiry;
@property (nullable, nonatomic, strong, readonly) NSString *checkDigitDocumentNumber;
@property (nullable, nonatomic, strong, readonly) NSString *checkDigitDateOfBirth;
@property (nullable, nonatomic, strong, readonly) NSString *checkDigitFinal;
@property (nullable, nonatomic, strong, readonly) NSString *checkDigitPersonalNumber;
@property (nonatomic, readonly) BOOL allCheckDigitsValid;

//Date Objects
@property (nullable, nonatomic, strong, readonly) NSDate *dateOfBirthObject;
@property (nullable, nonatomic, strong, readonly) NSDate *dateOfExpiryObject;
@property (nullable, nonatomic, strong, readonly) NSDate *vizDateOfIssueObject;
@property (nullable, nonatomic, strong, readonly) NSDate *vizDateOfBirthObject;
@property (nullable, nonatomic, strong, readonly) NSDate *vizDateOfExpiryObject;

@property (nullable, nonatomic, strong) ALMRZFieldConfidences *fieldConfidences;

/*
 *  Deprecated Properties
 */
@property (nullable, nonatomic, strong, readonly) NSString *surNames __deprecated_msg("Deprecated since Version 10. Please use the property \"surname\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *dayOfBirth __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfBirth\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *expirationDate __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfExpiry\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *checkdigitNumber __deprecated_msg("Deprecated since Version 10. Please use the property \"checkDigitDocumentNumber\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *checkdigitExpirationDate __deprecated_msg("Deprecated since Version 10. Please use the property \"checkDigitDateOfExpiry\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *checkdigitDayOfBirth __deprecated_msg("Deprecated since Version 10. Please use the property \"checkDigitDateOfBirth\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *checkdigitFinal __deprecated_msg("Deprecated since Version 10. Please use the property \"checkDigitFinal\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *issuingDate __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfIssue\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *personalNumber2 __deprecated_msg("Deprecated since Version 10. Please use the property \"optionalData\" instead.");

@property (nullable, nonatomic, strong, readonly) NSDate *expirationDateObject __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfExpiryObject\" instead.");
@property (nullable, nonatomic, strong, readonly) NSDate *dayOfBirthDateObject __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfBirthObject\" instead.");
@property (nullable, nonatomic, strong, readonly) NSDate *issuingDateObject __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfIssueObject\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *MRZString __deprecated_msg("Deprecated since Version 10. Please use the property \"mrzString\" instead.") NS_SWIFT_UNAVAILABLE("Please use the property \"mrzString\" instead. ");

@property (nullable, nonatomic, strong, readonly) NSString *dateOfIssue __deprecated_msg("Deprecated since Version 10.1. Please use the property \"vizDateOfIssue\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *address __deprecated_msg("Deprecated since Version 10.1. Please use the property \"vizAddress\" instead.");
@property (nullable, nonatomic, strong, readonly) NSDate *dateOfIssueObject __deprecated_msg("Deprecated since Version 10.1. Please use the property \"vizDateOfIssueObject\" instead.");

/// Initializes a ALIdentification object. This object is used to carry the scanned values.
/// @param surname All the surNames of the person separated by whitespace.
/// @param givenNames All the given names of the person separated by whitespace.
/// @param dateOfBirth The date of birth.
/// @param dateOfExpiry The expiration date of the passport / document.
/// @param documentNumber Passport number or document number.
/// @param documentType The type of the document that was read. (ID/P)
/// @param issuingCountryCode The issuing country code of the document.
/// @param nationalityCountryCode The nationality country code of the document.
/// @param sex The gender of the person
/// @param personalNumber Personal Number on the document. Is nil on many passports / documents.
/// @param optionalData Optional data at the discretion of the issuing state. Only available in TD1 sized MROTDs.
/// @param checkDigitDateOfExpiry Check digit for the expiration date.
/// @param checkDigitDocumentNumber Check digit for the document number.
/// @param checkDigitDateOfBirth Check digit for the day of birth.
/// @param checkDigitFinal On passports checkdigit over passport number, passport number checkdigit, date of birth, date of birth checkdigit, expiration date, expiration date checkdigit, personal number and
/// personal number checkdigit.
/// On other travel documents over document number, document number checkdigit, personal number,
/// date of birth, date of birth checkdigit, expiration date and expiration date checkdigit.
/// @param checkDigitPersonalNumber CheckDigit for the personal number. Is nil or 0 when no personal number is used.
/// Is also nil on none passport documents.
/// @param allCheckDigitsValid will return true if all checkdigits are correct
/// @param vizAddress Optional data which contains the data of the address field on a german ID, which is outside the MRZ field (VIZ = Visual Inspection Zone).
/// @param vizDateOfIssue Optional data which contains the data of the issuing date field, which is outside the MRZ field (VIZ = Visual Inspection Zone)
/// @param vizSurname Optional data which contains the data of the surname field on an ID, which is outside the MRZ field (VIZ = Visual Inspection Zone).
/// @param vizGivenNames Optional data which contains the data of the given names field on an ID, which is outside the MRZ field (VIZ = Visual Inspection Zone).
/// @param vizDateOfBirth Optional data which contains the data of the date of birth field on an ID, which is outside the MRZ field (VIZ = Visual Inspection Zone).
/// @param vizDateOfExpiry Optional data which contains the data of the date of expiry field on an ID, which is outside the MRZ field (VIZ = Visual Inspection Zone).
/// @param mrzString Contains all Information found in the MRZ as string.
/// @param formattedDateOfExpiry The dateOfExpiry in a given Format (dd.MM.yyyy). The dateOfExpiryObject will be created using this value.
/// @param formattedDateOfBirth The dateOfBirth in a given Format (dd.MM.yyyy). The dateOfBirthObject will be created using this value.
/// @param formattedVizDateOfIssue The dateOfIssue in a given Format (dd.MM.yyyy). The vizDateOfIssueObject will be created using this value.
/// @param formattedVizDateOfBirth The dateOfBirth in a given Format (dd.MM.yyyy). The vizDateOfBirthObject will be created using this value.
/// @param formattedVizDateOfExpiry The dateOExpiry in a given Format (dd.MM.yyyy). The vizDateOfExpiryObject will be created using this value.
- (instancetype _Nullable)initWithSurname:(NSString * _Nullable)surname
                               givenNames:(NSString * _Nullable)givenNames
                              dateOfBirth:(NSString * _Nullable)dateOfBirth
                             dateOfExpiry:(NSString * _Nullable)dateOfExpiry
                           documentNumber:(NSString * _Nullable)documentNumber
                             documentType:(NSString * _Nullable)documentType
                       issuingCountryCode:(NSString * _Nullable)issuingCountryCode
                   nationalityCountryCode:(NSString * _Nullable)nationalityCountryCode
                                      sex:(NSString * _Nullable)sex
                           personalNumber:(NSString * _Nullable)personalNumber
                             optionalData:(NSString * _Nullable)optionalData
                   checkDigitDateOfExpiry:(NSString * _Nullable)checkDigitDateOfExpiry
                 checkDigitDocumentNumber:(NSString * _Nullable)checkDigitDocumentNumber
                    checkDigitDateOfBirth:(NSString * _Nullable)checkDigitDateOfBirth
                          checkDigitFinal:(NSString * _Nullable)checkDigitFinal
                 checkDigitPersonalNumber:(NSString * _Nullable)checkDigitPersonalNumber
                      allCheckDigitsValid:(BOOL)allCheckDigitsValid
                               vizAddress:(NSString * _Nullable)vizAddress
                           vizDateOfIssue:(NSString * _Nullable)vizDateOfIssue
                               vizSurname:(NSString * _Nullable)vizSurname
                            vizGivenNames:(NSString * _Nullable)vizGivenNames
                           vizDateOfBirth:(NSString * _Nullable)vizDateOfBirth
                          vizDateOfExpiry:(NSString * _Nullable)vizDateOfExpiry
                                mrzString:(NSString * _Nullable)mrzString
                    formattedDateOfExpiry:(NSString * _Nullable)formattedDateOfExpiry
                     formattedDateOfBirth:(NSString * _Nullable)formattedDateOfBirth
                  formattedVizDateOfIssue:(NSString * _Nullable)formattedVizDateOfIssue
                  formattedVizDateOfBirth:(NSString * _Nullable)formattedVizDateOfBirth
                 formattedVizDateOfExpiry:(NSString * _Nullable)formattedVizDateOfExpiry;

/**
 *
 *   Initializes a ALIdentification object. This object is used to carry the scanned values.
 *
 *   @deprecated since Version 10.1. Please use initWithSurname:givenNames:dateOfBirth:dateOfExpiry:documentNumber:documentType:...:formattedVizDateOfIssue:formattedVizDateOfBirth:formattedVizDateOfExpiry: instead
 *
 *   @param surname All the surNames of the person separated by whitespace.
 *   @param givenNames All the given names of the person separated by whitespace.
 *   @param dateOfBirth              The date of birth.
 *   @param dateOfExpiry             The expiration date of the passport / document.
 *   @param documentNumber           Passport number or document number.
 *   @param documentType             The type of the document that was read. (ID/P)
 *   @param issuingCountryCode       The issuing country code of the document.
 *   @param nationalityCountryCode   The nationality country code of the document.
 *   @param sex                      The gender of the person
 *   @param personalNumber           Personal Number on the document. Is nil on many passports / documents.
 *   @param optionalData             Optional data at the discretion of the issuing state. Only available in TD1 sized MROTDs.
 *                                  Might contain additional information.
 *
 *   @param checkDigitDateOfExpiry   Check digit for the expiration date.
 *   @param checkDigitDocumentNumber Check digit for the document number.
 *   @param checkDigitDateOfBirth    Check digit for the day of birth.
 *   @param checkDigitFinal          On passports checkdigit over passport number, passport number checkdigit, date of birth,
 *                                  date of birth checkdigit, expiration date, expiration date checkdigit, personal number and
 *                                  personal number checkdigit.
 *                                  On other travel documents over document number, document number checkdigit, personal number,
 *                                  date of birth, date of birth checkdigit, expiration date and expiration date checkdigit.
 *
 *   @param checkDigitPersonalNumber CheckDigit for the personal number. Is nil or 0 when no personal number is used.
 *                                  Is also nil on none passport documents.
 *   @param allCheckDigitsValid      will return true if all checkdigits are correct
 *   @param address                  Optional data which contains the data of the address field on a german ID.
 *   @param dateOfIssue              Optional data which contains the data of the issuing date field, which is outside the MRZ field
 *
 *   @param mrzString                Contains all Information found in the MRZ as string.
 *
 *   @param formattedDateOfExpiry    The dateOfExpiry in a given Format (dd.MM.yyyy). The dateOfExpiryObject will be created using this value.
 *   @param formattedDateOfBirth     The dateOfBirth in a given Format (dd.MM.yyyy). The dateOfBirthObject will be created using this value.
 *   @param formattedDateOfIssue     The dateOfIssue in a given Format (dd.MM.yyyy). The dateOfIssueObject will be created using this value.
 *
 *   @return A new ALIdentification object
 */
- (instancetype _Nullable)initWithSurname:(NSString * _Nullable)surname
                               givenNames:(NSString * _Nullable)givenNames
                              dateOfBirth:(NSString * _Nullable)dateOfBirth
                             dateOfExpiry:(NSString * _Nullable)dateOfExpiry
                           documentNumber:(NSString * _Nullable)documentNumber
                             documentType:(NSString * _Nullable)documentType
                       issuingCountryCode:(NSString * _Nullable)issuingCountryCode
                   nationalityCountryCode:(NSString * _Nullable)nationalityCountryCode
                                      sex:(NSString * _Nullable)sex
                           personalNumber:(NSString * _Nullable)personalNumber
                             optionalData:(NSString * _Nullable)optionalData
                   checkDigitDateOfExpiry:(NSString * _Nullable)checkDigitDateOfExpiry
                 checkDigitDocumentNumber:(NSString * _Nullable)checkDigitDocumentNumber
                    checkDigitDateOfBirth:(NSString * _Nullable)checkDigitDateOfBirth
                          checkDigitFinal:(NSString * _Nullable)checkDigitFinal
                 checkDigitPersonalNumber:(NSString * _Nullable)checkDigitPersonalNumber
                      allCheckDigitsValid:(BOOL)allCheckDigitsValid
                                  address:(NSString * _Nullable)address
                              dateOfIssue:(NSString * _Nullable)dateOfIssue
                                mrzString:(NSString * _Nullable)mrzString
                    formattedDateOfExpiry:(NSString * _Nullable)formattedDateOfExpiry
                     formattedDateOfBirth:(NSString * _Nullable)formattedDateOfBirth
                     formattedDateOfIssue:(NSString * _Nullable)formattedDateOfIssue __deprecated_msg("Deprecated since Version 10.1. Please use initWithSurname:givenNames:dateOfBirth:dateOfExpiry:documentNumber:documentType:...:formattedVizDateOfIssue:formattedVizDateOfBirth:formattedVizDateOfExpiry: instead");





/**
 *
 *   Initializes a ALIdentification object. This object is used to carry the scanned values.
 *
 *   @deprecated since Version 10. Please use initWithSurname:givenNames:dateOfBirth:dateOfExpiry:documentNumber:documentType:... instead
 *
 *   @param documentType             The type of the document that was read. (ID/P)
 *   @param issuingCountryCode       The issuing country code of the document.
 *   @param nationalityCountryCode   The nationality country code of the document.
 *   @param surNames                 All the surNames of the person separated by whitespace.
 *   @param givenNames               All the given names of the person separated by whitespace.
 *   @param documentNumber           Passport number or document number.
 *   @param checkDigitNumber         Check digit for the document number.
 *   @param dayOfBirth               The day of birth.
 *   @param checkDigitDayOfBirth     Check digit for the day of birth.
 *   @param sex                      The gender of the person
 *   @param expirationDate           The expiration date of the passport / document.
 *   @param checkDigitExpirationDate Check digit for the expiration date.
 *   @param personalNumber           Personal Number on the document. Is nil on many passports / documents.
 *   @param checkDigitPersonalNumber    CheckDigit for the personal number. Is nil or 0 when no personal number is used. Is also nil on none passport documents.
 *   @param checkDigitFinal    On passports checkdigit over passport number, passport number checkdigit, date of birth,
 *                                  date of birth checkdigit, expiration date, expiration date checkdigit, personal number and
 *                                  personal number checkdigit.
 *                                  On other travel documents over document number, document number checkdigit, personal number,
 *                                  date of birth, date of birth checkdigit, expiration date and expiration date checkdigit.
 *
 *   @param personalNumber2          Optional data at the discretion of the issuing state. Only available in TD1 sized MROTDs. Might contain additional information.
 *   @param address                  Optional data which contains the data of the address field on a german ID.
 *   @param issuingDate              Optional data which contains the data of the issuing date field, which is outside the MRZ field
 *
 *   @param MRZString                Contains all Information found in the MRZ as string.
 *
 *   @return A new ALIdentification object
 */
- (instancetype _Nullable)initWithDocumentType:(NSString * _Nonnull)documentType
                            issuingCountryCode:(NSString * _Nonnull)issuingCountryCode
                        nationalityCountryCode:(NSString * _Nonnull)nationalityCountryCode
                                      surNames:(NSString * _Nonnull)surNames
                                    givenNames:(NSString * _Nonnull)givenNames
                                documentNumber:(NSString * _Nonnull)documentNumber
                              checkDigitNumber:(NSString * _Nonnull)checkDigitNumber
                                    dayOfBirth:(NSString * _Nonnull)dayOfBirth
                          checkDigitDayOfBirth:(NSString * _Nonnull)checkDigitDayOfBirth
                                           sex:(NSString * _Nonnull)sex
                                expirationDate:(NSString * _Nonnull)expirationDate
                      checkDigitExpirationDate:(NSString * _Nonnull)checkDigitExpirationDate
                                personalNumber:(NSString * _Nonnull)personalNumber
                      checkDigitPersonalNumber:(NSString * _Nonnull)checkDigitPersonalNumber
                               checkDigitFinal:(NSString * _Nonnull)checkDigitFinal
                               personalNumber2:(NSString * _Nonnull)personalNumber2
                                       address:(NSString * _Nullable)address
                                   issuingDate:(NSString * _Nullable)issuingDate
                                     MRZString:(NSString * _Nonnull)MRZString __deprecated_msg("Deprecated since Version 10. Please use initWithSurname:givenNames:dateOfBirth:dateOfExpiry:documentNumber:documentType:... instead");

@end

typedef ALMRZIdentification ALIdentification;

NS_ASSUME_NONNULL_END
