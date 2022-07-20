//
//  ALExampleManager.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 06.02.15.
//  Copyright (c) 2015 9yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALExample.h"

@interface ALExampleManager : NSObject

@property (nonatomic, strong) NSString *title;

@property BOOL canUpdate;

- (NSInteger)numberOfSections;

- (NSString *)titleForSectionIndex:(NSInteger)index;

- (NSInteger)numberOfExamplesInSectionIndex:(NSInteger)index;

- (ALExample *)exampleForIndexPath:(NSIndexPath *)indexPath;

@end
