//
//  Order.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer;

NS_ASSUME_NONNULL_BEGIN

@interface Order : NSManagedObject

- (NSInteger)completedCustomers;

- (NSArray*)customerMeterIDs;

- (Customer*)customerWithMeterID:(NSString*)meterID;

@end

NS_ASSUME_NONNULL_END

#import "Order+CoreDataProperties.h"
