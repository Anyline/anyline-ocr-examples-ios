//
//  ALLicensePlateResult.h
//  Anyline
//
//  Created by Daniel Albertini on 02/10/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALScanResult.h"

@interface ALLicensePlateResult : ALScanResult<NSString *>

/**
 *  The country found on the license plate
 */
@property (nullable, nonatomic, strong, readonly) NSString *country;


- (instancetype _Nullable)initWithResult:(NSString * _Nonnull)result
                                   image:(UIImage * _Nonnull)image
                               fullImage:(UIImage * _Nullable)fullImage
                              confidence:(NSInteger)confidence
                                 outline:(ALSquare * _Nullable)outline
                                pluginID:(NSString *_Nonnull)pluginID
                                 country:(NSString * _Nullable)country;

@end
