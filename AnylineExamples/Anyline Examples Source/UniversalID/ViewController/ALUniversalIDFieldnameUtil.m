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

+ (NSArray *)sortResultData:(NSArray *)resultData {
    NSArray *priorityFieldsArray = [ALUniversalIDFieldnameUtil fieldNamesOrderArray];
    NSArray *sortedArray = [resultData sortedArrayUsingComparator:^NSComparisonResult(ALResultEntry *entry1, ALResultEntry *entry2) {
        NSUInteger index1 = [priorityFieldsArray indexOfObjectPassingTest:^BOOL(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
            return [entry1.title localizedCaseInsensitiveContainsString:title];
        }];
        NSUInteger index2 = [priorityFieldsArray indexOfObjectPassingTest:^BOOL(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
            return [entry2.title localizedCaseInsensitiveContainsString:title];
        }];
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
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedArray;
}

+ (NSArray *)fieldNamesOrderArray {
    NSArray *array = @[
        @"name",
        @"surname",
        @"lastName",
        @"givenNames",
        @"firstName",
        @"dateOfBirth",
        @"placeOfBirth",
        @"dateOfIssue",
        @"dateOfExpiry",
        @"documentNumber",
        @"layoutDefinition.country",
        @"formattedDateOfBirth",
        @"formattedDateOfIssue",
        @"formattedDateOfExpiry",
    ];
    return [array copy];
}

+ (NSArray *)fieldNamesWithSpaceOrderArray {
    NSArray *array = @[
        @"name",
        @"surname",
        @"lastName",
        @"given Names",
        @"first Name",
        @"date Of Birth",
        @"place Of Birth",
        @"date Of Issue",
        @"date Of Expiry",
        @"document Number",
        @"country",
    ];
    return [array copy];
}

+ (NSArray *)sortResultDataUsingFieldNamesWithSpace:(NSArray *)resultData {
    NSArray *priorityFieldsArray = [ALUniversalIDFieldnameUtil fieldNamesWithSpaceOrderArray];
    NSArray *sortedArray = [resultData sortedArrayUsingComparator:^NSComparisonResult(ALResultEntry *entry1, ALResultEntry *entry2) {
        NSUInteger index1 = [priorityFieldsArray indexOfObjectPassingTest:^BOOL(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
            return [entry1.title localizedCaseInsensitiveContainsString:title];
        }];
        NSUInteger index2 = [priorityFieldsArray indexOfObjectPassingTest:^BOOL(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
            return [entry2.title localizedCaseInsensitiveContainsString:title];
        }];
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
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedArray;
}

+ (NSMutableArray<ALResultEntry *> *)addIDSubResult:(ALUniversalIDIdentification*)identification titleSuffix:(NSString *)titleSuffix resultHistoryString:(NSMutableString *)resultHistoryString {
    
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    NSMutableArray<ALResultEntry *> *resultData = [[NSMutableArray alloc] init];
    
    NSMutableOrderedSet *baseSet = [NSMutableOrderedSet orderedSetWithArray:[ALUniversalIDFieldnameUtil fieldNamesOrderArray]];
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:[identification fieldNames]];
    
    [baseSet unionOrderedSet:orderedSet];
    
    NSArray *fieldNames = [baseSet array];
    NSArray *fieldsNamesWithSpace = [self fieldNamesWithSpaceOrderArray];
    
    [fieldNames enumerateObjectsUsingBlock:^(NSString *fieldName, NSUInteger idx, BOOL *stop) {
        NSString *fieldNameTitle = [NSString stringWithFormat:@"%@%@", [ALUniversalIDFieldnameUtil camelCaseToTitleCaseModified:fieldName], titleSuffix];
        if (![fieldName localizedCaseInsensitiveContainsString:@"String"] &&
            ![fieldName localizedCaseInsensitiveContainsString:@"checkdigit"] &&
            ![fieldName localizedCaseInsensitiveContainsString:@"confidence"] &&
            [identification valueForField:fieldName] &&
            [[[identification valueForField:fieldName] stringByTrimmingCharactersInSet: set] length] > 0) {
            
            if (![fieldName localizedCaseInsensitiveContainsString:@"formatted"]) {
                __block ALResultEntry *newEntry = [[ALResultEntry alloc] initWithTitle:fieldNameTitle value:[identification valueForField:fieldName]];
                [fieldsNamesWithSpace enumerateObjectsUsingBlock:^(NSString  * _Nonnull fieldname, NSUInteger idx, BOOL * _Nonnull stop) {
                    BOOL isMandatory = [fieldname localizedCaseInsensitiveCompare:newEntry.title] == NSOrderedSame;
                    [newEntry setIsMandatory:isMandatory];
                    *stop = isMandatory;
                }];
                [resultData addObject:newEntry];
            } else {
                [resultData enumerateObjectsUsingBlock:^(ALResultEntry * _Nonnull entry, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([[entry title] localizedCaseInsensitiveContainsString:[fieldNameTitle stringByReplacingOccurrencesOfString:@"Formatted " withString:@""]]) {
                        [entry setValue:[identification valueForField:fieldName]];
                    }
                }];
            }
            
            [resultHistoryString appendString:[NSString stringWithFormat:@"%@:%@\n", fieldNameTitle, [identification valueForField:fieldName]]];
        }
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


+ (BOOL)isPassportForUniversalIDIdentification:(ALUniversalIDIdentification *)identification {
    
    BOOL isPassportDocumentType = false;
    
    if ([identification hasField:@"documentType"]) {
        NSString *documentType = [identification valueForField:@"documentType"];
        NSRange firstLetterRange = NSMakeRange(0, 1);
        isPassportDocumentType = [[documentType substringWithRange:firstLetterRange] isEqualToString:@"P"] || [[documentType substringWithRange:firstLetterRange] isEqualToString:@"V"];
         
    }

    return [identification.layoutDefinition.type isEqualToString:@"mrz"] && isPassportDocumentType;
}

@end


