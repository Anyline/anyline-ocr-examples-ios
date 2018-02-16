//
//  CustomerSelfReading.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer;

NS_ASSUME_NONNULL_BEGIN

@interface CustomerSelfReading : NSManagedObject

- (NSArray*)customerMeterIDs;

- (Customer*)customerWithMeterID:(NSString*)meterID;

- (NSArray*)customerCreatedReadings;

@end

NS_ASSUME_NONNULL_END

#import "CustomerSelfReading+CoreDataProperties.h"
