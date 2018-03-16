//
//  ALScrabblePoints.h
//  ExampleApi
//
//  Created by David Dengg on 11.02.16.
//  Copyright © 2016 9yards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALScrabblePoints : NSObject
/**
 *  Pass the letters as a string
 *
 *  @param word   The letters as string
 *
 *  @return  An NSArray containing sub-arrays with ALScrabbleWord objects
 */
+ (NSInteger)pointsForWord:(NSString *)word;

@end
