//
//  ScanHistory+CoreDataProperties.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 13/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ScanHistory+CoreDataProperties.h"

@implementation ScanHistory (CoreDataProperties)

@dynamic timestamp;
@dynamic type;
@dynamic result;
@dynamic image;
@dynamic barcodeResult;

@end
