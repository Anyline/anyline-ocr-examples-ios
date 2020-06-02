//
//  ALBaseGridCollectionViewController.h
//  AnylineExamples
//
//  Created by Philipp Müller on 22/11/2017.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALExampleManager.h"

@interface ALBaseGridCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) ALExampleManager *exampleManager;
@property (nonatomic) BOOL showLogo;

- (CGSize)headerSize;
- (void)openExample:(ALExample *)example;

@end
