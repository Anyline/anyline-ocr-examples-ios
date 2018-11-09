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

@interface ALDrivingLicenseIdentification : NSObject

@property (nonnull, nonatomic, strong, readonly) NSString *documentNumber;
@property (nonnull, nonatomic, strong, readonly) NSString *surNames;
@property (nonnull, nonatomic, strong, readonly) NSString *givenNames;
@property (nonnull, nonatomic, strong, readonly) NSString *dayOfBirth;
@property (nonnull, nonatomic, strong, readonly) NSString *placeOfBirth;
@property (nonnull, nonatomic, strong, readonly) NSString *issuingDate;
@property (nonnull, nonatomic, strong, readonly) NSString *expirationDate;
@property (nonnull, nonatomic, strong, readonly) NSString *authority;
@property (nonnull, nonatomic, strong, readonly) NSString *categories;

@property (nullable, nonatomic, strong, readonly) NSDate *dayOfBirthDateObject;
@property (nullable, nonatomic, strong, readonly) NSDate *issuingDateObject;
@property (nullable, nonatomic, strong, readonly) NSDate *expirationDateObject;

@property (nonnull, nonatomic, strong, readonly) NSString *drivingLicenseString;

@property (nullable, nonatomic, strong) UIImage *faceImage;


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
                            drivingLicenseString:(NSString * _Nonnull)drivingLicenseString;

@end
