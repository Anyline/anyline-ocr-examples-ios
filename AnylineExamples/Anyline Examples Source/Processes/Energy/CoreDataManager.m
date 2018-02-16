//
//  CoreDataManager.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 26/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "CoreDataManager.h"
#import "Order+CoreDataProperties.h"
#import "Customer+CoreDataProperties.h"
#import "Reading+CoreDataProperties.h"
#import "CustomerSelfReading+CoreDataProperties.h"
#import "WorkforceTool+CoreDataProperties.h"
#import "NSManagedObjectContext+ALExamplesAdditions.h"
#import "NSManagedObject+ALExamplesAdditions.h"



static NSString * const kDatabaseSeeded = @"kDatabaseSeeded";
static NSString * const kUserEmailKey = @"kAnylineUserEmailKey";
static NSString * const kNumberOfTotalScansKey = @"kAnylineNumberOfTotalScansKey";

@interface CoreDataManager()

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end



@implementation CoreDataManager


+ (instancetype)sharedInstance {
    static CoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataManager alloc] init];
        [sharedInstance customInit];
    });
    return sharedInstance;
}

- (void)customInit {
    if (self) {
        self.localContext = self.managedObjectContext;
        if (![[NSUserDefaults standardUserDefaults]objectForKey:kDatabaseSeeded]) {
            [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:kDatabaseSeeded];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self seedTestData];
        }
    }
}

#pragma mark - Test Data

- (void)setupCoreData {
    // this method fetches the singleton, whose init method will set up core data. Technically this isn't necessary and a no-op would be suffiecient because this can only be called on the singleton, which only exists once it has been init'ed, but leaving here for clarity.
    [self.class sharedInstance];
}

- (void)resetDemoData{
    [self saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        [WorkforceTool truncateAllInContext:localContext];
        [CustomerSelfReading truncateAllInContext:localContext];
        [Reading truncateAllInContext:localContext];
    }];
    
    [self seedTestData];
}

- (void)seedTestData{
    [self saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        [self seedCustomerSelfReadingData];
        [self seedWorkforceTollData];
    }];
}

- (void)seedCustomerSelfReadingData{
    NSArray *customerData = [self serializeJSONWithName:@"energyMockData1"];
    
    CustomerSelfReading *csr = [CustomerSelfReading createEntityInContext:self.localContext];
    
    for (NSDictionary *dataSet in customerData) {
         [csr addCustomersObject:[self customerFromDataSet:dataSet]];
    }
}

- (void)seedWorkforceTollData{
    NSArray *orders = @[[self serializeJSONWithName:@"energyMockData1"], [self serializeJSONWithName:@"energyMockData2"]];

    WorkforceTool *workForce = [WorkforceTool createEntityInContext:self.localContext];

    int ordNr = 103;

    for (NSArray *orderData in orders) {

        Order *order = [Order createEntityInContext:self.localContext];
        order.orderNr = @(ordNr);
        [workForce addOrdersObject:order];

        for (NSDictionary *dataSet in orderData) {
            [order addCustomersObject:[self customerFromDataSet:dataSet]];
        }

        ordNr ++;
    }
}

- (Customer*)customerFromDataSet:(NSDictionary*)dataSet{
    Customer *customer = [Customer createEntityInContext:self.localContext];
    Reading *reading = [Reading createEntityInContext:self.localContext];
    [customer addReadingsObject:reading];

    customer.name = [[dataSet objectForKey:@"customer"] objectForKey:@"name"];

    NSArray *addressComponents = [[dataSet objectForKey:@"customer"] objectForKey:@"address"];
    customer.address = [NSString stringWithFormat:@"%@\n%@", addressComponents[0], addressComponents[1]];
    customer.notes = @"";

    if ([dataSet objectForKey:@"annualConsumption"]) {
        customer.annualConsumption = [dataSet objectForKey:@"annualConsumption"];
    }

    customer.meterID = [[dataSet objectForKey:@"meter"] objectForKey:@"id"];
    customer.meterType = [[dataSet objectForKey:@"meter"] objectForKey:@"type"];

    reading.readingValue = [[[dataSet objectForKey:@"lastReading"] objectForKey:@"value"] stringValue];
    reading.sort = @0;

    NSString *dateString = [[dataSet objectForKey:@"lastReading"] objectForKey:@"date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:posix];

    reading.readingDate = [dateFormatter dateFromString:dateString];

    return customer;
}


- (NSArray*)serializeJSONWithName:(NSString*)name{
    // get json form main bundle
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Error while loading JSON");
        return nil;
    }
    
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    // serialize json
    NSMutableArray *jsonRecipes = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"Error while serializing JSON");
        return nil;
    }
    
    return jsonRecipes;
}

- (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block {
//    NSManagedObjectContext *localContext;
    [self.localContext performBlockAndWait:^{
        [self.localContext setWorkingName:NSStringFromSelector(_cmd)];
        [self.localContext setName:@"AnylineContext"];
        if (block) {
            block(self.localContext);
        }
        [self.localContext saveWithCompletion:nil isSynchronously:YES];
    }];
}

#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "test.Test" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AnylineEnergyModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AnylineEnergyModel.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
                                                           error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
