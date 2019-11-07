//
//  ALTINConfig.h
//  Anyline
//
//  Created by Philipp Müller on 22/08/2019.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import "ALBaseOCRConfig.h"

/**
 *  The possible ALTINScanMode for the AnylineOCR plugin
 */
typedef NS_ENUM(NSInteger, ALTINScanMode) {
    /**
     *  The ALTINStandard mode has a fixed regex for certain TIN types.
     */
    ALTINStandard,
    /**
     *  The ALTINFlexible mode has more flexible RegEx.
     */
    ALTINFlexible,
};

/**
 *  A class used to configure the Anyline OCR plugin for Container.
 */
@interface ALTINConfig : ALBaseOCRConfig
/**
 *  The container scan mode.
 *  @see ALContainerScanMode
 */
@property (nonatomic, assign) ALTINScanMode scanMode;
@property (nonatomic, assign) BOOL enableUpsideDownScan;

- (instancetype)init;
@end
