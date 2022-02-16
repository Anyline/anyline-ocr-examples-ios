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

@interface ALBaseTireConfig : ALBaseOCRConfig 

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;

@end

NS_ASSUME_NONNULL_END
