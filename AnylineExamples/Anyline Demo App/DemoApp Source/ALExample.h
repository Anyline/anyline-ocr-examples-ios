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
@property (nonatomic) Class viewController;

- (instancetype)initWithName:(NSString *)name viewController:(Class)viewController;

@end
