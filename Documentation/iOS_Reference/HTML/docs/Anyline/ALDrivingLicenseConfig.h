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

@interface ALDrivingLicenseConfig : ALIDConfig

/**
 *  The scan mode.
 *  @see ALDrivingLicenseScanMode
 */
@property (nonatomic, assign) ALDrivingLicenseScanMode scanMode;

@end
