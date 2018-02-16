//
//  ScanHistory+CoreDataProperties.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 13/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ScanHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScanHistory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSString *result;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *barcodeResult;

@end

NS_ASSUME_NONNULL_END
