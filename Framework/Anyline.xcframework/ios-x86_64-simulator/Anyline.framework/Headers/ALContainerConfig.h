//
//  ALContainerConfig.h
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
/**
 *  The regex which any scanned text should match. If this is nil, only the characterWhitelist is used to validate scans. This can be used alone or in combination with characterWhitelist; if both are set, then only codes which match the validationRegex and only contain characters from characterWhitelist will be scanned.
 */
@property (nullable, nonatomic, copy) NSString *validationRegex;
/**
 *  Characters which are allowed in the scanned text. If this is nil or empty, all digits and uppercase characters will be accepted. This can be used alone or in combination with validationRegex; if both are non-nil, then only codes which match the validationRegex and only contain characters from characterWhitelist will be scanned.
 */
@property (nullable, nonatomic, copy) NSString *characterWhitelist;

/**
 *  Initialises a horizontal container config which accepts any pattern of digits and uppercase letters.
 */
- (instancetype _Nonnull)init;
@end
