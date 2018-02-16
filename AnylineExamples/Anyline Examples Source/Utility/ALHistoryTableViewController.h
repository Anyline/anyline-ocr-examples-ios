//
//  ALHistoryTableViewController.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 24/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScanHistory.h"

@interface ALHistoryTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) ALScanHistoryType type;

@end
