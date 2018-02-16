//
//  ALJSONDownloader.m
//  ExampleApi
//
//  Created by David Dengg on 11.02.16.
//  Copyright © 2016 9yards. All rights reserved.
//

#import "ALJSONDownloader.h"

@implementation ALJSONDownloader

- (id)jsonFromURL:(NSString *)url {
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (jsonData.length == 0) {
        return nil;
    }
    
    NSError *jsonError;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    if(jsonError != nil) {
        return nil;
    }
    return json;
}

@end
