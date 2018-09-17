//
//  ALMRZIdentification.h
//  Anyline
//
//  Created by Daniel Albertini on 20.07.18.
//  Copyright © 2018 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface ALMRZIdentification : NSObject

@property (nonnull, nonatomic, strong, readonly) NSString *documentType;
@property (nonnull, nonatomic, strong, readonly) NSString *documentNumber;
@property (nonnull, nonatomic, strong, readonly) NSString *surNames;
@property (nonnull, nonatomic, strong, readonly) NSString *givenNames;
@property (nonnull, nonatomic, strong, readonly) NSString *issuingCountryCode;
@property (nonnull, nonatomic, strong, readonly) NSString *nationalityCountryCode;
@property (nonnull, nonatomic, strong, readonly) NSString *dayOfBirth;
@property (nonnull, nonatomic, strong, readonly) NSString *expirationDate;
@property (nonnull, nonatomic, strong, readonly) NSString *sex;
@property (nonnull, nonatomic, strong, readonly) NSString *checkdigitNumber;
@property (nonnull, nonatomic, strong, readonly) NSString *checkdigitExpirationDate;
@property (nonnull, nonatomic, strong, readonly) NSString *checkdigitDayOfBirth;
@property (nonnull, nonatomic, strong, readonly) NSString *checkdigitFinal;
@property (nonnull, nonatomic, strong, readonly) NSString *personalNumber;
@property (nonnull, nonatomic, strong, readonly) NSString *checkDigitPersonalNumber;
@property (nonnull, nonatomic, strong, readonly) NSString *personalNumber2;

@property (nullable, nonatomic, strong, readonly) NSDate *expirationDateObject;
@property (nullable, nonatomic, strong, readonly) NSDate *dayOfBirthDateObject;
@property (nonnull, nonatomic, strong, readonly) NSString *MRZString;

@property (nullable, nonatomic, strong) UIImage *faceImage;


/**
 *  Initializes a ALIdentification object. This object is used to carry the scanned values.
 *
 *  @param documentType             The type of the document that was read. (ID/P)
 *  @param issuingCountryCode       The issuing country code of the document.
 *  @param nationalityCountryCode   The nationality country code of the document.
 *  @param surNames                 All the surNames of the person separated by whitespace.
 *  @param givenNames               All the given names of the person separated by whitespace.
 *  @param documentNumber           Passport number or document number.
 *  @param checkDigitNumber         Check digit for the document number.
 *  @param dayOfBirth               The day of birth.
 *  @param checkDigitDayOfBirth     Check digit for the day of birth.
 *  @param sex                      The gender of the person
 *  @param expirationDate           The expiration date of the passport / document.
 *  @param checkDigitExpirationDate Check digit for the expiration date.
 *  @param personalNumber           Personal Number on the document. Is nil on many passports / documents.
 *  @param checkDigitPersonalNumber CheckDigit for the personal number. Is nil or 0 when no personal number is used.
 *                                  Is also nil on none passport documents.
 *  @param checkDigitFinal          On passports checkdigit over passport number, passport number checkdigit, date of birth,
 *                                  date of birth checkdigit, expiration date, expiration date checkdigit, personal number and
 *                                  personal number checkdigit.
 *                                  On other travel documents over document number, document number checkdigit, personal number,
 *                                  date of birth, date of birth checkdigit, expiration date and expiration date checkdigit.
 *
 *  @param personalNumber2          Optional data at the discretion of the issuing state. Only available in TD1 sized MROTDs.
 *                                  Might contain additional information.
 *
 *  @param MRZString                Contains all Information found in the MRZ as string.
 *
 *  @return A new ALIdentification object
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
                      checkDigitExpirationDate:(NSString * _Nonnull)checkdigitExpirationDate
                                personalNumber:(NSString * _Nonnull)personalNumber
                      checkDigitPersonalNumber:(NSString * _Nonnull)checkDigitPersonalNumber
                               checkDigitFinal:(NSString * _Nonnull)checkDigitFinal
                               personalNumber2:(NSString * _Nonnull)personalNumber2
                                     MRZString:(NSString * _Nonnull)MRZString;

@end

typedef ALMRZIdentification ALIdentification;

NS_ASSUME_NONNULL_END
