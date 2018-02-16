//
//  Reading.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "Reading.h"
#import "Customer.h"
#import <UIKit/UIKit.h>

@implementation Reading

- (NSString *)localizedReadingValue {
    return self.readingValue;
}

+ (Reading *)insertNewObjectWithReadingValue:(NSString *)readingValue
                                        sort:(NSNumber *)sort
                                scannedImage:(id)scannedImage
                                 readingDate:(NSDate *)readingDate
                                    customer:(Customer *)customer
                      inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                                       error:(NSError **)error {
    
    Reading *item = [NSEntityDescription insertNewObjectForEntityForName:@"Reading" inManagedObjectContext:managedObjectContext];
    
    item.readingDate = readingDate;
    item.readingValue = readingValue;
    item.scannedImage = scannedImage;
    item.sort = sort;
    item.customer = customer;
    
    [managedObjectContext save:error];
    
    return item;
}
    
@end


@implementation ScannedImage

+ (Class)transformedValueClass{
    return [UIImage class];
}

+ (BOOL)allowsReverseTransformation{
    return YES;
}

- (id)transformedValue:(id)value{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
