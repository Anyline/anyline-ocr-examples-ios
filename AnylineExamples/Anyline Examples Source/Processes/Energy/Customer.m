//
//  Customer.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "Customer.h"
#import "Order.h"
#import "Reading.h"

@implementation Customer

- (Reading *)lastReading {
    return [[[self.readings allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(readingDate)) ascending:YES]]] lastObject];
}

@end
