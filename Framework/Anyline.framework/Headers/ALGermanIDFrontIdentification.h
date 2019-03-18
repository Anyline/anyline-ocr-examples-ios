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

@interface ALGermanIDFrontIdentification : NSObject

@property (nonnull, nonatomic, strong, readonly) NSString *documentNumber;
@property (nonnull, nonatomic, strong, readonly) NSString *surNames;
@property (nonnull, nonatomic, strong, readonly) NSString *givenNames;
@property (nonnull, nonatomic, strong, readonly) NSString *dayOfBirth;
@property (nonnull, nonatomic, strong, readonly) NSString *placeOfBirth;
@property (nonnull, nonatomic, strong, readonly) NSString *nationality;
@property (nonnull, nonatomic, strong, readonly) NSString *cardAccessNumber;
@property (nonnull, nonatomic, strong, readonly) NSString *expirationDate;;

@property (nullable, nonatomic, strong, readonly) NSDate *dayOfBirthDateObject;
@property (nullable, nonatomic, strong, readonly) NSDate *expirationDateObject;

@property (nonnull, nonatomic, strong, readonly) NSString *germanIdFrontString;

@property (nullable, nonatomic, strong) UIImage *faceImage;


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
                             germanIdFrontString:(NSString * _Nonnull)germanIdFrontString;

@end
