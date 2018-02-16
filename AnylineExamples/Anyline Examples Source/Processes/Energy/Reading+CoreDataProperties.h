//
//  Reading+CoreDataProperties.h
//  
//
//  Created by Luka Mirosevic on 11/02/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Reading.h"

NS_ASSUME_NONNULL_BEGIN

@interface Reading (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *readingDate;
@property (nullable, nonatomic, retain) NSString *readingValue;
@property (nullable, nonatomic, retain) id scannedImage;
@property (nullable, nonatomic, retain) NSNumber *sort;
@property (nullable, nonatomic, retain) Customer *customer;

@end

NS_ASSUME_NONNULL_END
