//
//  ALVINConfig.h
//  Anyline
//
//  Created by Philipp Müller on 03/05/2019.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import "ALBaseOCRConfig.h"

/**
 *  A class used to configure the Anyline OCR plugin for VIN.
 */
@interface ALVINConfig : ALBaseOCRConfig

@property (nullable, nonatomic, copy) NSString *validationRegex;
@property (nullable, nonatomic, copy) NSString *characterWhitelist;

@end
