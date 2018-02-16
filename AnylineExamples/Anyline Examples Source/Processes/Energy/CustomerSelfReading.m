//
//  CustomerSelfReading.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "CustomerSelfReading.h"
#import "Customer.h"
#import "Reading.h"

#import "NSArray+ALExamplesAdditions.h"


@implementation CustomerSelfReading

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

- (NSArray *)customerCreatedReadings {
    NSMutableArray *readings = [NSMutableArray array];
    
    for (Customer *c in self.customers) {
        for (Reading *r in c.readings) {
            if (r.scannedImage) {
                [readings addObject:r];
            }
        }
    }
    
    return [[NSArray arrayWithArray:readings] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(sort)) ascending:YES]]];
}

@end
