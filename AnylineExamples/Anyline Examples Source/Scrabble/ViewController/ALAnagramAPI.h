//
//  ALAnagramAPI.h
//  ExampleApi
//
//  Created by David Dengg on 11.02.16.
//  Copyright © 2016 9yards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALJSONDownloader.h"

extern NSString * AnagramBaseURL;

@interface ALAnagramAPI : NSObject

@property (nonatomic, strong) ALJSONDownloader *downloader;

/**
 *  Pass the letters as a string
 *
 *  @param letters   The letters as string
 *
 *  @return  An NSArray containing sub-arrays with ALScrabbleWord objects
 */
- (NSArray *)wordsForString:(NSString *)letters;

@end
