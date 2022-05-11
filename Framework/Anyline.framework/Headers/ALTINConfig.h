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
 *  A class used to configure the Anyline Tire plugin for Container.
 */
@interface ALTINConfig : ALBaseTireConfig
/**
 *  The TIN scan mode.
 *  @see ALTINScanMode
 */
@property (nonatomic, assign) ALTINScanMode scanMode;

- (instancetype)init;
@end
