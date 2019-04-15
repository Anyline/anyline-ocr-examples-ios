//
//  ALGermanIDFrontConfig.h
//  Anyline
//
//  Created by Philipp Müller on 06.03.19.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALIDConfig.h"

@class ALGermanIDFrontFieldScanOptions;

@interface ALGermanIDFrontConfig : ALIDConfig

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

@interface ALGermanIDFrontFieldScanOptions : ALIDFieldScanOptions

@property (nonatomic) ALFieldScanOption surname;
@property (nonatomic) ALFieldScanOption givenNames;
@property (nonatomic) ALFieldScanOption dateOfBirth;
@property (nonatomic) ALFieldScanOption nationality;
@property (nonatomic) ALFieldScanOption placeOfBirth;
@property (nonatomic) ALFieldScanOption dateOfExpiry;
@property (nonatomic) ALFieldScanOption documentNumber;
@property (nonatomic) ALFieldScanOption cardAccessNumber;

@end
