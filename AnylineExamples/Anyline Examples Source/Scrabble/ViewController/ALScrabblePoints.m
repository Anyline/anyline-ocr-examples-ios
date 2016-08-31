//
//  ALScrabblePoints.m
//  ExampleApi
//
//  Created by David Dengg on 11.02.16.
//  Copyright © 2016 9yards. All rights reserved.
//

#import "ALScrabblePoints.h"

@implementation ALScrabblePoints

+ (NSInteger)pointsForWord:(NSString *)word {
    word = [word uppercaseString];
    NSArray *letterPoints
    = @[
        @{@"1" : @[@"E", @"A", @"I", @"O", @"N", @"R", @"T", @"L", @"S", @"U"]},
        @{@"2" : @[@"D", @"G"]},
        @{@"3" : @[@"B", @"C", @"M", @"P"]},
        @{@"4" : @[@"F", @"H", @"V", @"W", @"Y"]},
        @{@"5" : @[@"K"]},
        @{@"8" : @[@"J", @"X"]},
        @{@"10" : @[@"Q", @"Z" ]}
        ];
    NSInteger totalPoints = 0;
    for (NSDictionary * pointsDict in letterPoints) {
        NSInteger points = [[[pointsDict allKeys] lastObject] intValue];
        NSArray * allLetters = [pointsDict valueForKey:[NSString stringWithFormat:@"%ld", (long)points]];
        for (NSString * character in allLetters) {
            NSInteger charPoints = [self occurencesOfChar:character inString:word]*points;
            totalPoints+=charPoints;
        }
    }
    return totalPoints;
}

+ (NSInteger)occurencesOfChar:(NSString *)ch inString:(NSString *)string {
    NSMutableString *strCopy = [string mutableCopy];
    return [strCopy replaceOccurrencesOfString:ch
                                    withString:@""
                                       options:NSLiteralSearch
                                         range:NSMakeRange(0, [string length])];

}

@end
