//
//  ALMRZConfig.h
//  Anyline
//
//  Created by Philipp Müller on 30.05.18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALIDConfig.h"

@class ALMRZFieldScanOptions;

@interface ALMRZConfig : ALIDConfig

/**
 *  If strictMode is enabled, results will only be returned when all checkDigits are valid.
 *  Default strictMode = false
 */
@property (nonatomic) BOOL strictMode;

/**
 *  If cropAndTransformID is enabled, the detected identification document will be cropped and the image will be returned.
 *  Default strictMode = false
 */
@property (nonatomic) BOOL cropAndTransformID;

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

@interface ALMRZFieldScanOptions : ALIDFieldScanOptions

@property (nonatomic) ALFieldScanOption vizDateOfIssue;
@property (nonatomic) ALFieldScanOption vizAddress;
@property (nonatomic) ALFieldScanOption vizSurname;
@property (nonatomic) ALFieldScanOption vizGivenNames;
@property (nonatomic) ALFieldScanOption vizDateOfBirth;
@property (nonatomic) ALFieldScanOption vizDateOfExpiry;

//Deprecated FieldScanOptions
@property (nonatomic) ALFieldScanOption dateOfIssue __deprecated_msg("Deprecated since Version 10.1. Please use vizDateOfIssue instead");
@property (nonatomic) ALFieldScanOption address __deprecated_msg("Deprecated since Version 10.1. Please use vizAddress instead");

/*
 *  unsupported MRZ fieldScanOptions:
 */
/*
 @property (nonatomic) ALFieldScanOption surname;
 @property (nonatomic) ALFieldScanOption givenNames;
 @property (nonatomic) ALFieldScanOption dateOfBirth;
 @property (nonatomic) ALFieldScanOption dateOfExpiry;
 @property (nonatomic) ALFieldScanOption documentNumber;
 @property (nonatomic) ALFieldScanOption documentType;
 @property (nonatomic) ALFieldScanOption issuingCountryCode;
 @property (nonatomic) ALFieldScanOption nationalityCountryCode;
 @property (nonatomic) ALFieldScanOption sex;
 @property (nonatomic) ALFieldScanOption personalNumber;
 @property (nonatomic) ALFieldScanOption optionalData;
 */
@end

