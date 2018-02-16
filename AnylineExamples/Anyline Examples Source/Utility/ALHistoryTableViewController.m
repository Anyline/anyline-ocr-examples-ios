//
//  ALHistoryTableViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 24/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALHistoryTableViewController.h"
#import "ALHistoryCell.h"

#import "ScanHistory.h"

#import <CoreData/CoreData.h>

@interface ALHistoryTableViewController () <NSFetchedResultsControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *historyFetchedResultController;
@property (nonatomic, strong) ALHistoryCell *historyCell;


@end

@implementation ALHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"History";
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ALHistoryCell class] forCellReuseIdentifier:@"historyTableCell"];
    
    self.historyFetchedResultController = [self createFetchedResultController];
    
    UIBarButtonItem * deleteBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbar_trash"] style:UIBarButtonItemStylePlain target:self action:@selector(askToDeleteItems:)];
    self.navigationItem.rightBarButtonItem = deleteBarItem;

}

-(void)askToDeleteItems:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Delete this history?"
                                message:@"All entries in this list will be deleted."
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Delete All", nil] show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self deleteItems:nil];
    }
}


-(void)deleteItems:(id)sender {
    NSError *error;
    self.historyFetchedResultController.delegate = nil;
    
    for (id cdobject in [self.historyFetchedResultController fetchedObjects]) {
        [self.managedObjectContext deleteObject:cdobject];
    }
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Delete message error %@, %@", error, [error userInfo]);
    }
    self.historyFetchedResultController.delegate = self;
    if (![self.historyFetchedResultController performFetch:&error]) {
        NSLog(@"fetchMessages error %@, %@", error, [error userInfo]);
    }
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ALHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyTableCell" forIndexPath:indexPath];
    ScanHistory *item = [self.historyFetchedResultController objectAtIndexPath:indexPath];
    cell = [self setupCell:cell withItem:item indexPath:indexPath];
    return cell;
}

- (ALHistoryCell*)setupCell:(ALHistoryCell*)cell withItem:(ScanHistory*)item indexPath:(NSIndexPath*)indexPath {
    NSDate * date = item.timestamp;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [cell setScannedImage:[[UIImage alloc] initWithData:item.image]];
    cell.leftLabel.text = [dateFormatter stringFromDate:date];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    cell.rightLabel.text = [dateFormatter stringFromDate:date];
    [cell setMainText:item.result];
    if (![item.barcodeResult isEqualToString:@""] && item.barcodeResult.length > 0) {
        cell.barcodeResultLabel.text = item.barcodeResult;
        cell.barcodeResultLabel.hidden = false;
        cell.barcodeLabel.hidden = false;
    }
    return cell;
}

- (NSFetchedResultsController *)createFetchedResultController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ScanHistory"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    //Fetch all data from ScanHistory
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
                                              initWithFetchRequest:fetchRequest
                                              managedObjectContext:self.managedObjectContext
                                              sectionNameKeyPath:nil
                                              cacheName:nil];
    controller.delegate = self;
    NSError *error;
    BOOL success = [controller performFetch:&error];
    if (!success && error) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                   message:@"The data store is corrupt. Please reinstall this application"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil] show];
    }
    return controller;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.historyFetchedResultController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.historyFetchedResultController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.historyFetchedResultController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    if (type == NSFetchedResultsChangeDelete) {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSManagedObject* eventToDelete = [self.historyFetchedResultController objectAtIndexPath:indexPath];
        [self.historyFetchedResultController.managedObjectContext deleteObject:eventToDelete];

        NSError* error;
        if (![self.historyFetchedResultController.managedObjectContext save:&error])
        {
            // Handle the error.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);
        }
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark fetched results controller delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.historyCell == nil) {
        self.historyCell = [[ALHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"historyTableCell"];
    }

    ScanHistory *item = [self.historyFetchedResultController objectAtIndexPath:indexPath];
    ALHistoryCell * cell = [self setupCell:self.historyCell withItem:item indexPath:indexPath];
    [cell layoutIfNeeded];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];

    return cell.cellHeight;
}

@end
