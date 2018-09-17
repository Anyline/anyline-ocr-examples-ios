//
//  ALMRZConfig.h
//  Anyline
//
//  Created by Philipp Müller on 30.05.18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALIDConfig.h"

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
