//
//  ALGermanIDFrontIdentification.h
//  Anyline
//
//  Created by Philipp Müller on 06/03/2019.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALSquare.h"
#import "ALScanResult.h"
#import "ALGermanIDFrontConfig.h"

@interface ALGermanIDFrontIdentification : NSObject


@property (nullable, nonatomic, strong, readonly) NSString *surname;
@property (nullable, nonatomic, strong, readonly) NSString *givenNames;
@property (nullable, nonatomic, strong, readonly) NSString *dateOfBirth;
@property (nullable, nonatomic, strong, readonly) NSString *nationality;
@property (nullable, nonatomic, strong, readonly) NSString *placeOfBirth;
@property (nullable, nonatomic, strong, readonly) NSString *dateOfExpiry;
@property (nullable, nonatomic, strong, readonly) NSString *documentNumber;
@property (nullable, nonatomic, strong, readonly) NSString *cardAccessNumber;

@property (nullable, nonatomic, strong, readonly) NSString *germanIdFrontString;

@property (nullable, nonatomic, strong, readonly) NSDate *dateOfBirthObject;
@property (nullable, nonatomic, strong, readonly) NSDate *dateOfExpiryObject;

@property (nullable, nonatomic, strong) UIImage *faceImage;

@property (nullable, nonatomic, strong) ALGermanIDFrontFieldConfidences *fieldConfidences;

/*
 *  Deprecated Properties
 */
@property (nullable, nonatomic, strong, readonly) NSString *surNames __deprecated_msg("Deprecated since Version 10. Please use the property \"surname\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *dayOfBirth __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfBirth\" instead.");
@property (nullable, nonatomic, strong, readonly) NSString *expirationDate __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfExpiry\" instead.");

@property (nullable, nonatomic, strong, readonly) NSDate *dayOfBirthDateObject __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfBirthObject\" instead.");
@property (nullable, nonatomic, strong, readonly) NSDate *expirationDateObject __deprecated_msg("Deprecated since Version 10. Please use the property \"dateOfExpiryObject\" instead.");


/**
 *  Initializes a ALGermanIDFrontIdentification object. This object is used to carry the scanned values.
 *
 *  @param surname                 All the surNames of the person separated by whitespace.
 *  @param givenNames              All the given names of the person separated by whitespace.
 *  @param dateOfBirth             The day of birth.
 *  @param nationality             Nationality of the document holder
 *  @param placeOfBirth            The place of birth.
 *  @param dateOfExpiry            The expiration date of the driving license.
 *  @param documentNumber          The number of the document that was read.
 *  @param cardAccessNumber        The access number of the card/document
 *
 *  @param germanIdFrontString     Contains all Information found on the ID as string. Fields will be seperated with the delimiter '|'.
 *
 *  @return A new ALDrivingLicenseIdentification object
 */
- (instancetype _Nullable)initWithSurname:(NSString * _Nonnull)surname
                               givenNames:(NSString * _Nonnull)givenNames
                              dateOfBirth:(NSString * _Nonnull)dateOfBirth
                              nationality:(NSString * _Nonnull)nationality
                             placeOfBirth:(NSString * _Nonnull)placeOfBirth
                             dateOfExpiry:(NSString * _Nonnull)dateOfExpiry
                           documentNumber:(NSString * _Nonnull)documentNumber
                         cardAccessNumber:(NSString * _Nonnull)cardAccessNumber
                      germanIdFrontString:(NSString * _Nonnull)germanIdFrontString;

/**
 *  Initializes a ALGermanIDFrontIdentification object. This object is used to carry the scanned values.
 *
 *  @param documentNumber           The number of the document that was read.
 *  @param surNames                 All the surNames of the person separated by whitespace.
 *  @param givenNames               All the given names of the person separated by whitespace.
 *  @param dayOfBirth               The day of birth.
 *  @param placeOfBirth             The place of birth.
 *  @param nationality              Nationality of the document holder
 *  @param cardAccessNumber         The access number of the card/document
 *  @param expirationDate           The expiration date of the driving license.
 *
 *  @param germanIdFrontString     Contains all Information found on the ID as string. Fields will be seperated with the delimiter '|'.
 *
 *  @return A new ALDrivingLicenseIdentification object
 */
- (instancetype _Nullable)initWithDocumentNumber:(NSString * _Nonnull)documentNumber
                                        surNames:(NSString * _Nonnull)surNames
                                      givenNames:(NSString * _Nonnull)givenNames
                                      dayOfBirth:(NSString * _Nonnull)dayOfBirth
                                    placeOfBirth:(NSString * _Nonnull)placeOfBirth
                                     nationality:(NSString * _Nonnull)nationality
                                cardAccessNumber:(NSString * _Nonnull)cardAccessNumber
                                  expirationDate:(NSString * _Nonnull)expirationDate
                             germanIdFrontString:(NSString * _Nonnull)germanIdFrontString __deprecated_msg("Deprecated since Version 10. Please use initWithSurname:givenNames:dateOfBirth:nationality:placeOfBirth:dateOfExpiry:... instead");

@end
