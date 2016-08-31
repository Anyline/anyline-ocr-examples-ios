


//
//  ISBNInfo.m
//  ExampleApi
//
//  Created by David Dengg on 14.02.16.
//  Copyright © 2016 9yards. All rights reserved.
//

#import "ISBNInfo.h"

@implementation ISBNInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    
    if (   !dict
        || ![dict isKindOfClass:[NSDictionary class]]
        || dict.count == 0) {
        return nil;
    }
    
    NSArray *items = [[dict valueForKey:@"items"] valueForKey:@"volumeInfo"];
    if (items.count == 0) {
        return nil;
    }
    
    NSDictionary *itemDict = items[0];
    
    if (self) {
        _title     = [ISBNInfo itemFromDict:itemDict identifier:@"title" defaultString:@"unknown"];
        _publisher = [ISBNInfo itemFromDict:itemDict identifier:@"publisher" defaultString:@"unknown"];
        _subtitle  = [ISBNInfo itemFromDict:itemDict identifier:@"subtitle" defaultString:nil];
        _year      = [ISBNInfo itemFromDict:itemDict identifier:@"publishedDate" defaultString:nil];
        _infoLink  = [ISBNInfo itemFromDict:itemDict identifier:@"infoLink" defaultString:nil];
        _pageCount = [ISBNInfo itemFromDict:itemDict identifier:@"pageCount" defaultString:nil];
        _rating    = [ISBNInfo itemFromDict:itemDict identifier:@"averageRating" defaultString:nil];
        _summary   = [ISBNInfo itemFromDict:itemDict identifier:@"description" defaultString:nil];
        
        _author    = [ISBNInfo concatItemsInArray:[itemDict valueForKey:@"authors"]];
        
        { // Thumbnail
            NSDictionary *images = [itemDict valueForKey:@"imageLinks"];
            if ([images isKindOfClass:[NSDictionary class]]) {
                NSString *imageLink = [images valueForKey:@"thumbnail"];
                if (imageLink.length == 0) {
                    imageLink = [images valueForKey:@"smallThumbnail"];
                }
                _thumbnailLink = imageLink;
            }
        }
        
        { // ISBN
            NSArray *industryIdentifiers = [itemDict valueForKey:@"industryIdentifiers"];
            
            for (NSDictionary *identifer in industryIdentifiers) {
                if (![identifer isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                if (
                    [identifer valueForKey:@"type"] &&
                    [[identifer valueForKey:@"type"] isKindOfClass:[NSString class]]
                    ) {
                    if ([[identifer valueForKey:@"type"] isEqualToString:@"ISBN_13"]) {
                        _isbn13 =  [identifer valueForKey:@"identifier"];
                    }
                    if ([[identifer valueForKey:@"type"] isEqualToString:@"ISBN_10"]) {
                        _isbn10 =  [identifer valueForKey:@"identifier"];
                    }
                    
                }
            }
        }
        
        
    }
    return self;
}

+ (NSString *)itemFromDict:(NSDictionary *)itemDict
                identifier:(NSString *)identifier
             defaultString:(NSString *)defaultString {
    NSString *retString;
    id item = [itemDict valueForKey:identifier];
    if ([item isKindOfClass:[NSString class]]) {
        retString = item;
        [(NSString *)item length] == 0 ? retString = defaultString : 0 ;
    }
    if ([item isKindOfClass:[NSNumber class]]) {
        retString = [NSString stringWithFormat:@"%ld", (long)[(NSNumber*)item integerValue]];
    }
    return retString;
}

+ (NSString *)concatItemsInArray:(NSArray *)itemsArr {
    NSMutableString *concString = [NSMutableString string];
    if(![itemsArr isKindOfClass:[NSArray class]] || itemsArr.count == 0) {
        return concString;
    }
    for (id item in itemsArr) {
        if ([item isKindOfClass:[NSString class]] && [(NSString *)item length] > 0) {
            concString.length > 0 ? [concString appendString:@", "] : 0;
            [concString appendString:item];
        }
    }
    return concString;
}

@end
