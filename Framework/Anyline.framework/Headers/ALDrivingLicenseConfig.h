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
     *
     */
    ALDrivingLicenseAT,
    /**
     *
     */
    ALDrivingLicenseDE,
    /**
     *
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

/*
 *  Will set the ALIDFieldScanOption for the respective Fields
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

