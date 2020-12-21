//
//  UniversalIDFieldnameMap.h
//  AnylineExamples
//
//  Created by Philipp Müller on 19.09.20.
//

#import <Foundation/Foundation.h>
#import "Anyline/Anyline.h"
#import "ALResultEntry.h"

@interface ALUniversalIDFieldnameUtil : NSObject

+ (NSArray *)fieldNamesOrderArray;

+ (NSMutableArray<ALResultEntry *> *)addIDSubResult:(ALUniversalIDIdentification*)identification titleSuffix:(NSString *)titleSuffix resultHistoryString:(NSMutableString *)resultHistoryString;
+ (NSString *)camelCaseToTitleCaseModified:(NSString *)inputString;
+ (NSString *)camelCaseToTitleCase:(NSString *)inputString;
+ (BOOL)isPassportForUniversalIDIdentification:(ALUniversalIDIdentification *)identification;
@end
