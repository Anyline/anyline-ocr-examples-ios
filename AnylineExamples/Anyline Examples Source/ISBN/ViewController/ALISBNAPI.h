//
//  ALISBNAPI.h
//  ExampleApi
//
//  Created by David Dengg on 14.02.16.
//  Copyright © 2016 9yards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALJSONDownloader.h"

extern NSString * ISBNQueryURL;

@class ISBNInfo;

@interface ALISBNAPI : NSObject

@property (nonatomic, strong) ALJSONDownloader *downloader;

/**
 *  Pass the ISBN of a book to search for the corresponding information
 *
 *  @param isbn   The ISBN as a string
 *
 *  @return  New ISBNInfo object
 */
- (ISBNInfo *)infoForISBN:(NSString *)isbn;

@end
