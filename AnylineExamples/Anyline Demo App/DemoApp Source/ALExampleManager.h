//
//  ALExampleManager.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 06.02.15.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALExample.h"

@interface ALExampleManager : NSObject

- (NSInteger)numberOfSections;

- (NSString *)titleForSectionIndex:(NSInteger)index;

- (NSInteger)numberOfExamplesInSectionIndex:(NSInteger)index;

- (ALExample *)exampleForIndexPath:(NSIndexPath *)indexPath;

@end
