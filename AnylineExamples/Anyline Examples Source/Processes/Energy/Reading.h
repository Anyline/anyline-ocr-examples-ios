//
//  Reading.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer;

NS_ASSUME_NONNULL_BEGIN

@interface Reading : NSManagedObject

@property (copy, nonatomic, readonly) NSString *localizedReadingValue;
    
+ (Reading *)insertNewObjectWithReadingValue:(NSString *)readingValue
                                        sort:(NSNumber *)sort
                                scannedImage:(id)scannedImage
                                 readingDate:(NSDate *)readingDate
                                    customer:(Customer *)customer
                 inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                                  error:(NSError **)error;
    
@end

@interface ScannedImage : NSValueTransformer
    
@end

NS_ASSUME_NONNULL_END

#import "Reading+CoreDataProperties.h"
