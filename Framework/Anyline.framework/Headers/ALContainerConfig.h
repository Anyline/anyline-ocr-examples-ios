//
//  ALBaseOCRConfig.h
//  Anyline
//
//  Created by Philipp Müller on 03/05/2019.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import "ALBaseOCRConfig.h"

/**
 *  The possible containerScanModes for the AnylineOCR plugin
 */
typedef NS_ENUM(NSInteger, ALContainerScanMode) {
    /**
     *  The HORIZONTAL mode is optimal for scanning a horizontal line of container numbers.
     */
    ALHorizontal,
    /**
     *  The VERTICAL mode is optimal for scanning a vertical line of container numbers.
     */
    ALVertical,
};

/**
 *  A class used to configure the Anyline OCR plugin for Container.
 */
@interface ALContainerConfig : ALBaseOCRConfig
/**
 *  The container scan mode.
 *  @see ALContainerScanMode
 */
@property (nonatomic, assign) ALContainerScanMode scanMode;

- (instancetype)init;
@end
