//
//  ReadingTransformationPolicy.m
//  AnylineExamples
//
//  Created by Philipp Müller on 18/01/2018.
//  Copyright © 2018 9yards GmbH. All rights reserved.
//

#import "ReadingTransformationPolicy.h"


    
@interface ReadingTransformationPolicy()

@end

@implementation ReadingTransformationPolicy

- (NSString *)intToStringMethod:(NSInteger)number {
    return [NSString stringWithFormat: @"%ld", (long)number];
}

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError **)error {
    NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:[mapping destinationEntityName] inManagedObjectContext:[manager destinationContext]];
    
    // Copy all the values from sInstance into newObject, making sure to apply the conversion for the string to int when appropriate. So you should have one of these for each attribute:
    [newObject setValue:[sInstance valueForKey:@"ReadingValue"] forKey:@"ReadingValue"];
    
    [manager associateSourceInstance:sInstance withDestinationInstance:newObject forEntityMapping:mapping];
    
    return YES;
}

@end
