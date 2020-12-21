//
//  ALSOD.h
//  Anyline
//
//  Created by Angela Brett on 07.10.19.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALSOD : NSObject

@property NSString *issuerCountry;
@property NSString *issuerCertificationAuthority;
@property NSString *issuerOrganization;
@property NSString *issuerOrganizationalUnit;
@property NSString *signatureAlgorithm;
@property NSString *ldsHashAlgorithm;
@property NSString *validFromString;
@property NSString *validUntilString;

@end

NS_ASSUME_NONNULL_END
