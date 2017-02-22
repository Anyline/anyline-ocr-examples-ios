//
//  ALISBNAPI.m
//  ExampleApi
//
//  Created by David Dengg on 14.02.16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALISBNAPI.h"
#import "NSString+Util.h"
#import "ISBNInfo.h"
#import "ALJSONDownloader.h"

NSString * ISBNQueryURL = @"https://www.googleapis.com/books/v1/volumes?q=isbn:";

@implementation ALISBNAPI

- (instancetype)init {
    self = [super init];
    if (self) {
        _downloader = [[ALJSONDownloader alloc] init];
    }
    return self;
}

- (id)infoForISBN:(NSString *)isbn {
    // Return if the string is empty or nil
    if (isbn.length == 0) {
        return nil;
    }
    
    NSArray *removedSets = @[
                              [NSCharacterSet whitespaceAndNewlineCharacterSet],
                              [NSCharacterSet symbolCharacterSet],
                              [NSCharacterSet punctuationCharacterSet],
                              [NSCharacterSet letterCharacterSet],
                              ];
    
    for (id charSet in removedSets) {
        isbn = [isbn removeCharactersInSet:charSet];
    }
    // Query the google api for the informations
    NSString *url = [NSString stringWithFormat:@"%@%@", ISBNQueryURL, isbn];
    NSDictionary *isbnDict = [self.downloader jsonFromURL:url];
    if (![isbnDict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    // Create a info object with the result
    ISBNInfo *info = [[ISBNInfo alloc] initWithDict:isbnDict];

    return info;
}

- (NSString *)removeCharacters:(NSCharacterSet *)charSet inString:(NSString *)string {
    // Iterate a NSString until no more occurances of 'string' are found
    while ([string componentsSeparatedByCharactersInSet:charSet].count > 1) {
        string = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
    }
    
    return string;
}

@end
