//
//  ALBaseTireConfig.h
//  Anyline
//
//  Created by Renato Neves Ribeiro on 24.01.22.
//  Copyright © 2022 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBaseOCRConfig.h"

NS_ASSUME_NONNULL_BEGIN

/**
Possible values for the upsideDownMode of an ALTINConfig and ALTireSizeConfig
 */
typedef NS_ENUM(NSInteger, ALTINUpsideDownMode) {
    /**
     *  The ALTINUpsideDownModeDisabled mode will ONLY read TINs that are NOT upsideDown
     */
    ALTINUpsideDownModeDisabled = 0,
    /**
     * The ALTINUpsideDownModeEnabled mode will ONLY read TINs that are upsideDown
     */
    ALTINUpsideDownModeEnabled = 1,
    /**
     *  The ALTINUpsideDownModeAuto mode will automatically detect if the TIN is upside down or not.
     */
    ALTINUpsideDownModeAuto = 2
};

@interface ALBaseTireConfig : ALBaseOCRConfig

/**
 *  Whether TINs will be read upside down, right-side-up, or both.
 *  @see ALTINUpsideDownMode
 */
@property (nonatomic, assign) ALTINUpsideDownMode upsideDownMode;

/**
 *  If set, this enables you to control the threshold of how confident Anyline must be when returning a scan result.
 *  Values must be with the range of 0 to 100. The minimum recommended value is 50.
 *  Please note that higher confidence values may affect scanning time.
 */
@property (nonatomic, assign) NSUInteger minConfidence;

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;

@end

NS_ASSUME_NONNULL_END
