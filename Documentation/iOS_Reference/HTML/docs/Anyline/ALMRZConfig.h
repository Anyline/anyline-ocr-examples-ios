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


/**
 *  Will set the ALIDFieldScanOption for the respective fields
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
@property (nonatomic) ALFieldScanOption dateOfBirth;
@property (nonatomic) ALFieldScanOption dateOfExpiry;

//Deprecated FieldScanOptions
@property (nonatomic) ALFieldScanOption dateOfIssue __deprecated_msg("Deprecated since Version 10.1. Please use vizDateOfIssue instead");
@property (nonatomic) ALFieldScanOption address __deprecated_msg("Deprecated since Version 10.1. Please use vizAddress instead");

/*
 *  unsupported MRZ fieldScanOptions:
 */
/*
 @property (nonatomic) ALFieldScanOption surname;
 @property (nonatomic) ALFieldScanOption givenNames;
 @property (nonatomic) ALFieldScanOption documentNumber;
 @property (nonatomic) ALFieldScanOption documentType;
 @property (nonatomic) ALFieldScanOption issuingCountryCode;
 @property (nonatomic) ALFieldScanOption nationalityCountryCode;
 @property (nonatomic) ALFieldScanOption sex;
 @property (nonatomic) ALFieldScanOption personalNumber;
 @property (nonatomic) ALFieldScanOption optionalData;
 */
@end

@interface ALMRZFieldConfidences : ALIDFieldConfidences

//Be aware: MrzFieldConfidences have every field implemented, except for the AllCheckDigitsValid field. !Not only the fields from the FieldScanOptions!)
@property (nonatomic) ALFieldConfidence vizDateOfIssue;
@property (nonatomic) ALFieldConfidence vizAddress;
@property (nonatomic) ALFieldConfidence vizSurname;
@property (nonatomic) ALFieldConfidence vizGivenNames;
@property (nonatomic) ALFieldConfidence vizDateOfBirth;
@property (nonatomic) ALFieldConfidence vizDateOfExpiry;
@property (nonatomic) ALFieldConfidence surname;
@property (nonatomic) ALFieldConfidence givenNames;
@property (nonatomic) ALFieldConfidence dateOfBirth;
@property (nonatomic) ALFieldConfidence dateOfExpiry;
@property (nonatomic) ALFieldConfidence documentNumber;
@property (nonatomic) ALFieldConfidence documentType;
@property (nonatomic) ALFieldConfidence issuingCountryCode;
@property (nonatomic) ALFieldConfidence nationalityCountryCode;
@property (nonatomic) ALFieldConfidence sex;
@property (nonatomic) ALFieldConfidence personalNumber;
@property (nonatomic) ALFieldConfidence optionalData;

@property (nonatomic) ALFieldConfidence mrzString;

//Check Digits
@property (nonatomic) ALFieldConfidence checkDigitDateOfExpiry;
@property (nonatomic) ALFieldConfidence checkDigitDocumentNumber;
@property (nonatomic) ALFieldConfidence checkDigitDateOfBirth;
@property (nonatomic) ALFieldConfidence checkDigitFinal;
@property (nonatomic) ALFieldConfidence checkDigitPersonalNumber;

- (instancetype _Nullable)initWithSurname:(ALFieldConfidence)surname
                               givenNames:(ALFieldConfidence)givenNames
                              dateOfBirth:(ALFieldConfidence)dateOfBirth
                             dateOfExpiry:(ALFieldConfidence)dateOfExpiry
                           documentNumber:(ALFieldConfidence)documentNumber
                             documentType:(ALFieldConfidence)documentType
                       issuingCountryCode:(ALFieldConfidence)issuingCountryCode
                   nationalityCountryCode:(ALFieldConfidence)nationalityCountryCode
                                      sex:(ALFieldConfidence)sex
                           personalNumber:(ALFieldConfidence)personalNumber
                             optionalData:(ALFieldConfidence)optionalData
                   checkDigitDateOfExpiry:(ALFieldConfidence)checkDigitDateOfExpiry
                 checkDigitDocumentNumber:(ALFieldConfidence)checkDigitDocumentNumber
                    checkDigitDateOfBirth:(ALFieldConfidence)checkDigitDateOfBirth
                          checkDigitFinal:(ALFieldConfidence)checkDigitFinal
                 checkDigitPersonalNumber:(ALFieldConfidence)checkDigitPersonalNumber
                               vizAddress:(ALFieldConfidence)vizAddress
                           vizDateOfIssue:(ALFieldConfidence)vizDateOfIssue
                               vizSurname:(ALFieldConfidence)vizSurname
                            vizGivenNames:(ALFieldConfidence)vizGivenNames
                           vizDateOfBirth:(ALFieldConfidence)vizDateOfBirth
                          vizDateOfExpiry:(ALFieldConfidence)vizDateOfExpiry
                                mrzString:(ALFieldConfidence)mrzString;

@end
