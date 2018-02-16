//
//  CoreDataManager.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 26/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *localContext;

+ (instancetype)sharedInstance;

/**
 Sets up the core data stack and the necessary MOC etc. You must call this before making any other Core Data calls. 
 */
- (void)setupCoreData;

- (void)resetDemoData;

- (void)saveContext;
@end
