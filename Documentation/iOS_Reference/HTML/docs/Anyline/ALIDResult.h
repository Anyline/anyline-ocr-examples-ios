//
//  ALIDResult.h
//  Anyline
//
//  Created by Philipp Müller on 25/05/2018.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "ALScanResult.h"

#import "ALDrivingLicenseIdentification.h"
#import "ALMRZIdentification.h"
#import "ALGermanIDFrontIdentification.h"

typedef NS_ENUM(NSInteger, ALIdentityDocumentScanMode) {
    ALMRZ,
    ALDrivingLicense
};

/**
 *  The result object for the ALIDResult
 */
@interface ALIDResult<__covariant ObjectType> : ALScanResult<ObjectType>

/**
 * Boolean indicating if all the check digits where valid
 */
@property (nonatomic, assign, readonly) BOOL allCheckDigitsValid;

- (instancetype _Nullable)initWithResult:(ObjectType _Nonnull)result
                                   image:(UIImage * _Nonnull)image
                               fullImage:(UIImage * _Nullable)fullImage
                              confidence:(NSInteger)confidence
                                pluginID:(NSString *_Nonnull)pluginID
                     allCheckDigitsValid:(BOOL)allCheckDigitsValid;

@end

typedef ALIDResult ALMRZResult;
