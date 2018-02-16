//
//  ReadingTransformationPolicy.h
//  AnylineExamples
//
//  Created by Philipp Müller on 18/01/2018.
//  Copyright © 2018 Anylien GmbH. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ReadingTransformationPolicy : NSEntityMigrationPolicy

- (NSString *)intToStringMethod:(NSInteger)number;

@end
