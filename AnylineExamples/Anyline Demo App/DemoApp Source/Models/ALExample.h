//
//  ALExample.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 06.02.15.
//  Copyright (c) 2015 9yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ALExample : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) Class viewController;
@property (nonatomic) Class exampleManager;
@property (nonatomic, strong) NSArray *pages;

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
              viewController:(Class)viewController;

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
              viewController:(Class)viewController
              exampleManager:(Class)exampleManager;

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
              viewController:(Class)viewController
                       pages:(NSArray *)pages;

@end
