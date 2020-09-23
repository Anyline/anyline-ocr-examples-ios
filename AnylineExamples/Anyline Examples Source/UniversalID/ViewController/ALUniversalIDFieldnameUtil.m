//
//  UniversalIDFieldnameMap.m
//  AnylineExamples
//
//  Created by Philipp Müller on 19.09.20.
//

#import "ALUniversalIDFieldnameUtil.h"

@interface ALUniversalIDFieldnameUtil ()


@end

@implementation ALUniversalIDFieldnameUtil

+ (NSArray *)fieldNamesOrderArray {
    NSArray *array = @[
        @"surname",
        @"givenNames",
        @"dateOfBirth",
        @"documentNumber",
        @"layoutDefinition.country",
        @"layoutDefinition.type",
    ];
    return [array copy];
}

@end


