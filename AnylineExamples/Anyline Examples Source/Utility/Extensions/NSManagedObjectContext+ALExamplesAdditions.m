//
//  NSManagedObjectContext+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Philipp Müller on 30/01/18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "NSManagedObjectContext+ALExamplesAdditions.h"

@implementation NSManagedObjectContext (ALExamplesAdditions)

- (void)saveToPersistentStoreAndWait {
    [self saveWithCompletion:nil isSynchronously:YES];
}
    
- (void)saveWithCompletion:(SaveCompletionHandler)completion isSynchronously:(BOOL)isSynchronously {
    __block BOOL hasChanges = NO;
        
    if ([self concurrencyType] == NSConfinementConcurrencyType) {
            hasChanges = [self hasChanges];
    } else {
        [self performBlockAndWait:^{
            hasChanges = [self hasChanges];
        }];
    }
    if (!hasChanges) {
        NSLog(@"ObjectContext: NO CHANGES. Nothing has been saved.");
            
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, nil);
            });
        }
            
        return;
    }
        
    id saveBlock = ^{
        BOOL saveResult = NO;
        NSError *error = nil;
            
        @try {
            saveResult = [self save:&error];
        } @catch(NSException *exception) {
            NSLog(@"ObjectContext: Unable to perform save: %@", (id)[exception userInfo] ?: (id)[exception reason]);
        } @finally {
            if (error) {
                NSLog(@"ObjectContext Error: %@", [error localizedDescription]);
                return;
            }
                
            if (saveResult && [self parentContext]) {
                [[self parentContext] saveWithCompletion:completion isSynchronously:isSynchronously];
            } else {
                if (saveResult) {
                    NSLog(@"ObjectContext: Context was saved.");
                }
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(saveResult, error);
                    });
                }
            }
        }
    };
    
    if (isSynchronously) {
        [self performBlockAndWait:saveBlock];
    } else {
        [self performBlock:saveBlock];
    }
    
}
    
- (void)setWorkingName:(NSString *)workingName {
    void (^setWorkingName)(void) = ^{
        [[self userInfo] setObject:workingName forKey:@"AnylineWorkingName"];
    };
    
    if (self.concurrencyType == NSMainQueueConcurrencyType && [NSThread isMainThread]) {
        setWorkingName();
    } else {
        [self performBlockAndWait:setWorkingName];
    }
}
    
@end
