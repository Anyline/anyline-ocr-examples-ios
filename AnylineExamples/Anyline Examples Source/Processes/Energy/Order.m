//
//  Order.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "Order.h"
#import "Customer.h"
#import "NSArray+ALExamplesAdditions.h"

@implementation Order

- (NSArray *)customerMeterIDs {
    return [self.customers.allObjects map:^id(id object) {
        return ((Customer *)object).meterID;
    }];
}

- (Customer *)customerWithMeterID:(NSString *)meterID {
    return [self.customers.allObjects first:^BOOL(id object) {
        return [meterID hasPrefix:((Customer *)object).meterID];
    }];
}

- (NSInteger)completedCustomers {
    NSInteger count = 0;
    
    for (Customer *c in self.customers) {
        if (c.isCompleted.boolValue) {
            count++;
        }
    }
    
    return count;
}

@end
