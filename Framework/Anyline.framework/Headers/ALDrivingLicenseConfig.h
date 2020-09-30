//
//  ALDrivingLicenseConfig.h
//  Anyline
//
//  Created by Philipp Müller on 30.05.18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALIDConfig.h"

/**
 *  The possible scanModes for the ALDrivingLicenseScanMode module
 */
typedef NS_ENUM(NSInteger, ALDrivingLicenseScanMode) {
    /**
     * Read Austrian driving licenses
     */
    ALDrivingLicenseAT,
    /**
     * Read German driving licenses
     */
    ALDrivingLicenseDE,
    /**
     * Read UK driving licenses
     */
    ALDrivingLicenseUK,
    /**
     * Read Dutch driving licenses
     */
    ALDrivingLicenseNL,
    /**
     * Read Belgian driving licenses
     */
    ALDrivingLicenseBE,
    /**
     * Automatically detect the type of driving license
     */
    ALDrivingLicenseAuto
};

@class ALDrivingLicenseFieldScanOptions;

@interface ALDrivingLicenseConfig : ALIDConfig

/**
 *  The scan mode.
 *  @see ALDrivingLicenseScanMode
 */
@property (nonatomic, assign) ALDrivingLicenseScanMode scanMode;

@end

/**
 *  Will set the ALIDFieldScanOption for the respective fields
 *
 *  By default this object will be nil.
 *
 *  If you init this object, all fields will be set to "ALDefault" by default.
 *
 *  Note: The default behavior might be affected if you use this object.
 */
@interface ALDrivingLicenseFieldScanOptions : ALIDFieldScanOptions

@property (nonatomic) ALFieldScanOption surname;
@property (nonatomic) ALFieldScanOption givenNames;
@property (nonatomic) ALFieldScanOption dateOfBirth;
@property (nonatomic) ALFieldScanOption placeOfBirth;
@property (nonatomic) ALFieldScanOption dateOfIssue;
@property (nonatomic) ALFieldScanOption dateOfExpiry;
@property (nonatomic) ALFieldScanOption authority;
@property (nonatomic) ALFieldScanOption documentNumber;
@property (nonatomic) ALFieldScanOption categories;

@end

@interface ALDrivingLicenseFieldConfidences : ALIDFieldConfidences

@property (nonatomic) ALFieldConfidence surname;
@property (nonatomic) ALFieldConfidence givenNames;
@property (nonatomic) ALFieldConfidence dateOfBirth;
@property (nonatomic) ALFieldConfidence placeOfBirth;
@property (nonatomic) ALFieldConfidence dateOfIssue;
@property (nonatomic) ALFieldConfidence dateOfExpiry;
@property (nonatomic) ALFieldConfidence authority;
@property (nonatomic) ALFieldConfidence documentNumber;
@property (nonatomic) ALFieldConfidence categories;

@property (nonatomic) ALDrivingLicenseFieldConfidences * _Nonnull fieldConfidences;

- (instancetype _Nullable)initWithSurname:(ALFieldConfidence)surname
                               givenNames:(ALFieldConfidence)givenNames
                              dateOfBirth:(ALFieldConfidence)dateOfBirth
                             placeOfBirth:(ALFieldConfidence)placeOfBirth
                              dateOfIssue:(ALFieldConfidence)dateOfIssue
                             dateOfExpiry:(ALFieldConfidence)dateOfExpiry
                                authority:(ALFieldConfidence)authority
                           documentNumber:(ALFieldConfidence)documentNumber
                               categories:(ALFieldConfidence)categories;

@end
