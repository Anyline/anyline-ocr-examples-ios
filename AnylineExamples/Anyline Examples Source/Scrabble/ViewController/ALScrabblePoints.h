//
//  ALScrabblePoints.h
//  ExampleApi
//
//  Created by David Dengg on 11.02.16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALScrabblePoints : NSObject
/**
 *  Pass the letters as a string
 *
 *  @param letters   The letters as string
 *
 *  @return  An NSArray containing sub-arrays with ALScrabbleWord objects
 */
+ (NSInteger)pointsForWord:(NSString *)word;

@end
