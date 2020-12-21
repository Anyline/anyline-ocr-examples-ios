//
//  ALDataGroup1.h
//  Anyline
//
//  Created by Angela Brett on 07.10.19.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALDataGroup1 : NSObject

@property NSString *documentType;
@property NSString *issuingStateCode;
@property NSString *documentNumber;
@property NSDate *dateOfExpiry;
@property NSString *gender;
@property NSString *nationality;
@property NSString *lastName;
@property NSString *firstName;
@property NSDate *dateOfBirth;

- (instancetype)initWithDocumentType:(NSString *)documentType issuingStateCode:(NSString *)issuingStateCode documentNumber:(NSString *)documentNumber dateOfExpiry:(NSDate *)dateOfExpiry gender:(NSString *)gender nationality:(NSString *)nationality lastName:(NSString *)lastName firstName:(NSString *)firstName dateOfBirth:(NSDate *)dateOfBirth;

- (instancetype)initWithPassportDataElements:(NSDictionary<NSString *,NSString *> *)passportDataElements;

@end

NS_ASSUME_NONNULL_END
