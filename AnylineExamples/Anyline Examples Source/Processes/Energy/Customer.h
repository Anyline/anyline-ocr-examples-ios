//
//  Customer.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order, Reading;

NS_ASSUME_NONNULL_BEGIN

@interface Customer : NSManagedObject

@property (strong, nonatomic, readonly) Reading *lastReading;

@end

NS_ASSUME_NONNULL_END

#import "Customer+CoreDataProperties.h"
