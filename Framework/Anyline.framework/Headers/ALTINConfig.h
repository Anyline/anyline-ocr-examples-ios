//
//  ALTINConfig.h
//  Anyline
//
//  Created by Philipp Müller on 22/08/2019.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import "ALBaseTireConfig.h"

/**
 *  The possible ALTINScanMode for the Anyline Tire plugin
 */
typedef NS_ENUM(NSInteger, ALTINScanMode) {
    /**
     *  The ALTINDotStrict mode has a fixed regex for certain TIN types.
     */
    ALTINDotStrict,
    /**
     *  The ALTINDot mode has more flexible RegEx.
     */
    ALTINDot,
    /**
     *  The ALTINUniversal mode has more flexible RegEx.
     */
    ALTINUniversal,
};

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

/**
 *  A class used to configure the Anyline Tire plugin for Container.
 */
@interface ALTINConfig : ALBaseTireConfig
/**
 *  The TIN scan mode.
 *  @see ALTINScanMode
 */
@property (nonatomic, assign) ALTINScanMode scanMode;

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

- (instancetype)init;
@end
