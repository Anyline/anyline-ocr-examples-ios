//
//  NSManagedObject+ALExamplesAdditions.h
//  AnylineExamples
//
//  Created by Philipp Müller on 30/01/18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (ALExamplesAdditions)

+ (nonnull NSString *)entityName;
- (BOOL)deleteEntityInContext:(nonnull NSManagedObjectContext *)context;
    
+ (nullable NSArray *)findAllWithPredicate:(nonnull NSPredicate *)searchTerm inContext:(nonnull NSManagedObjectContext *)context;
+ (nullable NSArray *)findAllInContext:(nonnull NSManagedObjectContext *)context;

+ (BOOL) truncateAllInContext:(nonnull NSManagedObjectContext *)context;
+ (id _Nullable )createEntityInContext:(nonnull NSManagedObjectContext *)context;

@end
