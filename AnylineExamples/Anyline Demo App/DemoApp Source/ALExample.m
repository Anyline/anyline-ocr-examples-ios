//
//  ALExample.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 06.02.15.
//  Copyright (c) 2015 9yards GmbH. All rights reserved.
//

#import "ALExample.h"

@implementation ALExample

- (instancetype)initWithName:(NSString *)name viewController:(Class)viewController {
    self = [super init];
    if (self) {
        _name = name;
        _viewController = viewController;
    }
    return self;
}

@end
