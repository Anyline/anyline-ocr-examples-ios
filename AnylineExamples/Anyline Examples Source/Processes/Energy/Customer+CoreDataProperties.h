//
//  Customer+CoreDataProperties.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Customer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Customer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *annualConsumption;
@property (nullable, nonatomic, retain) NSString *custromerID;
@property (nullable, nonatomic, retain) NSNumber *isCompleted;
@property (nullable, nonatomic, retain) NSNumber *isSynced;
@property (nullable, nonatomic, retain) NSString *meterID;
@property (nullable, nonatomic, retain) NSString *meterType;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *notes;
@property (nullable, nonatomic, retain) Order *order;
@property (nullable, nonatomic, retain) NSSet<Reading *> *readings;

@end

@interface Customer (CoreDataGeneratedAccessors)

- (void)addReadingsObject:(Reading *)value;
- (void)removeReadingsObject:(Reading *)value;
- (void)addReadings:(NSSet<Reading *> *)values;
- (void)removeReadings:(NSSet<Reading *> *)values;

@end

NS_ASSUME_NONNULL_END
