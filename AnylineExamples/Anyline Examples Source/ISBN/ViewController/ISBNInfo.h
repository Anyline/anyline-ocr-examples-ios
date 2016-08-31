//
//  ISBNInfo.h
//  ExampleApi
//
//  Created by David Dengg on 14.02.16.
//  Copyright © 2016 9yards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISBNInfo : NSObject

@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *publisher;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *previewLink;
@property (nonatomic, strong) NSString *pageCount;
@property (nonatomic, strong) NSString *isbn13;
@property (nonatomic, strong) NSString *isbn10;
@property (nonatomic, strong) NSString *infoLink;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *thumbnailLink;
@property (nonatomic, strong) NSString *subtitle;

/**
 *  Pass a dictionary downloaded from googles ISBN service
 *
 *  @param dict The dictionary containing the information
 *
 *  @return  New ISBNInfo object
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
