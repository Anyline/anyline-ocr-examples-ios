//
//  ALAnagramAPI.m
//  ApiTest
//
//  Created by David Dengg on 11.02.16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALAnagramAPI.h"
#import "ALScrabblePoints.h"
#import "NSString+Util.h"
#import "ALScrabbleWord.h"

const NSString * AnagramBaseURL = @"http://www.anagramica.com/all/";

@implementation ALAnagramAPI

- (instancetype)init {
    self = [super init];
    if (self) {
        _downloader = [[ALJSONDownloader alloc] init];
    }
    return self;
}

- (NSArray *)wordsForString:(NSString *)letters {
    // Return an empty array if string is empty
    if (letters.length == 0) {
        return @[];
    }
    
    // Clean the string a little bit
    NSArray *removedSets = @[
                             [NSCharacterSet whitespaceAndNewlineCharacterSet],
                             [NSCharacterSet symbolCharacterSet],
                             [NSCharacterSet punctuationCharacterSet],
                             ];
    
    for (id charSet in removedSets) {
        letters = [letters removeCharactersInSet:charSet];
    }
    
    // Perform the API call
    NSString *url = [NSString stringWithFormat:@"%@%@", AnagramBaseURL, letters];
    NSDictionary *anagrams = [self.downloader jsonFromURL:url];
    if (![anagrams isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSArray *allAnagrams = [anagrams valueForKey:@"all"];
    
    // Create an array that contains the words with their corresponding points
    NSMutableArray *wordsAndPoints = [NSMutableArray array];
    for (NSString *word in allAnagrams) {
        if (word.length <= 1 ) {
            continue;
        }
        NSInteger points = [self pointsForWord:word];
        [wordsAndPoints addObject:@{ @"points" : @(points),  @"word" : word}];
    }

    // Sort the array to place the top ranking words first
    [wordsAndPoints sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[obj2 valueForKey:@"points"] compare: [obj1 valueForKey:@"points"]];
    }];
    
    NSArray *tenWords = [wordsAndPoints subarrayWithRange:NSMakeRange(0, MIN(10, wordsAndPoints.count))];
    
    NSMutableArray *returnArray = [NSMutableArray array];
    NSInteger lastPoints = 99;
    
    // Create an array with sub-arrays containing ALScrabbleWord objects.
    // This format was chosen is in preperation for the UITableView
    for (NSDictionary *word in tenWords) {
        ALScrabbleWord *sw = [[ALScrabbleWord alloc] init];
        sw.word   = [word valueForKey:@"word"];
        sw.points = [[word valueForKey:@"points"] intValue];
        
        NSMutableArray *marr;
        if(lastPoints == sw.points) {
            marr = returnArray[returnArray.count-1];
        } else {
            marr = [NSMutableArray array];
            [returnArray addObject:marr];
        }
        lastPoints = sw.points;
        [marr addObject:sw];
    }
    return returnArray;
}

- (NSInteger)pointsForWord:(NSString *)word {
    return [ALScrabblePoints pointsForWord:word];
}


@end

