//
//  NSTimer+ALExamplesAdditions.h
//  AnylineExamples
//
//  Created by Philipp Müller on 29/01/18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ALExamplesAdditions)

+(NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats withBlock:(void(^)(void))block;

@end
