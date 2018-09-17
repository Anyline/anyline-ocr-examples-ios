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

@property (nullable, nonatomic, strong, readonly) NSDate *dayOfBirthDateObject;

@property (nonnull, nonatomic, strong, readonly) NSString *drivingLicenseString;

@property (nullable, nonatomic, strong) UIImage *faceImage;


/**
 *  Initializes a ALIdentification object. This object is used to carry the scanned values.
 *
 *  @param documentNumber           The number of the document that was read.
 *  @param surNames                 All the surNames of the person separated by whitespace.
 *  @param givenNames               All the given names of the person separated by whitespace.
 *  @param dayOfBirth               The day of birth.
 *
 *  @param drivingLicenseString     Contains all Information found on the drivingLicense as string. Fields will be seperated with the delimiter '|'.
 *
 *  @return A new ALDrivingLicenseIdentification object
 */
- (instancetype _Nullable)initWithDocumentNumber:(NSString * _Nonnull)documentNumber
                                        surNames:(NSString * _Nonnull)surNames
                                      givenNames:(NSString * _Nonnull)givenNames
                                      dayOfBirth:(NSString * _Nonnull)dayOfBirth
                            drivingLicenseString:(NSString * _Nonnull)drivingLicenseString;

- (instancetype _Nullable)initWithDrivingLicenseString:(NSString * _Nonnull)drivingLicenseString;

@end
