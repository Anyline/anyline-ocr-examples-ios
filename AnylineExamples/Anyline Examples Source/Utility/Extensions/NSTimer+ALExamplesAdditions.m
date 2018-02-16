//
//  NSTimer+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Philipp Müller on 29/01/18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "NSTimer+ALExamplesAdditions.h"

@implementation NSTimer (ALExamplesAdditions)

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats withBlock:(void(^)(void))block {
    return [self _timerFactory:interval repeats:repeats withBlock:block shouldSchedule:NO];
}
    
+ (NSTimer *)_timerFactory:(NSTimeInterval)interval repeats:(BOOL)repeats withBlock:(void(^)(void))block shouldSchedule:(BOOL)shouldSchedule {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:@selector(callBlock:)]];
    NSTimer *timer = shouldSchedule ?
    [NSTimer scheduledTimerWithTimeInterval:interval invocation:invocation repeats:repeats] :
    [NSTimer timerWithTimeInterval:interval invocation:invocation repeats:repeats];
    
    [invocation setTarget:timer];
    [invocation setSelector:@selector(callBlock:)];
    
    void(^copy)(void) = [block copy];
    [invocation setArgument:&copy atIndex:2];
    
    return timer;
}
    
- (void)callBlock:(void(^)(void))block {
    block();
}
@end
