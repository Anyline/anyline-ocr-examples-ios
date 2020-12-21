//
//  ALBaseOCRConfig.h
//  Anyline
//
//  Created by Philipp Müller on 03/05/2019.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A base class used to configure the Anyline OCR module.
 */
@interface ALBaseOCRConfig : NSObject

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;

@end
