//
//  NSManagedObject+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Philipp Müller on 30/01/18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "NSManagedObject+ALExamplesAdditions.h"

@implementation NSManagedObject (ALExamplesAdditions)

- (BOOL)deleteEntityInContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    NSManagedObject *entityInContext = [context existingObjectWithID:[self objectID] error:&error];

    if (error) {
        NSLog(@"Persitence Error: %@", [error localizedDescription]);
        return NO;
    }
    if (entityInContext) {
        [context deleteObject:entityInContext];
    }
    return YES;
}
    
+ (NSArray *)findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:searchTerm];
        
    return [self executeFetchRequest:request
                                inContext:context];
}
    
+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context {
    return [self executeFetchRequest:[self createFetchRequestInContext:context] inContext:context];
}
    
    
+ (NSFetchRequest *)createFetchRequestInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[self entityDescriptionInContext:context]];
    return request;
}
    
+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context {
    __block NSArray *results = nil;
    [context performBlockAndWait:^{
            
        NSError *error = nil;
        results = [context executeFetchRequest:request error:&error];
            
        if (results == nil) {
            if (error) {
                NSLog(@"Persitence Error: %@", [error localizedDescription]);
            }
        }
    }];
    return results;
}
    
+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context {
    NSString *entityName = [self entityName];
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
}
    
+ (NSString *)entityName {
    NSString *entityName;

    if ([entityName length] == 0) {
        // Remove module prefix from Swift subclasses
        entityName = [NSStringFromClass(self) componentsSeparatedByString:@"."].lastObject;
    }

    return entityName;
}

+ (BOOL)truncateAllInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setReturnsObjectsAsFaults:YES];
    [request setIncludesPropertyValues:NO];
    
    NSArray *objectsToDelete = [self executeFetchRequest:request inContext:context];
    for (NSManagedObject *objectToDelete in objectsToDelete)
    {
        [objectToDelete deleteEntityInContext:context];
    }
    return YES;
}

+ (id)createEntityInContext:(NSManagedObjectContext *)context {
    if ([self respondsToSelector:@selector(insertInManagedObjectContext:)] && context != nil)
    {
        id entity = [self performSelector:@selector(insertInManagedObjectContext:) withObject:context];
        return entity;
    }
    else
    {
        NSEntityDescription *entity  = [self entityDescriptionInContext:context];
        if (entity == nil)
        {
            return nil;
        }
        return [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    }
}



@end
