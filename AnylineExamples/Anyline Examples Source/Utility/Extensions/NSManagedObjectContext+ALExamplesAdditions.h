//
//  NSManagedObjectContext+ALExamplesAdditions.h
//  AnylineExamples
//
//  Created by Philipp Müller on 30/01/18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^SaveCompletionHandler)(BOOL contextDidSave, NSError  *error);

@interface NSManagedObjectContext (ALExamplesAdditions)

- (void)saveToPersistentStoreAndWait;
    
- (void)saveWithCompletion:(SaveCompletionHandler)completion isSynchronously:(BOOL)isSynchronously;

- (void)setWorkingName:(NSString *)workingName;

@end
