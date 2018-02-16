//
//  NSArray+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Philipp Müller on 29/01/18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "NSArray+ALExamplesAdditions.h"

@implementation NSArray (ALExamplesAdditions)

- (id)first:(BOOL(^)(id object))function {
    NSInteger index = [self indexOfFirst:function];
    
    if (index != NSNotFound) {
        return [self objectAtIndex:index];
    }
    else {
        return nil;
    }
}
    
- (NSArray *)map:(id(^)(id object))function {
    return [self mapWithIndex:^id(id object, NSUInteger index) {
        if (function) {
            return function(object);
        } else {
            return nil;
        }
    }];
}
    
- (NSUInteger)indexOfFirst:(BOOL(^)(id object))function {
    NSUInteger count = self.count;
    for (NSUInteger i=0; i<count; i++) {
        id myObject = [self objectAtIndex:i];
        if (function(myObject)) return i;
    }
    
    //if we got here it means we didn't find any
    return NSNotFound;
}
    
- (NSArray *)mapWithIndex:(id(^)(id object, NSUInteger index))function {
    //creates a results array in which to store results, presets the capacity for faster writes
    NSUInteger count = self.count;
    NSMutableArray *resultsArray = [[NSMutableArray alloc] initWithCapacity:count];
    
    //applies the function to each item and stores the result in the new array, except if it's nil
    for (NSUInteger i=0; i<count; i++) {
        id mappedObject = function(self[i], i);
        if (mappedObject) {
            resultsArray[i] = mappedObject;
        }
        else {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Mapping function must return a non-nil object" userInfo:nil];
        }
    }
    
    //returns an immutable copy
    return [resultsArray copy];
}

    
@end
