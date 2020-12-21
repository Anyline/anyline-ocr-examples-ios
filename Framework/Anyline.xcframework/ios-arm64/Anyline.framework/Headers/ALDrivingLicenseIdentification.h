//
//  ALDrivingLicenseIdentification.h
//  Anyline
//
//  Created by Philipp Müller on 26/05/2018.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALSquare.h"
#import "ALScanResult.h"
#import "ALDrivingLicenseConfig.h"

@interface ALDrivingLicenseIdentification : NSObject

@property (nullable, nonatomic, strong, readonly) NSString *surname;
@property (nullable, nonatomic, strong, readonly) NSString *givenNames;
@property (nullable, nonatomic, strong, readonly) NSString *dateOfBirth;
@property (nullable, nonatomic, strong, readonly) NSString *placeOfBirth;
@property (nullable, nonatomic, strong, readonly) NSString *dateOfIssue;
@property (nullable, nonatomic, strong, readonly) NSString *dateOfExpiry;
@property (nullable, nonatomic, strong, readonly) NSString *authority;
@property (nullable, nonatomic, strong, readonly) NSString *documentNumber;
@property (nullable, nonatomic, strong, readonly) NSString *categories;

@property (nonnull, nonatomic, strong, readonly) NSString *drivingLicenseString;

//Date Objects
@property (nullable, nonatomic, strong, readonly) NSDate *dateOfBirthObject;
@property (nullable, nonatomic, strong, readonly) NSDate *dateOfIssueObject;
@property (nullable, nonatomic, strong, readonly) NSDate *dateOfExpiryObject;

@property (nullable, nonatomic, strong) UIImage *faceImage;

@property (nullable, nonatomic, strong) ALDrivingLicenseFieldConfidences *fieldConfidences;

/*
 *  Deprecated Properties
 */
@property (nullable, nonatomic, strong, readonly) NSString *surNames __deprecated_msg("Deprecated since Version 10. Please use the property \"surname\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *dayOfBirth __deprecated_msg("Deprecated since Version 10. Please use the property \"dayOfBirth\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *issuingDate __deprecated_msg("Deprecated since Version 10. Please use the property \"issuingDate\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *expirationDate __deprecated_msg("Deprecated since Version 10. Please use the property \"expirationDate\" instead.");

@property (nullable, nonatomic, strong, readonly) NSDate *dayOfBirthDateObject __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfBirthObject\" instead.");
@property (nullable, nonatomic, strong, readonly) NSDate *issuingDateObject __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfIssueObject\" instead.");
@property (nullable, nonatomic, strong, readonly) NSDate *expirationDateObject __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfExpiryObject\" instead.");


/**
 *  Initializes a ALIdentification object. This object is used to carry the scanned values.
 *
 *  @param surname                  All the surNames of the person separated by whitespace.
 *  @param givenNames               All the given names of the person separated by whitespace.
 *  @param dateOfBirth              The date of birth.
 *  @param placeOfBirth             The place of birth.
 *  @param dateOfIssue              The issuing date of the driving license.
 *  @param dateOfExpiry             The expiration date of the driving license.
 *  @param authority                The driving license authority(s)
 *  @param documentNumber           The number of the document that was read.
 *  @param categories               The detected vehicle categories.
 *
 *  @param drivingLicenseString     Contains all Information found on the drivingLicense as string. Fields will be seperated with the delimiter '|'.
 *
 *  @param formattedDateOfExpiry    The dateOfExpiry in a given Format (dd.MM.yyyy). The dateOfExpiryObject will be created using this value.
 *  @param formattedDateOfBirth     The dateOfBirth in a given Format (dd.MM.yyyy). The dateOfBirthObject will be created using this value.
 *  @param formattedDateOfIssue     The dateOfIssue in a given Format (dd.MM.yyyy). The dateOfIssueObject will be created using this value.
 *
 *  @return A new ALDrivingLicenseIdentification object
 */
- (instancetype _Nullable)initWithSurname:(NSString * _Nullable)surname
                               givenNames:(NSString * _Nullable)givenNames
                              dateOfBirth:(NSString * _Nullable)dateOfBirth
                             placeOfBirth:(NSString * _Nullable)placeOfBirth
                              dateOfIssue:(NSString * _Nullable)dateOfIssue
                             dateOfExpiry:(NSString * _Nullable)dateOfExpiry
                                authority:(NSString * _Nullable)authority
                           documentNumber:(NSString * _Nullable)documentNumber
                               categories:(NSString * _Nullable)categories
                     drivingLicenseString:(NSString * _Nullable)drivingLicenseString
                    formattedDateOfExpiry:(NSString * _Nullable)formattedDateOfExpiry
                     formattedDateOfBirth:(NSString * _Nullable)formattedDateOfBirth
                     formattedDateOfIssue:(NSString * _Nullable)formattedDateOfIssue;

/**
 *  Initializes a ALIdentification object. This object is used to carry the scanned values.
 *
 *  @param documentNumber           The number of the document that was read.
 *  @param surNames                 All the surNames of the person separated by whitespace.
 *  @param givenNames               All the given names of the person separated by whitespace.
 *  @param dayOfBirth               The day of birth.
 *  @param placeOfBirth             The place of birth.
 *  @param issuingDate              The issuing date of the driving license.
 *  @param expirationDate           The expiration date of the driving license.
 *  @param authority                The driving license authority(s)
 *  @param categories               The detected vehicle categories.
 *
 *  @param drivingLicenseString     Contains all Information found on the drivingLicense as string. Fields will be seperated with the delimiter '|'.
 *
 *  @return A new ALDrivingLicenseIdentification object
 */
- (instancetype _Nullable)initWithDocumentNumber:(NSString * _Nonnull)documentNumber
                                        surNames:(NSString * _Nonnull)surNames
                                      givenNames:(NSString * _Nonnull)givenNames
                                      dayOfBirth:(NSString * _Nonnull)dayOfBirth
                                    placeOfBirth:(NSString * _Nonnull)placeOfBirth
                                     issuingDate:(NSString * _Nonnull)issuingDate
                                  expirationDate:(NSString * _Nonnull)expirationDate
                                       authority:(NSString * _Nonnull)authority
                                      categories:(NSString * _Nonnull)categories
                            drivingLicenseString:(NSString * _Nonnull)drivingLicenseString __deprecated_msg("Deprecated since Version 10. Please use initWithSurname:givenNames:dateOfBirth:dateOfExpiry:documentNumber:documentType:... instead");

@end
