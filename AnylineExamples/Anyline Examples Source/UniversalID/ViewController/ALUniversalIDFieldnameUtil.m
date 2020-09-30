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

+ (NSMutableArray<ALResultEntry *> *)addIDSubResult:(ALUniversalIDIdentification*)identification titleSuffix:(NSString *)titleSuffix resultHistoryString:(NSMutableString *)resultHistoryString {
    
    
    NSMutableArray<ALResultEntry *> *resultData = [[NSMutableArray alloc] init];
    
    // Put all fieldNames containing "name" first for result screen
    NSArray *fieldNameArray = [[identification fieldNames] sortedArrayUsingComparator:^NSComparisonResult (id obj1, id obj2) {
            if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
                NSUInteger index1 = [[ALUniversalIDFieldnameUtil fieldNamesOrderArray] indexOfObject:obj1];
                NSUInteger index2 = [[ALUniversalIDFieldnameUtil fieldNamesOrderArray] indexOfObject:obj2];
                
                if (index2 == index1) {
                    return (NSComparisonResult)NSOrderedSame;
                } else if (index1 == NSNotFound && index2 != NSNotFound) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else if (index2 == NSNotFound && index1 != NSNotFound) {
                    return (NSComparisonResult)NSOrderedAscending;
                } else if (index2 > index1) {
                    return (NSComparisonResult)NSOrderedAscending;
                } else if (index1 > index2) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
            }
         return (NSComparisonResult)NSOrderedSame;
                
    }];
    NSMutableArray *fieldNames = [fieldNameArray mutableCopy];
    
    
    [fieldNames enumerateObjectsUsingBlock:^(NSString *fieldName, NSUInteger idx, BOOL *stop) {
        NSString *fieldNameTitle = [NSString stringWithFormat:@"%@%@", [ALUniversalIDFieldnameUtil camelCaseToTitleCaseModified:fieldName], titleSuffix];
        if (![fieldName containsString:@"String"]) {
            [resultData addObject:[[ALResultEntry alloc] initWithTitle:fieldNameTitle value:[identification valueForField:fieldName]]];
        }
        [resultHistoryString appendString:[NSString stringWithFormat:@"%@:%@\n", fieldNameTitle, [identification valueForField:fieldName]]];
    }];

    return resultData;
}



+ (NSString *)camelCaseToTitleCaseModified:(NSString *)inputString {
    NSString *strModified = [inputString stringByReplacingOccurrencesOfString:@"([a-z])([A-Z])"
                                                                        withString:@"$1 $2"
                                                                            options:NSRegularExpressionSearch
                                                                              range:NSMakeRange(0, inputString.length)];
    
    strModified = strModified.capitalizedString;
    
    strModified = [strModified stringByReplacingOccurrencesOfString:@"Of"
                                                         withString:@"of"
                                                            options:NSLiteralSearch
                                                              range:NSMakeRange(0, inputString.length)];
    
    return strModified;
}

+ (NSString *)camelCaseToTitleCase:(NSString *)inputString {
    NSString *str = [inputString copy];
    NSMutableString *str2 = [NSMutableString string];

    for (NSInteger i=0; i<str.length; i++){
        NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
        if ([ch rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound) {
            ch = ch.lowercaseString;
            [str2 appendString:@" "];
        }
        [str2 appendString:ch];
    }
    return [str2.capitalizedString copy];
}

@end


