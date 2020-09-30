//
//  ALExample.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 06.02.15.
//  Copyright (c) 2015 9yards GmbH. All rights reserved.
//

#import "ALExample.h"

@implementation ALExample

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
              viewController:(Class)viewController {
    self = [super init];
    if (self) {
        _name = name;
        _image = image;
        _viewController = viewController;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
              viewController:(Class)viewController
                       title:(NSString *)title {
    self = [super init];
    if (self) {
        _name = name;
        _image = image;
        _viewController = viewController;
        _navTitle = title;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
              viewController:(Class)viewController
              exampleManager:(Class)exampleManager {
    self = [super init];
    if (self) {
        _name = name;
        _image = image;
        _viewController = viewController;
        _exampleManager = exampleManager;
    }
    return self;
}


- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
              viewController:(Class)viewController
                       pages:(NSArray *)pages {
    self = [super init];
    if (self) {
        _name = name;
        _image = image;
        _viewController = viewController;
        _pages = pages;
    }
    return self;
    
    
}

@end
