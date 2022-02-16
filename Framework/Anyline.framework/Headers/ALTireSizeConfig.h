//
//  ALTireSizeConfig.h
//  Anyline
//
//  Created by Renato Neves Ribeiro on 24.01.22.
//  Copyright © 2022 Anyline GmbH. All rights reserved.
//

#import "ALBaseTireConfig.h"
#import "ALTINConfig.h"

NS_ASSUME_NONNULL_BEGIN


@interface ALTireSizeConfig : ALBaseTireConfig

/**
 *  Whether TINs will be read upside down, right-side-up, or both.
 *  @see ALTINUpsideDownMode
 */
@property (nonatomic, assign) ALTINUpsideDownMode upsideDownMode;

/**
 *  The min confidence to accept the result. Between 0-100, but should normally be at least 50.
 *  The spped / accurracy of Anyline can be controlled with this property.
 */
@property (nonatomic, assign) NSUInteger minConfidence;

@end

NS_ASSUME_NONNULL_END
